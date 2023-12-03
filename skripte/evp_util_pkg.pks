CREATE OR REPLACE package WKSP_EVP.evp_util_pkg
as
  function f_get_owner_name (p_i_owner_id in wksp_evp.evp_owner.id%type)
    return varchar2;

  function f_get_vehicle_model (
    p_i_model_id  in wksp_evp.evp_vehicle_model.id%type)
    return varchar2;

  --Return: vehicle last consumtion
  function f_get_vehicle_last_consumption (
    p_i_vehicle_id   in wksp_evp.evp_vehicle.id%type
   ,p_i_date_period  in wksp_evp.evp_v_vehicle_consumption.date_period_code%type)
    return number;
end evp_util_pkg;
/
