CREATE OR REPLACE package body WKSP_EVP.evp_util_pkg
as
  --Return: owner name private or institution
  function f_get_owner_name (p_i_owner_id in wksp_evp.evp_owner.id%type)
    return varchar2
  is
    v_ret  wksp_evp.evp_owner.institution_name%type;
  begin
    select case
             when owner_type = 'I' then nvl (institution_name, name)
             else name || nvl2 (lastname, ' ' || lastname, '')
           end
      into v_ret
      from wksp_evp.evp_owner
     where id = p_i_owner_id;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_get_owner_name;

  --Return: vehicle model and manufacturer name
  function f_get_vehicle_model (
    p_i_model_id  in wksp_evp.evp_vehicle_model.id%type)
    return varchar2
  is
    v_ret  wksp_evp.evp_vehicle_model.description%type;
  begin
    select vem.ref_code || ' ' || vmo.description
      into v_ret
      from wksp_evp.evp_vehicle_model vmo
           join wksp_evp.evp_vehicle_manufacturer vem
                on vem.id = vmo.manufacturer_id
     where vmo.id = p_i_model_id;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_get_vehicle_model;

  --Return: vehicle last consumtion
  function f_get_vehicle_last_consumption (
    p_i_vehicle_id   in wksp_evp.evp_vehicle.id%type
   ,p_i_date_period  in wksp_evp.evp_v_vehicle_consumption.date_period_code%type)
    return number
  is
    v_ret  number;
  begin
      select consumption
        into v_ret
        from wksp_evp.evp_v_vehicle_consumption
       where vehicle_id = p_i_vehicle_id
             and date_period_code = p_i_date_period
             and rownum < 2
             and consumption is not null
    order by flc_year desc, flc_quarter desc, flc_month desc;

    return v_ret;
  exception
    when others
    then
      return null;
  end f_get_vehicle_last_consumption;
end evp_util_pkg;
/
