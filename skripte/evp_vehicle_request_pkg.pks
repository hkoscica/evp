/* Formatted on 25/5/2024/ 17:27:44 (QP5 v5.391) */
create or replace package wksp_evp.evp_vehicle_request_pkg
as
  --Calculate vehicle request reservation code
  function f_calc_ver_code (
    p_i_rsrv_id  in wksp_evp.evp_vehicle_request.id%type)
    return varchar2;

  --Return collection constatn name
  function f_gc_traveler_col
    return varchar2;

  --Upsert traveler table
  procedure p_save_traveler_db (
    p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type);

  --Adds traveler (employee) to collection
  procedure p_add_traveler_col (p_i_emp_id in wksp_evp.evp_employee.id%type);

  --Set traveler as driver
  procedure p_set_driver_col (
    p_i_col_seq     number
   ,p_i_emp_id   in wksp_evp.evp_employee.id%type default null);

  --Delete traveler (employee) from collection
  procedure p_del_traveler_col (
    p_i_col_seq     number
   ,p_i_emp_id   in wksp_evp.evp_employee.id%type default null);

  --Fill collection from DB
  procedure p_fill_tra_col (
    p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type);

  --Get starting request status
  function f_starting_status
    return wksp_evp.evp_vehicle_request_status.id%type;

  --Get end request status
  function f_ending_status
    return wksp_evp.evp_vehicle_request_status.id%type;

  --Insert request status
  procedure p_insert_req_status (
    p_i_vre_id  in     wksp_evp.evp_vehicle_req_sta_history.request_id%type
   ,p_i_vrs_id  in     wksp_evp.evp_vehicle_req_sta_history.status_id%type
   ,p_i_note    in     wksp_evp.evp_vehicle_req_sta_history.note%type default null
   ,p_o_id         out wksp_evp.evp_vehicle_req_sta_history.id%type);

  --Last request status
  function f_last_status (p_i_vre_id in wksp_evp.evp_vehicle_request.id%type)
    return wksp_evp.evp_vehicle_request_status.id%type;

  --Status id from ref_code
  function f_ref_code_status_id (
    p_i_vrs_ref  in wksp_evp.evp_vehicle_request_status.ref_code%type)
    return wksp_evp.evp_vehicle_request_status.id%type;

  --Status ref_code from id
  function f_status_id_ref_code (
    p_i_vrs_id  in wksp_evp.evp_vehicle_request_status.id%type)
    return wksp_evp.evp_vehicle_request_status.ref_code%type;

  --Next request status
  --param p_i_action, action that changes status, status ref_code
  function f_next_req_status_id (
    p_i_action  in wksp_evp.evp_vehicle_request_status.ref_code%type
   ,p_i_vre_id  in wksp_evp.evp_vehicle_request.id%type)
    return wksp_evp.evp_vehicle_request_status.id%type;    
    
   --User already has active opened request
  --return 1 have, 0 do not have
  function f_user_active_request (p_i_app_user in varchar2)
    return number;
    
  --At least one driver is selected
  --return 1 have, 0 do not have
  function f_driver_selected
    return number;
    
  --return 1 yes, 0 no
  function f_vehicle_available (
    p_i_vehicle_id  in wksp_evp.evp_vehicle.id%type    
   ,p_i_start_date  in wksp_evp.evp_vehicle_request.travel_start_date%type
   ,p_i_end_date    in wksp_evp.evp_vehicle_request.travel_end_date%type
   ,p_i_request_id  in wksp_evp.evp_vehicle_request.id%type default null)
    return number;
    
  --Deactive passive requests
  procedure p_deactive_requests;
end evp_vehicle_request_pkg;
/
