/* Formatted on 26/5/2024/ 11:10:20 (QP5 v5.391) */
create or replace package body wksp_evp.evp_vehicle_request_pkg
as
  gc_traveler_col  constant varchar2 (50 char) := 'TRAVELER_COL';
  gc_deactivate_note constant wksp_evp.evp_vehicle_req_sta_history.note%type := 'Zahtjev deaktiviran automatski zbog nekativnosti';

  function f_calc_ver_code (
    p_i_rsrv_id  in wksp_evp.evp_vehicle_request.id%type)
    return varchar2
  is
    v_ret      varchar2 (9 char);
    v_req_num  number;
  begin
    v_req_num := mod (p_i_rsrv_id, 1000);

    v_ret := to_char (sysdate, 'YYMMDD') || lpad (v_req_num, 3, '0');

    return v_ret;
  end f_calc_ver_code;

  --Return collection constatn name
  function f_gc_traveler_col
    return varchar2
  is
  begin
    return gc_traveler_col;
  end f_gc_traveler_col;

  --Upsert traveler table
  procedure p_save_traveler_db (
    p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type)
  is
    v_tra_id  wksp_evp.evp_travelers.id%type;
  begin
    for i_tra
      in (select apc.seq_id
                ,apc.n001                                        emp_id
                ,apc.n002                                        c_tra_id
                ,case when apc.n003 = 0 then null else '1' end   diver_ind
                ,tra.id                                          t_tra_id
            from apex_collections apc
                 full join wksp_evp.evp_travelers tra
                      on tra.id = apc.n002
           where (   collection_name =
                     wksp_evp.evp_vehicle_request_pkg.f_gc_traveler_col
                  or collection_name is null)
                 and (   tra.request_id = p_i_vre_id
                      or tra.request_id is null))
    loop
      v_tra_id := null;

      apex_debug.info ('i_tra.c_tra_id: %s', i_tra.c_tra_id);
      apex_debug.info ('i_tra.t_tra_id: %s', i_tra.t_tra_id);
      apex_debug.info ('i_tra.emp_id: %s', i_tra.emp_id);

      if i_tra.t_tra_id is null
      then
        insert into wksp_evp.evp_travelers (request_id, emp_id, driver_ind)
             values (p_i_vre_id, i_tra.emp_id, i_tra.diver_ind)
          returning id
               into v_tra_id;

        apex_collection.update_member_attribute (
          p_collection_name  => gc_traveler_col
         ,p_seq              => i_tra.seq_id
         ,p_attr_number      => 2
         ,p_number_value     => v_tra_id);
      elsif i_tra.t_tra_id is not null and i_tra.c_tra_id is null
      then
        delete wksp_evp.evp_travelers
         where id = i_tra.t_tra_id;
      elsif i_tra.t_tra_id is not null and i_tra.c_tra_id is not null
      then
        update wksp_evp.evp_travelers
           set driver_ind = i_tra.diver_ind
         where id = i_tra.c_tra_id;
      end if;
    end loop;
  exception
    when others
    then
      raise;
  end p_save_traveler_db;

  --Adds traveler (employee) to collection
  procedure p_add_traveler_col (p_i_emp_id in wksp_evp.evp_employee.id%type)
  is
    ex_emp  exception;
  begin
    if nvl (p_i_emp_id, 0) > 0
    then
      apex_collection.add_member (
        p_collection_name  => gc_traveler_col
       ,p_n001             => p_i_emp_id
       ,p_n002             => null                                    --TRA.id
       ,p_n003             => 0      --driver idnicator, 1 - driver, else null
                               );
    else
      raise ex_emp;
    end if;
  exception
    when ex_emp
    then
      raise_application_error (
        -20000
       ,'Parametar p_i_emp_id nema vrijednost!');
    when others
    then
      raise;
  end p_add_traveler_col;

  --Set traveler as driver
  procedure p_set_driver_col (
    p_i_col_seq     number
   ,p_i_emp_id   in wksp_evp.evp_employee.id%type default null)
  is
    v_col_seq    number;
    v_p_col_seq  number;
  begin
    if p_i_col_seq is null
    then
      select max (seq_id)
        into v_p_col_seq
        from apex_collections
       where collection_name = gc_traveler_col and n001 = p_i_emp_id;
    end if;

    select max (seq_id)
      into v_col_seq
      from apex_collections
     where collection_name = gc_traveler_col and n003 > 0;

    if v_col_seq is not null
    then
      apex_collection.update_member_attribute (
        p_collection_name  => gc_traveler_col
       ,p_seq              => v_col_seq
       ,p_attr_number      => 3
       ,p_number_value     => 0);
    end if;

    apex_collection.update_member_attribute (
      p_collection_name  => gc_traveler_col
     ,p_seq              => nvl (p_i_col_seq, v_p_col_seq)
     ,p_attr_number      => 3
     ,p_number_value     => 1);
  exception
    when others
    then
      raise;
  end p_set_driver_col;

  --Delete traveler (employee) from collection
  procedure p_del_traveler_col (
    p_i_col_seq     number
   ,p_i_emp_id   in wksp_evp.evp_employee.id%type default null)
  is
  begin
    apex_collection.delete_member (
      p_collection_name  => gc_traveler_col
     ,p_seq              => p_i_col_seq);
  exception
    when others
    then
      raise;
  end p_del_traveler_col;

  --Fill collection from DB
  procedure p_fill_tra_col (
    p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type)
  is
    v_query  varchar2 (4000);
  begin
    v_query :=

      'select emp_id, id, nvl(driver_ind, 0) from wksp_evp.evp_travelers where request_id = '
      || to_char (nvl (p_i_vre_id, 0));

    apex_collection.create_collection_from_queryb2 (
      p_collection_name     => gc_traveler_col
     ,p_query               => v_query
     ,p_truncate_if_exists  => 'YES');
  exception
    when others
    then
      raise;
  end p_fill_tra_col;

  --Get starting request status
  function f_starting_status
    return wksp_evp.evp_vehicle_request_status.id%type
  is
    v_ret  wksp_evp.evp_vehicle_request_status.id%type;
  begin
    select id
      into v_ret
      from wksp_evp.evp_vehicle_request_status
     where ind_start = 1;

    return v_ret;
  end f_starting_status;

  --Get end request status
  function f_ending_status
    return wksp_evp.evp_vehicle_request_status.id%type
  is
    v_ret  wksp_evp.evp_vehicle_request_status.id%type;
  begin
    select id
      into v_ret
      from wksp_evp.evp_vehicle_request_status
     where ind_end = 1;

    return v_ret;
  end f_ending_status;

  --Insert request status
  procedure p_insert_req_status (
    p_i_vre_id  in     wksp_evp.evp_vehicle_req_sta_history.request_id%type
   ,p_i_vrs_id  in     wksp_evp.evp_vehicle_req_sta_history.status_id%type
   ,p_i_note    in     wksp_evp.evp_vehicle_req_sta_history.note%type default null
   ,p_o_id         out wksp_evp.evp_vehicle_req_sta_history.id%type)
  is
  begin
    insert into wksp_evp.evp_vehicle_req_sta_history (
                  request_id
                 ,status_id
                 ,note)
         values (p_i_vre_id, p_i_vrs_id, p_i_note)
      returning id
           into p_o_id;

    if f_status_id_ref_code (p_i_vrs_id) = 'REZERVIRAN'
    then
      update wksp_evp.evp_vehicle_request
         set reservation_code =
               wksp_evp.evp_vehicle_request_pkg.f_calc_ver_code (
                 p_i_rsrv_id  => p_i_vre_id)
       where id = p_i_vre_id;
    end if;
  exception
    when others
    then
      raise;
  end p_insert_req_status;

  --Last request status
  function f_last_status (p_i_vre_id in wksp_evp.evp_vehicle_request.id%type)
    return wksp_evp.evp_vehicle_request_status.id%type
  is
    v_ret  wksp_evp.evp_vehicle_request_status.id%type;
  begin
    select status_id
      into v_ret
      from wksp_evp.evp_vehicle_req_sta_history
     where id = (select max (id)
                   from wksp_evp.evp_vehicle_req_sta_history
                  where request_id = p_i_vre_id);

    return v_ret;
  exception
    when others
    then
      return null;
  end f_last_status;

  --Status id from ref_code
  function f_ref_code_status_id (
    p_i_vrs_ref  in wksp_evp.evp_vehicle_request_status.ref_code%type)
    return wksp_evp.evp_vehicle_request_status.id%type
  is
    v_ret  wksp_evp.evp_vehicle_request_status.id%type;
  begin
    select id
      into v_ret
      from wksp_evp.evp_vehicle_request_status
     where ref_code = p_i_vrs_ref;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_ref_code_status_id;

  --Next request status
  --param p_i_action, action that changes status, status ref_code
  function f_next_req_status_id (
    p_i_action  in wksp_evp.evp_vehicle_request_status.ref_code%type
   ,p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type)
    return wksp_evp.evp_vehicle_request_status.id%type
  is
    v_last_status_id   wksp_evp.evp_vehicle_request_status.id%type;
    v_next_status_id   wksp_evp.evp_vehicle_request_status.id%type;
    v_status_trans_id  wksp_evp.evp_ver_status_translation.id%type;
    v_ret              wksp_evp.evp_vehicle_request_status.id%type;
  begin
    v_last_status_id := f_last_status (p_i_vre_id);

    if v_last_status_id is not null
    then
      v_next_status_id := f_ref_code_status_id (p_i_action);

      select id
        into v_status_trans_id
        from wksp_evp.evp_ver_status_translation
       where status_id_from = v_last_status_id
             and status_id_to = v_next_status_id;

      v_ret := v_next_status_id;
    else
      v_ret := f_starting_status;
    end if;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_next_req_status_id;

  --Status ref_code from id
  function f_status_id_ref_code (
    p_i_vrs_id  in wksp_evp.evp_vehicle_request_status.id%type)
    return wksp_evp.evp_vehicle_request_status.ref_code%type
  is
    v_ret  wksp_evp.evp_vehicle_request_status.ref_code%type;
  begin
    select ref_code
      into v_ret
      from wksp_evp.evp_vehicle_request_status
     where id = p_i_vrs_id;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_status_id_ref_code;

  --User already has active opened request
  --return 1 have, 0 do not have
  function f_user_active_request (p_i_app_user in varchar2)
    return number
  is
    v_cnt  number := 0;
    v_ret  number := 0;
  begin
    with
      last_status
      as
        (select rsh.request_id
               ,rsh.status_id
               ,rsh.user_crated    rsh_user_crated
               ,rsh.date_crated    rsh_date_crated
               ,rsh.user_updated   rsh_user_updated
               ,rsh.date_updated   rsh_date_updated
               ,vrs.ref_code
           from (select request_id
                       ,status_id
                       ,user_crated
                       ,date_crated
                       ,user_updated
                       ,date_updated
                       ,row_number ()
                          over (
                            partition by request_id
                            order by date_crated desc)  as rn
                   from wksp_evp.evp_vehicle_req_sta_history) rsh
                join wksp_evp.evp_vehicle_request_status vrs
                     on vrs.id = rsh.status_id
          where rsh.rn = 1)
    select count (*)
      into v_cnt
      from wksp_evp.evp_vehicle_request vre
           join last_status lst
                on lst.request_id = vre.id
     where vre.user_crated = p_i_app_user
           and travel_start_date > trunc (sysdate)
           and lst.ref_code in ('OTVOREN', 'REZERVIRAN', 'U_DORADI');

    if v_cnt > 0
    then
      v_ret := 1;
    end if;

    return v_ret;
  end f_user_active_request;
  
  --At least one driver is selected
  --return 1 have, 0 do not have
  function f_driver_selected
    return number
  is
    v_cnt  number := 0;
    v_ret  number := 0;
  begin
    select count (*)
    into v_cnt
      from apex_collections apc
     where collection_name = wksp_evp.evp_vehicle_request_pkg.f_gc_traveler_col
           and n003 = 1;

    if v_cnt > 0
    then
      v_ret := 1;
    end if;

    return v_ret;
  end f_driver_selected;
  
  --return 1 yes, 0 no
  function f_vehicle_available (
    p_i_vehicle_id  in wksp_evp.evp_vehicle.id%type   
   ,p_i_start_date  in wksp_evp.evp_vehicle_request.travel_start_date%type
   ,p_i_end_date    in wksp_evp.evp_vehicle_request.travel_end_date%type
   ,p_i_request_id  in wksp_evp.evp_vehicle_request.id%type default null)
    return number
  is
    v_cnt  number := 0;
    v_ret  number := 0;
  begin
    with
      last_status
      as
        (select rsh.request_id, rsh.status_id, vrs.ref_code
           from (select request_id
                       ,status_id
                       ,row_number ()
                          over (
                            partition by request_id
                            order by date_crated desc)  as rn
                   from wksp_evp.evp_vehicle_req_sta_history) rsh
                join wksp_evp.evp_vehicle_request_status vrs
                     on vrs.id = rsh.status_id
          where rsh.rn = 1)
    select count (*)
      into v_cnt
      from wksp_evp.evp_vehicle_request vre
           join last_status lst
                on lst.request_id = vre.id
     where vre.travel_start_date <= p_i_end_date
           and vre.travel_end_date >= p_i_start_date
           and vre.vehicle_id = p_i_vehicle_id
           and lst.ref_code = 'REZERVIRAN'
           and vre.id != nvl(p_i_request_id, 0);

    if v_cnt = 0
    then
      v_ret := 1;
    end if;

    return v_ret;
  end f_vehicle_available;
  
  --Deactive passive requests
  procedure p_deactive_requests
  is
    cursor cur_passive_req is
      with
        last_status
        as
          (select rsh.request_id, rsh.status_id, vrs.ref_code
             from (select request_id
                         ,status_id
                         ,row_number ()
                            over (
                              partition by request_id
                              order by date_crated desc)  as rn
                     from wksp_evp.evp_vehicle_req_sta_history) rsh
                  join wksp_evp.evp_vehicle_request_status vrs
                       on vrs.id = rsh.status_id
            where rsh.rn = 1)
      select vre.id   vre_id
        from wksp_evp.evp_vehicle_request vre
             join last_status lst
                  on lst.request_id = vre.id
       where lst.ref_code in ('OTVOREN', 'U_DORADI')
             and vre.travel_start_date <= sysdate - 1;

    v_inactive_stat_id  wksp_evp.evp_vehicle_request_status.id%type
                          := f_ref_code_status_id ('NEAKTIVAN');
    v_rsh_id            wksp_evp.evp_vehicle_req_sta_history.id%type;
  begin
    for i_pas_vre in cur_passive_req
    loop
      wksp_evp.evp_vehicle_request_pkg.p_insert_req_status (
        p_i_vre_id  => i_pas_vre.vre_id
       ,p_i_vrs_id  => v_inactive_stat_id
       ,p_i_note    => gc_deactivate_note
       ,p_o_id      => v_rsh_id);
    end loop;
  exception
    when others
    then
      raise;
  end p_deactive_requests;
end evp_vehicle_request_pkg;
/
