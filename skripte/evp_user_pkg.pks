/* Formatted on 17/6/2024/ 21:52:34 (QP5 v5.391) */
create or replace package wksp_evp.evp_user_pkg
as
  function role_name_vehicle_admin
    return varchar2;

  function role_name_admin
    return varchar2;

  function role_name_vehicle_user
    return varchar2;
    
  --apex_authorization.is_authorized wrapper for use in SQL
  function is_authorized_user (p_i_authorization_name in varchar2)
    return number;
end evp_user_pkg;
/
