/* Formatted on 18/6/2024/ 20:14:12 (QP5 v5.391) */
create or replace package body wksp_evp.evp_user_pkg
as
  gc_role_vehicle_admin  constant varchar2 (50 char)
                                    := 'ADMINISTRATOR_VOZILA' ;
  gc_role_admin          constant varchar2 (50 char) := 'ADMINISTRATOR';
  gc_role_user           constant varchar2 (50 char) := 'KORISNIK_VOZILA';

  --priority IN ( 'HIGH', 'LOW', 'NO', 'URGENT' )
  --type IN ( 'APP', 'E-MAIL' )

  /*
  select * from APEX_APPL_ACL_USERS
  /
  select * from APEX_APPL_ACL_ROLES
  /
  select * from APEX_APPL_ACL_USER_ROLES
  /
  select APEX_UTIL.GET_USER_ROLES(p_username=>'HRVOJE') from dual
  */

  function role_name_vehicle_admin
    return varchar2
  is
  begin
    return gc_role_vehicle_admin;
  end role_name_vehicle_admin;

  function role_name_admin
    return varchar2
  is
  begin
    return gc_role_admin;
  end role_name_admin;

  function role_name_vehicle_user
    return varchar2
  is
  begin
    return gc_role_user;
  end role_name_vehicle_user;

  --apex_authorization.is_authorized wrapper for use in SQL
  function is_authorized_user (p_i_authorization_name in varchar2)
    return number
  is
  begin
    return case apex_authorization.is_authorized (
                  p_authorization_name  => p_i_authorization_name)
             when true
             then
               1
             else
               0
           end;
  end is_authorized_user;
end evp_user_pkg;
/
