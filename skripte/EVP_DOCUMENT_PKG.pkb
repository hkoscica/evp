CREATE OR REPLACE package body WKSP_EVP.evp_document_pkg
as
  --"FILE_TYPE"='DOCUMENT' OR "FILE_TYPE"='OTHER' OR "FILE_TYPE"='PICTURE'
  gc_file_item  constant varchar2 (100 char) := 'P6_FILE';

  function f_count_pictures (
    pi_vehicle_id  in wksp_evp.evp_vehicle_photo.vehicle_id%type)
    return number
  is
    v_return  number;
  begin
    select count (*)
      into v_return
      from wksp_evp.evp_vehicle_photo
     where vehicle_id = pi_vehicle_id and file_type = 'PICTURE';

    return v_return;
  exception
    when others
    then
      return null;
  end f_count_pictures;

  procedure p_save_evp_doc (
    pi_mime_type    in wksp_evp.evp_vehicle_photo.mime_type%type
   ,pi_blob         in wksp_evp.evp_vehicle_photo.file_blob%type
   ,pi_file_name    in wksp_evp.evp_vehicle_photo.file_name%type
   ,pi_extension    in wksp_evp.evp_vehicle_photo.extension%type
   ,pi_description  in wksp_evp.evp_vehicle_photo.description%type
   ,pi_file_type    in wksp_evp.evp_vehicle_photo.file_type%type
   ,pi_vehicle_id   in wksp_evp.evp_vehicle_photo.vehicle_id%type
   ,pi_main_photo   in wksp_evp.evp_vehicle_photo.main_photo%type default '0')
  is
    v_file_number  wksp_evp.evp_vehicle_photo.file_number%type;
  begin
    select nvl (max (file_number), 0) + 1
      into v_file_number
      from wksp_evp.evp_vehicle_photo
     where vehicle_id = pi_vehicle_id;

    insert into wksp_evp.evp_vehicle_photo (
                  file_number
                 ,mime_type
                 ,file_blob
                 ,main_photo
                 ,file_name
                 ,extension
                 ,description
                 ,file_type
                 ,vehicle_id)
         values (
                  v_file_number
                 ,pi_mime_type
                 ,pi_blob
                 ,pi_main_photo
                 ,pi_file_name
                 ,pi_extension
                 ,pi_description
                 ,pi_file_type
                 ,pi_vehicle_id);
  exception
    when others
    then
      raise;
  end p_save_evp_doc;

  function f_resolve_file_type (
    pi_mime_type  in apex_application_temp_files.mime_type%type)
    return varchar2
  is
    v_return  wksp_evp.evp_vehicle_photo.file_type%type;
  begin
    --     application/vnd.ms-excel,pplication/vnd.openxmlformats-officedocument.spreadsheetml.sheet,image/*,.pdf
    case
      when instr (pi_mime_type, 'image/') = 1
      then
        v_return := 'PICTURE';
      when    instr (pi_mime_type, 'ms-excel') = 1
           or pi_mime_type = 'application/pdf'
      then
        v_return := 'DOCUMENT';
      else
        v_return := 'OTHER';
    end case;

    return v_return;
  exception
    when others
    then
      return null;
  end f_resolve_file_type;

  procedure p_process_evp_doc (
    pi_vehicle_id  in wksp_evp.evp_vehicle_photo.vehicle_id%type)
  is
    v_file_names      apex_t_varchar2;
    v_file            apex_application_temp_files%rowtype;
    v_file_type       wksp_evp.evp_vehicle_photo.file_type%type := 'OTHER';
    v_file_extension  wksp_evp.evp_vehicle_photo.extension%type;
    v_main_photo      wksp_evp.evp_vehicle_photo.main_photo%type := '0';
  begin
    v_file_names :=
      apex_string.split (
        p_str  => apex_util.get_session_state (gc_file_item)
       ,p_sep  => ':');

    for i in 1 .. v_file_names.count
    loop
      select *
        into v_file
        from apex_application_temp_files
       where name = v_file_names (i);

      select apex_string_util.get_file_extension (v_file.filename)
        into v_file_extension
        from dual;

      v_file_type := f_resolve_file_type (v_file.mime_type);

      if v_file_type = 'PICTURE' and f_count_pictures (pi_vehicle_id) = 0
      then
        v_main_photo := '1';
      end if;

      p_save_evp_doc (
        pi_mime_type    => v_file.mime_type
       ,pi_blob         => v_file.blob_content
       ,pi_file_name    => v_file.filename
       ,pi_extension    => v_file_extension
       ,pi_description  => v_file.name
       ,pi_file_type    => v_file_type
       ,pi_vehicle_id   => pi_vehicle_id
       ,pi_main_photo   => v_main_photo);
    end loop;
  exception
    when others
    then
      raise;
  end p_process_evp_doc;

  procedure p_delete_evp_doc (
    pi_file_id  in wksp_evp.evp_vehicle_photo.id%type)
  is
    v_vehicle_id  wksp_evp.evp_vehicle_photo.vehicle_id%type;
  begin
    select vehicle_id
      into v_vehicle_id
      from wksp_evp.evp_vehicle_photo
     where id = pi_file_id;

    delete wksp_evp.evp_vehicle_photo
     where id = pi_file_id;
  exception
    when others
    then
      raise;
  end p_delete_evp_doc;

  procedure p_set_main_photo (
    pi_file_id  in wksp_evp.evp_vehicle_photo.id%type)
  is
    v_vehicle_id  wksp_evp.evp_vehicle_photo.vehicle_id%type;
  begin
    select vehicle_id
      into v_vehicle_id
      from wksp_evp.evp_vehicle_photo
     where id = pi_file_id;

    update wksp_evp.evp_vehicle_photo
       set main_photo = '0'
     where vehicle_id = v_vehicle_id;

    update wksp_evp.evp_vehicle_photo
       set main_photo = '1'
     where id = pi_file_id;
  exception
    when others
    then
      raise;
  end p_set_main_photo;
end evp_document_pkg;
/
