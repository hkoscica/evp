CREATE OR REPLACE package WKSP_EVP.evp_document_pkg
as
  procedure p_process_evp_doc (
    pi_vehicle_id  in wksp_evp.evp_vehicle_photo.vehicle_id%type);

  procedure p_delete_evp_doc (
    pi_file_id  in wksp_evp.evp_vehicle_photo.id%type);

  procedure p_set_main_photo (
    pi_file_id  in wksp_evp.evp_vehicle_photo.id%type);
end evp_document_pkg;
/
