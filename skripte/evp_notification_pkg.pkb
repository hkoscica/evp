/* Formatted on 18/6/2024/ 18:10:11 (QP5 v5.391) */
create or replace package body wksp_evp.evp_notification_pkg
as
  gc_app_id         constant number := 111;
  gc_priority_user  constant number := 1;
  gc_priority_role  constant number := 2;
  gc_priority_all   constant number := 3;

  --priority IN ( 'HIGH', 'LOW', 'NO', 'URGENT' )
  --type IN ( 'APP', 'E-MAIL' )


  type tt_notification is table of wksp_evp.evp_vehicle_notification%rowtype;

  --Set notification user activity type
  procedure p_set_nua_act_type (
    p_i_ven_id   in wksp_evp.evp_vehicle_notification.id%type
   ,p_i_act_typ  in wksp_evp.evp_notification_user_act.activity_type%type default 'OPENED')
  is
  begin
    insert into wksp_evp.evp_notification_user_act (
                  notification_id
                 ,activity_type)
         values (p_i_ven_id, p_i_act_typ);
  end p_set_nua_act_type;

  --Set all unread notification user activity type
  procedure p_set_nua_act_type (
    p_i_app_user  in varchar2
   ,p_i_act_typ   in wksp_evp.evp_notification_user_act.activity_type%type default 'DISMISSED')
  is
  begin
    insert into wksp_evp.evp_notification_user_act (
                  notification_id
                 ,activity_type)
      (select ven.id, p_i_act_typ
         from wksp_evp.evp_vehicle_notification ven
              left join wksp_evp.evp_notification_user_act nua
                   on nua.notification_id = ven.id
        where ven.receiver = p_i_app_user and nua.id is null);
  end p_set_nua_act_type;

  --Insert notification
  procedure p_insert_notification (
    p_i_receiver  in wksp_evp.evp_vehicle_notification.receiver%type
   ,p_i_title     in wksp_evp.evp_vehicle_notification.title%type
   ,p_i_content   in wksp_evp.evp_vehicle_notification.content%type
   ,p_i_sender    in wksp_evp.evp_vehicle_notification.sender%type
   ,p_i_meta      in wksp_evp.evp_vehicle_notification.metadata%type default 'NO'
   ,p_i_type      in wksp_evp.evp_vehicle_notification.type%type default 'APP'
   ,p_i_priority  in wksp_evp.evp_vehicle_notification.priority%type default 'LOW')
  is
  begin
    insert into wksp_evp.evp_vehicle_notification (
                  receiver
                 ,title
                 ,content
                 ,sender
                 ,metadata
                 ,type
                 ,priority)
         values (
                  p_i_receiver
                 ,p_i_title
                 ,p_i_content
                 ,p_i_sender
                 ,p_i_meta
                 ,p_i_type
                 ,p_i_priority);
  end p_insert_notification;

  --Set notifications for users or group or all if p_i_app_user and p_i_role = '-'
  procedure p_set_veh_notification (
    p_notification  wksp_evp.evp_vehicle_notification%rowtype
   ,p_i_app_user    varchar2 default null
   ,p_i_role        varchar2 default null)
  is
    cursor cur_users (i_priority number)
    is
      select distinct user_name
        from apex_appl_acl_user_roles
       where application_id = gc_app_id
             and (   (user_name = p_i_app_user
                      and i_priority = gc_priority_user)
                  or (role_static_id = p_i_role
                      and i_priority = gc_priority_role)
                  or (i_priority = gc_priority_all));

    v_priority  number;
  begin
    /*
     select * from APEX_APPL_ACL_USER_ROLES
     iz ovo g upita proleti po userima, prioritet je app_user pa rola i njima šalji obavijesti
     napravi dio za email ali neka bude prazan
    */
    v_priority :=
      case
        when p_i_app_user is not null then gc_priority_user
        when p_i_role is not null then gc_priority_role
        when p_i_app_user = '-' and p_i_role = '-' then gc_priority_all
        else 0
      end;

    for usr in cur_users (v_priority)
    loop
      p_insert_notification (
        p_i_receiver  => usr.user_name
       ,p_i_title     => p_notification.title
       ,p_i_content   => p_notification.content
       ,p_i_sender    => p_notification.sender
       ,p_i_meta      => p_notification.metadata
       ,p_i_type      => p_notification.type
       ,p_i_priority  => p_notification.priority);
    end loop;
  end p_set_veh_notification;

  --prepare table type for technical inspection notifications
  procedure p_prepare_tin_notification (
    p_o_notifications  in out tt_notification)
  is
    v_notification_empty  wksp_evp.evp_vehicle_notification%rowtype := null;
    v_notification        wksp_evp.evp_vehicle_notification%rowtype;
  begin
    for i_tin
      in (with
            tin_max
            as
              (  select vehicle_id, max (valid_to) max_valid_to
                   from wksp_evp.evp_technical_inspection
               group by vehicle_id)
          select *
            from wksp_evp.evp_vehicle vhl
                 join tin_max
                      on tin_max.vehicle_id = vhl.id
           where trunc (tin_max.max_valid_to) <= trunc (sysdate + 30)
                 and trunc (tin_max.max_valid_to) > trunc (sysdate))
    loop
      v_notification := v_notification_empty;

      v_notification.title :=
        i_tin.plate_number || ' - ISTEK TEHNIČKE ISPRAVNOSTI VOZILA';
      v_notification.content :=
        'Tehnička ispravnost vozila ' || i_tin.plate_number ||
        ', vrijedi do: ' || to_char (i_tin.max_valid_to, 'DD.MM.YYYY.') ||
        ' Obavite tehnički pregled na vrijeme!';
      v_notification.sender := 'SYSTEM';
      v_notification.metadata := 'NO';
      v_notification.type := 'APP';
      v_notification.priority := 'LOW';

      p_o_notifications.extend;
      p_o_notifications (p_o_notifications.last) := v_notification;
    end loop;
  end p_prepare_tin_notification;

  --prepare table type for insurance notifications
  procedure p_prepare_vei_notification (
    p_o_notifications  in out tt_notification)
  is
    v_notification_empty  wksp_evp.evp_vehicle_notification%rowtype := null;
    v_notification        wksp_evp.evp_vehicle_notification%rowtype;
  begin
    for i_vei
      in (with
            vei_max
            as
              (  select vehicle_id, max (valid_to) max_valid_to
                   from wksp_evp.evp_vehicle_insurance
               group by vehicle_id)
          select *
            from wksp_evp.evp_vehicle vhl
                 join vei_max
                      on vei_max.vehicle_id = vhl.id
           where trunc (vei_max.max_valid_to) <= trunc (sysdate + 30)
                 and trunc (vei_max.max_valid_to) > trunc (sysdate))
    loop
      v_notification := v_notification_empty;

      v_notification.title :=
        i_vei.plate_number || ' - ISTEK POLICE OBVEZNOG OSIGURANJA VOZILA';
      v_notification.content :=
        'Polica osiguranja vozila ' || i_vei.plate_number ||
        ', vrijedi do: ' || to_char (i_vei.max_valid_to, 'DD.MM.YYYY.') ||
        ' Obnovite policu osiguranja na vrijeme!';
      v_notification.sender := 'SYSTEM';
      v_notification.metadata := 'NO';
      v_notification.type := 'APP';
      v_notification.priority := 'LOW';

      p_o_notifications.extend;
      p_o_notifications (p_o_notifications.last) := v_notification;
    end loop;
  end p_prepare_vei_notification;

  --send defined system notifications about technical inspection and vehicle insurance
  procedure p_send_system_notifications
  is
    v_notifications  tt_notification := tt_notification ();
  begin
    p_prepare_tin_notification (p_o_notifications => v_notifications);
    p_prepare_vei_notification (p_o_notifications => v_notifications);

    if    v_notifications is null
       or not v_notifications.exists (1)
    then
      return;
    end if;

    for i_ven in v_notifications.first .. v_notifications.last
    loop
      p_set_veh_notification (
        p_notification  => v_notifications (i_ven)
       ,p_i_role        => wksp_evp.evp_user_pkg.role_name_vehicle_admin);
    end loop;
  end p_send_system_notifications;
end evp_notification_pkg;
/
