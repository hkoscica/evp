/* Formatted on 18/6/2024/ 18:10:29 (QP5 v5.391) */
create or replace package wksp_evp.evp_notification_pkg
as

  --Set notification user activity type
  procedure p_set_nua_act_type (
    p_i_ven_id   in wksp_evp.evp_vehicle_notification.id%type
   ,p_i_act_typ  in wksp_evp.evp_notification_user_act.activity_type%type default 'OPENED');

   --Set all unread notification user activity type
  procedure p_set_nua_act_type (
    p_i_app_user  in varchar2
   ,p_i_act_typ   in wksp_evp.evp_notification_user_act.activity_type%type default 'DISMISSED');

  --insert notification
  procedure p_insert_notification (
    p_i_receiver  in wksp_evp.evp_vehicle_notification.receiver%type
   ,p_i_title     in wksp_evp.evp_vehicle_notification.title%type
   ,p_i_content   in wksp_evp.evp_vehicle_notification.content%type
   ,p_i_sender    in wksp_evp.evp_vehicle_notification.sender%type
   ,p_i_meta      in wksp_evp.evp_vehicle_notification.metadata%type default 'NO'
   ,p_i_type      in wksp_evp.evp_vehicle_notification.type%type default 'APP'
   ,p_i_priority  in wksp_evp.evp_vehicle_notification.priority%type default 'LOW');

  --Set notifications for users or group or all if p_i_app_user and p_i_role = '-'
  procedure p_set_veh_notification (
    p_notification  wksp_evp.evp_vehicle_notification%rowtype
   ,p_i_app_user    varchar2 default null
   ,p_i_role        varchar2 default null);

   --send defined system notifications about technical inspection and vehicle insurance
  procedure p_send_system_notifications;
   end evp_notification_pkg;
/
