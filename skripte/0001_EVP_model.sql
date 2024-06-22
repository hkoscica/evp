/* Formatted on 28/10/2023/ 10:12:14 (QP5 v5.391) */
--EVP


--DDL
--unique seq
create sequence wksp_evp.evp_seq start with 1 nocache order;

--DDL
--evp_vehicle_body_shape

create table wksp_evp.evp_vehicle_body_shape
(
  id             number not null
 ,ref_code       varchar2 (50 char) not null
 ,description    varchar2 (4000 char) not null
 ,user_crated    varchar2 (50 char) not null
 ,date_crated    date not null
 ,user_updated   varchar2 (50 char)
 ,date_updated   date
);

comment on table wksp_evp.evp_vehicle_body_shape is 'Vehicle body shape';

comment on column wksp_evp.evp_vehicle_body_shape.id is 'body shape ID';

comment on column wksp_evp.evp_vehicle_body_shape.ref_code is
  'body shape ref code';

comment on column wksp_evp.evp_vehicle_body_shape.description is
  'body shape description';

comment on column wksp_evp.evp_vehicle_body_shape.user_crated is
  'App user created';

comment on column wksp_evp.evp_vehicle_body_shape.date_crated is
  'Created date';

comment on column wksp_evp.evp_vehicle_body_shape.user_updated is
  'App user updated';

comment on column wksp_evp.evp_vehicle_body_shape.date_updated is
  'Updated date';

create index wksp_evp.evp_vbs_id_idx
  on wksp_evp.evp_vehicle_body_shape (id asc);

alter table wksp_evp.evp_vehicle_body_shape
  add constraint evp_vbs_pk primary key (id);

alter table wksp_evp.evp_vehicle_body_shape
  add constraint evp_vbs_ref_un unique (ref_code);

create or replace trigger wksp_evp.evp_trg_vbs_biu
  before insert or update
  on wksp_evp.evp_vehicle_body_shape
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert body shapes
declare
  procedure p_ins_vehicle_body_shape (
    p_i_ref_code  in wksp_evp.evp_vehicle_body_shape.ref_code%type
   ,p_i_desc      in wksp_evp.evp_vehicle_body_shape.description%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_vehicle_body_shape
     where ref_code = p_i_ref_code;

    if v_id is null
    then
      insert into wksp_evp.evp_vehicle_body_shape (ref_code, description)
           values (p_i_ref_code, p_i_desc);
    else
      update wksp_evp.evp_vehicle_body_shape
         set ref_code = p_i_ref_code, description = p_i_desc
       where id = v_id;
    end if;
  end;
begin
   
    p_ins_vehicle_body_shape (p_i_ref_code =>'LIMUZINA',               p_i_desc =>'Klasican oblik s cetvrtastim stražnjim dijelom.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'KARAVAN',                p_i_desc =>'Produžena limuzina s prostranim prtljažnikom.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'HATCHBACK',              p_i_desc =>'Kompaktan automobil s stražnjim vratima koja se otvaraju prema gore.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'COUPE',                  p_i_desc =>'Sportski automobil s obicno samo dvama vratima i strmim padom krova.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'KABRIOLET_CONVERTIBLE',  p_i_desc =>'Automobil s preklopivim ili potpuno uklonjivim krovom.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'SUV',                    p_i_desc =>'Visoki terenac s prostranim unutarnjim prostorom.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'CROSSOVER',              p_i_desc =>'Mješavina SUV-a i limuzine, kombinira karakteristike oba.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'PICKUP',                 p_i_desc =>'Vozilo s otvorenim prtljažnikom na stražnjem dijelu.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'MINIVAN_MONOVOLUMEN',    p_i_desc =>'Prostrano vozilo s visokim krovom i obicno sedam sjedala.');
    p_ins_vehicle_body_shape (p_i_ref_code =>'KOMBI_VAN',              p_i_desc =>'Vozilo prilagodeno za prijevoz tereta ili ljudi s povecanim prostorom.');
    
   commit;
exception
  when others
  then
    rollback;
    raise;
end;

/


--DDL
--evp_vehicle_manufacturer

CREATE TABLE wksp_evp.evp_vehicle_manufacturer (
    id           NUMBER NOT NULL,
    ref_code     VARCHAR2(50) NOT NULL,
    description  VARCHAR2(4000 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_manufacturer IS
    'Vehicle manufacturers';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.id IS
    'Manufacturer ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.ref_code IS
    'Manufacturer ref code';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.description IS
    'Manufacturer description';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_manufacturer.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_vma_id_idx ON
    wksp_evp.evp_vehicle_manufacturer (
        id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_manufacturer ADD CONSTRAINT evp_vma_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_manufacturer ADD CONSTRAINT evp_vma_ref_un UNIQUE ( ref_code );


create or replace trigger wksp_evp.evp_trg_vma_biu
  before insert or update
  on wksp_evp.evp_vehicle_manufacturer
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert manufacturers
declare
  procedure p_ins_vehicle_manufacturer (
    p_i_ref_code  in wksp_evp.evp_vehicle_manufacturer.ref_code%type
   ,p_i_desc      in wksp_evp.evp_vehicle_manufacturer.description%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_vehicle_manufacturer
     where ref_code = p_i_ref_code;

    if v_id is null
    then
      insert into wksp_evp.evp_vehicle_manufacturer (ref_code, description)
           values (p_i_ref_code, p_i_desc);
    else
      update wksp_evp.evp_vehicle_manufacturer
         set ref_code = p_i_ref_code, description = p_i_desc
       where id = v_id;
    end if;
  end;
begin
   
    p_ins_vehicle_manufacturer (p_i_ref_code =>'TOYOTA',p_i_desc =>'Japanski proizvodac automobila poznat po pouzdanosti i inovacijama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'FORD',p_i_desc =>'Americki proizvodac s dugom poviješcu, poznat po raznolikom asortimanu vozila.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'BMW',p_i_desc =>'Njemacki proizvodac luksuznih automobila s snažnim fokusom na performansama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'HONDA',p_i_desc =>'Japanski proizvodac poznat po ekonomicnim i pouzdanim vozilima.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'CHEVROLET',p_i_desc =>'Americki brend koji nudi raznolike automobile, poznat po inovacijama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'MERCEDES-BENZ',p_i_desc =>'Njemacki proizvodac luksuznih vozila s dugom tradicijom.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'VOLKSWAGEN',p_i_desc =>'Njemacki brend koji nudi širok spektar vozila, od kompaktnih do luksuznih.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'NISSAN',p_i_desc =>'Japanski proizvodac s globalnim prisustvom, poznat po SUV-ima i elektricnim vozilima.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'AUDI',p_i_desc =>'Njemacki proizvodac luksuznih automobila s naglaskom na tehnologiji.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'HYUNDAI',p_i_desc =>'Južnokorejski proizvodac automobila s brzim rastom i raznolikim modelima.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'KIA',p_i_desc =>'Južnokorejski brend poznat po modernom dizajnu i pristupacnim cijenama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'FIAT',p_i_desc =>'Talijanski proizvodac s dugom poviješcu, poznat po malim i ekonomicnim vozilima.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'MAZDA',p_i_desc =>'Japanski proizvodac automobila s naglaskom na dinamicnom dizajnu i vozackom iskustvu.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'SUBARU',p_i_desc =>'Japanski brend poznat po pogonu na sve kotace i sportskim modelima.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'JEEP',p_i_desc =>'Americki proizvodac poznat po terenskim vozilima, dio Stellantis koncerna.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'LEXUS',p_i_desc =>'Luksuzna divizija Toyote s visokim standardima udobnosti i tehnologije.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'VOLVO',p_i_desc =>'Švedski proizvodac automobila poznat po sigurnosti i inovacijama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'PORSCHE',p_i_desc =>'Njemacki proizvodac sportskih automobila, dio Volkswagen Grupe.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'TESLA',p_i_desc =>'Americki proizvodac elektricnih vozila s revolucionarnim pristupom mobilnosti.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'JAGUAR',p_i_desc =>'Britanski proizvodac luksuznih automobila s elegantnim dizajnom i performansama.');
    p_ins_vehicle_manufacturer (p_i_ref_code =>'RENAULT',p_i_desc =>'Francuski proizvodac automobila poznat po raznovrsnoj paleti vozila i inovacijama.');
    
   commit;
exception
  when others
  then
    rollback;
    raise;
end;

/


--DDL
--evp_owner

CREATE TABLE wksp_evp.evp_owner (
    id               NUMBER NOT NULL,
    oib              CHAR(11 CHAR) NOT NULL,
    name             VARCHAR2(100 CHAR) NOT NULL,
    lastname         VARCHAR2(100 CHAR),
    institution_name VARCHAR2(1000 CHAR),
    owner_type       CHAR(1 CHAR) NOT NULL,
    address          VARCHAR2(4000 CHAR),
    user_crated      VARCHAR2(50 CHAR) NOT NULL,
    date_crated      DATE NOT NULL,
    user_updated     VARCHAR2(50 CHAR),
    date_updated     DATE
);

ALTER TABLE wksp_evp.evp_owner
    ADD CHECK ( owner_type IN ( 'I', 'P' ) );

COMMENT ON TABLE wksp_evp.evp_owner IS
    'Owners';

COMMENT ON COLUMN wksp_evp.evp_owner.id IS
    'Owners ID';

COMMENT ON COLUMN wksp_evp.evp_owner.oib IS
    'OIB';

COMMENT ON COLUMN wksp_evp.evp_owner.name IS
    'Firstname';

COMMENT ON COLUMN wksp_evp.evp_owner.lastname IS
    'Lastname';

COMMENT ON COLUMN wksp_evp.evp_owner.institution_name IS
    'Istitution name';

COMMENT ON COLUMN wksp_evp.evp_owner.owner_type IS
    'Domain owner type P - privae or I - instituition';

COMMENT ON COLUMN wksp_evp.evp_owner.address IS
    'Owner address';

COMMENT ON COLUMN wksp_evp.evp_owner.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_owner.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_owner.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_owner.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_owner_id_idx ON
    wksp_evp.evp_owner (
        id
    ASC );

CREATE INDEX wksp_evp.evp_owner_oib_idx ON
    wksp_evp.evp_owner (
        oib
    ASC );

ALTER TABLE wksp_evp.evp_owner
    ADD CONSTRAINT evp_own_typ_ck CHECK ( owner_type IN ( 'P', 'I' ) );

ALTER TABLE wksp_evp.evp_owner ADD CONSTRAINT evp_owners_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_owner ADD CONSTRAINT evp_owner_oib_un UNIQUE ( oib );


create or replace trigger wksp_evp.evp_trg_own_biu
  before insert or update
  on wksp_evp.evp_owner
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert owners
declare
  procedure p_ins_owners (
    p_i_oib               in wksp_evp.evp_owner.oib%type
   ,p_i_name              in wksp_evp.evp_owner.name%type
   ,p_i_lastname          in wksp_evp.evp_owner.lastname%type
   ,p_i_institution_name  in wksp_evp.evp_owner.institution_name%type
   ,p_i_owner_type        in wksp_evp.evp_owner.owner_type%type
   ,p_i_address           in wksp_evp.evp_owner.address%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_owner
     where oib = p_i_oib;

    if v_id is null
    then
      insert into wksp_evp.evp_owner (
                    oib
                   ,name
                   ,lastname
                   ,institution_name
                   ,owner_type
                   ,address)
           values (
                    p_i_oib
                   ,p_i_name
                   ,p_i_lastname
                   ,p_i_institution_name
                   ,p_i_owner_type
                   ,p_i_address);
    else
      update wksp_evp.evp_owner
         set oib = p_i_oib
            ,name = p_i_name
            ,lastname = p_i_lastname
            ,institution_name = p_i_institution_name
            ,owner_type = p_i_owner_type
            ,address = p_i_address
       where id = v_id;
    end if;
  end;
begin

    p_ins_owners(p_i_oib =>'12345678901', p_i_name => 'ISS d.o.o.', p_i_lastname =>'',p_i_institution_name =>'Inovativni Sustavi d.o.o.', p_i_owner_type =>'I', p_i_address =>'Ulica Bezimeni put 1, 10000 Zagreb');
    p_ins_owners(p_i_oib =>'98765442109', p_i_name => 'EV Ltd.', p_i_lastname =>'',p_i_institution_name =>'Energetske Vizije Ltd.', p_i_owner_type =>'I', p_i_address =>'Trg Lažnih nade 23, 21000 Split');
    p_ins_owners(p_i_oib =>'45678901234', p_i_name => 'KR Inc.', p_i_lastname =>'',p_i_institution_name =>'Kreativni Razvoj Inc.', p_i_owner_type =>'I', p_i_address =>'Aleja Izmišljenih junaka 7, 31000 Osijek');
    p_ins_owners(p_i_oib =>'56789112345', p_i_name => 'TK d.o.o.', p_i_lastname =>'',p_i_institution_name =>'Tehnološki Koncepti d.o.o.', p_i_owner_type =>'I', p_i_address =>'Promenada Fantazijskih snova 45, 42000 Varaždin');
    p_ins_owners(p_i_oib =>'89012345678', p_i_name => 'GS Ltd.', p_i_lastname =>'',p_i_institution_name =>'Globalna Strategija Ltd.', p_i_owner_type =>'I', p_i_address =>'Avenija Iluzionistickih cuda 12, 51000 Rijeka');
    p_ins_owners(p_i_oib =>'34567890123', p_i_name => 'HP Inc.', p_i_lastname =>'',p_i_institution_name =>'Harmonija Proizvoda Inc.', p_i_owner_type =>'I', p_i_address =>'Prolaz Magicnih šuma 9, 61000 Šibenik');
    p_ins_owners(p_i_oib =>'23456689012', p_i_name => 'DP d.o.o.', p_i_lastname =>'',p_i_institution_name =>'Dinamicni Progres d.o.o.', p_i_owner_type =>'I', p_i_address =>'Naselje Nerealnih ideja 33, 71000 Dubrovnik');
    p_ins_owners(p_i_oib =>'67890123456', p_i_name => 'QS Ltd.', p_i_lastname =>'',p_i_institution_name =>'Quantum Solutions Ltd.', p_i_owner_type =>'I', p_i_address =>'Kvart Maštovitih planina 18, 81000 Zadar');
    p_ins_owners(p_i_oib =>'78901234567', p_i_name => 'SB Inc.', p_i_lastname =>'',p_i_institution_name =>'Sjajna Buducnost Inc.', p_i_owner_type =>'I', p_i_address =>'Cesta Sjenovitih dolina 27, 91000 Pula');
    p_ins_owners(p_i_oib =>'01234567890', p_i_name => 'ME d.o.o.', p_i_lastname =>'',p_i_institution_name =>'Maksimalna Efikasnost d.o.o.', p_i_owner_type =>'I', p_i_address =>'Ulica Slobodnih misli 14, 10110 Karlovac');
    p_ins_owners(p_i_oib =>'34567891230', p_i_name => 'IB d.d.', p_i_lastname =>'',p_i_institution_name =>'Istarska brda d.d.', p_i_owner_type =>'I', p_i_address =>'Trg Nepostojecih junaka 29, 20120 Porec');
    p_ins_owners(p_i_oib =>'89012345670', p_i_name => 'Ana', p_i_lastname =>'Kovacevic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Aleja Snova i zvijezda 6, 30130 Sisak');
    p_ins_owners(p_i_oib =>'09856543210', p_i_name => 'Marko', p_i_lastname =>'Horvat',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Promenada Nadrealnih prica 51, 40140 Bjelovar');
    p_ins_owners(p_i_oib =>'76543210987', p_i_name => 'Ivana', p_i_lastname =>'Babic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Avenija Beskrajnih mogucnosti 22, 50150 Crikvenica');
    p_ins_owners(p_i_oib =>'43110987654', p_i_name => 'Andrej', p_i_lastname =>'Novak',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Prolaz Carobnih trenutaka 17, 60160 Vukovar');
    p_ins_owners(p_i_oib =>'21098765432', p_i_name => 'Petra', p_i_lastname =>'Juric',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Naselje Izgubljenih iluzija 38, 70180 Makarska');
    p_ins_owners(p_i_oib =>'54321098765', p_i_name => 'Nikola', p_i_lastname =>'Tomic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Kvart Vrtova mašte 10, 80190 Požega');
    p_ins_owners(p_i_oib =>'87650123456', p_i_name => 'Marija', p_i_lastname =>'Radic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Cesta Tajanstvenih voda 25, 90100 Krapina');
    p_ins_owners(p_i_oib =>'12340678901', p_i_name => 'Luka', p_i_lastname =>'Vukovic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Ulica Raznobojnih horizonta 8, 10010 Vinkovci');
    p_ins_owners(p_i_oib =>'87454321098', p_i_name => 'Katarina', p_i_lastname =>'Kneževic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Trg Nerealnih doživljaja 31, 20030 Županja');
    p_ins_owners(p_i_oib =>'98765432109', p_i_name => 'Ivan', p_i_lastname =>'Maras',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Aleja Šarenila i cuda 14, 30070 Kutina');
    p_ins_owners(p_i_oib =>'13345098765', p_i_name => 'Lea', p_i_lastname =>'Petrovic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Promenada Bezvremenih prica 49, 40080 Pakrac');
    p_ins_owners(p_i_oib =>'65432109876', p_i_name => 'David', p_i_lastname =>'Matic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Avenija Nestvarnih ljubavi 16, 50020 Novska');
    p_ins_owners(p_i_oib =>'10987654321', p_i_name => 'Mia', p_i_lastname =>'Peric',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Prolaz Sjajnih ideja 27, 60040 Vrbovec');
    p_ins_owners(p_i_oib =>'43210987654', p_i_name => 'Matija', p_i_lastname =>'Savic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Naselje Zaboravljenih snova 19, 70060 Ðakovo');
    p_ins_owners(p_i_oib =>'87654321098', p_i_name => 'Ema', p_i_lastname =>'Šimic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Kvart Iluzornih planina 32, 80090 Našice');
    p_ins_owners(p_i_oib =>'09876543210', p_i_name => 'Filip', p_i_lastname =>'Nemet',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Cesta Nenapisanih prica 21, 90050 Križevci');
    p_ins_owners(p_i_oib =>'56789012345', p_i_name => 'Sara', p_i_lastname =>'Cvitkovic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Ulica Nestvarnih susreta 36, 10020 Ivanec');
    p_ins_owners(p_i_oib =>'12345098765', p_i_name => 'Antonio', p_i_lastname =>'Mlinaric',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Trg Izmišljenih prijatelja 13, 20060 Ludbreg');
    p_ins_owners(p_i_oib =>'23456789012', p_i_name => 'Helena', p_i_lastname =>'Vidovic',p_i_institution_name =>'', p_i_owner_type =>'P', p_i_address =>'Aleja Zabranjenih svjetova 28, 30010 Prelog');       

  commit;
exception
  when others
  then
    rollback;
    raise;
end;
/

--DDL
--evp_vehicle_category
CREATE TABLE wksp_evp.evp_vehicle_category (
    id           NUMBER NOT NULL,
    ref_code     VARCHAR2(50) NOT NULL,
    description  VARCHAR2(4000 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_category IS
    'Vehicle categories';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.id IS
    'Category ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.ref_code IS
    'Category ref code';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.description IS
    'Category description';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_category.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_vca_id_ref_idx ON
    wksp_evp.evp_vehicle_category (
        id
    ASC,
        ref_code
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_category ADD CONSTRAINT evp_vca_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_category ADD CONSTRAINT evp_vca_ref_un UNIQUE ( ref_code );

create or replace trigger wksp_evp.evp_trg_vca_biu
  before insert or update
  on wksp_evp.evp_vehicle_category
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert vehicle_category
declare
  procedure p_ins_vehicle_category (
    p_i_ref_code  in wksp_evp.evp_vehicle_category.ref_code%type
   ,p_i_desc      in wksp_evp.evp_vehicle_category.description%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_vehicle_category
     where ref_code = p_i_ref_code;

    if v_id is null
    then
      insert into wksp_evp.evp_vehicle_category (ref_code, description)
           values (p_i_ref_code, p_i_desc);
    else
      update wksp_evp.evp_vehicle_category
         set ref_code = p_i_ref_code, description = p_i_desc
       where id = v_id;
    end if;
  end;
begin
   
  p_ins_vehicle_category(p_i_ref_code => 'M1', p_i_desc => 'Osobna vozila');
  p_ins_vehicle_category(p_i_ref_code => 'M2', p_i_desc => 'Autobusi s najviše 8 sjedala osim vozacevog');
  p_ins_vehicle_category(p_i_ref_code => 'M3', p_i_desc => 'Autobusi s više od 8 sjedala osim vozacevog');
  p_ins_vehicle_category(p_i_ref_code => 'N1', p_i_desc => 'Vozila za prijevoz tereta s MGM = 3.5 tona');
  p_ins_vehicle_category(p_i_ref_code => 'N2', p_i_desc => 'Vozila za prijevoz tereta s 3.5 < MGM = 12 tona');
  p_ins_vehicle_category(p_i_ref_code => 'N3', p_i_desc => 'Vozila za prijevoz tereta s MGM > 12 tona');
  p_ins_vehicle_category(p_i_ref_code => 'O1', p_i_desc => 'Prikljucna vozila s MGM = 0.75 tona');
  p_ins_vehicle_category(p_i_ref_code => 'O2', p_i_desc => 'Prikljucna vozila s 0.75 < MGM = 3.5 tona');
  p_ins_vehicle_category(p_i_ref_code => 'O3', p_i_desc => 'Prikljucna vozila s MGM > 3.5 tona');
  p_ins_vehicle_category(p_i_ref_code => 'L1', p_i_desc => 'Dvocikli s VBR < 45 km/h');
  p_ins_vehicle_category(p_i_ref_code => 'L2', p_i_desc => 'Dvocikli s VBR < 45 km/h, s bocnom prikolicom');
  p_ins_vehicle_category(p_i_ref_code => 'L3', p_i_desc => 'Dvocikli s VBR > 45 km/h');
  p_ins_vehicle_category(p_i_ref_code => 'L4', p_i_desc => 'Trocikli s VBR > 45 km/h');
  p_ins_vehicle_category(p_i_ref_code => 'L5', p_i_desc => 'Cetverocikli s MGM < 1 tona');
  p_ins_vehicle_category(p_i_ref_code => 'L6', p_i_desc => 'Cetverocikli s MGM > 1 tona');
  p_ins_vehicle_category(p_i_ref_code => 'L7', p_i_desc => 'Motocikli s bocnom prikolicom');

    
   commit;
exception
  when others
  then
    rollback;
    raise;
end;

/


--DDL
--evp_vehicle_manufacturer
CREATE TABLE wksp_evp.evp_vehicle_model (
    id              NUMBER NOT NULL,
    ref_code        VARCHAR2(50) NOT NULL,
    description     VARCHAR2(4000 CHAR) NOT NULL,
    manufacturer_id NUMBER NOT NULL,
    user_crated     VARCHAR2(50 CHAR) NOT NULL,
    date_crated     DATE NOT NULL,
    user_updated    VARCHAR2(50 CHAR),
    date_updated    DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_model IS
    'Vehicle categories';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.id IS
    'MODEL ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.ref_code IS
    'MODEL ref code';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.description IS
    'MODEL description';
    
COMMENT ON COLUMN wksp_evp.evp_vehicle_model.manufacturer_id IS
    'Manufacturer ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_model.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_vehicle_model_mfg_idx ON
    wksp_evp.evp_vehicle_model (
        manufacturer_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_model ADD CONSTRAINT evp_vehicle_model_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_model ADD CONSTRAINT evp_vehicle_model_ref_code_un UNIQUE ( ref_code );

ALTER TABLE wksp_evp.evp_vehicle_model
    ADD CONSTRAINT evp_vehicle_model_evp_vmo_fk FOREIGN KEY ( manufacturer_id )
        REFERENCES wksp_evp.evp_vehicle_manufacturer ( id );



create or replace trigger wksp_evp.evp_trg_vmo_biu
  before insert or update
  on wksp_evp.evp_vehicle_model
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert models
declare
  procedure p_ins_vehicle_model (
    p_i_ref_code  in wksp_evp.evp_vehicle_model.ref_code%type
   ,p_i_desc      in wksp_evp.evp_vehicle_model.description%type
   ,p_i_mfg_ref   in wksp_evp.evp_vehicle_manufacturer.ref_code%type)
  is
    v_id      number;
    v_mfg_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_vehicle_model
     where ref_code = p_i_ref_code;

    select id
      into v_mfg_id
      from wksp_evp.evp_vehicle_manufacturer
     where ref_code = p_i_mfg_ref;

    if v_id is null
    then
      insert into wksp_evp.evp_vehicle_model (
                    ref_code
                   ,description
                   ,manufacturer_id)
           values (p_i_ref_code, p_i_desc, v_mfg_id);
    else
      update wksp_evp.evp_vehicle_model
         set ref_code = p_i_ref_code
            ,description = p_i_desc
            ,manufacturer_id = v_mfg_id
       where id = v_id;
    end if;
  end;
begin

  p_ins_vehicle_model(p_i_desc => 'Camry', p_i_mfg_ref => 'TOYOTA'       , p_i_ref_code => 'Camry');
  p_ins_vehicle_model(p_i_desc => 'Corolla', p_i_mfg_ref => 'TOYOTA'       , p_i_ref_code => 'Corolla');
  p_ins_vehicle_model(p_i_desc => 'RAV4', p_i_mfg_ref => 'TOYOTA'       , p_i_ref_code => 'RAV4');
  p_ins_vehicle_model(p_i_desc => 'Focus', p_i_mfg_ref => 'FORD'         , p_i_ref_code => 'Focus');
  p_ins_vehicle_model(p_i_desc => 'Fiesta', p_i_mfg_ref => 'FORD'         , p_i_ref_code => 'Fiesta');
  p_ins_vehicle_model(p_i_desc => 'Mustang', p_i_mfg_ref => 'FORD'         , p_i_ref_code => 'Mustang');
  p_ins_vehicle_model(p_i_desc => '3 Series', p_i_mfg_ref => 'BMW'          , p_i_ref_code => '3 Series');
  p_ins_vehicle_model(p_i_desc => 'X5', p_i_mfg_ref => 'BMW'          , p_i_ref_code => 'X5');
  p_ins_vehicle_model(p_i_desc => '7 Series', p_i_mfg_ref => 'BMW'          , p_i_ref_code => '7 Series');
  p_ins_vehicle_model(p_i_desc => 'Accord', p_i_mfg_ref => 'HONDA'        , p_i_ref_code => 'Accord');
  p_ins_vehicle_model(p_i_desc => 'Civic', p_i_mfg_ref => 'HONDA'        , p_i_ref_code => 'Civic');
  p_ins_vehicle_model(p_i_desc => 'CR-V', p_i_mfg_ref => 'HONDA'        , p_i_ref_code => 'CR-V');
  p_ins_vehicle_model(p_i_desc => 'Silverado', p_i_mfg_ref => 'CHEVROLET'    , p_i_ref_code => 'Silverado');
  p_ins_vehicle_model(p_i_desc => 'Malibu', p_i_mfg_ref => 'CHEVROLET'    , p_i_ref_code => 'Malibu');
  p_ins_vehicle_model(p_i_desc => 'Equinox', p_i_mfg_ref => 'CHEVROLET'    , p_i_ref_code => 'Equinox');
  p_ins_vehicle_model(p_i_desc => 'C-Class', p_i_mfg_ref => 'MERCEDES-BENZ', p_i_ref_code => 'C-Class');
  p_ins_vehicle_model(p_i_desc => 'E-Class', p_i_mfg_ref => 'MERCEDES-BENZ', p_i_ref_code => 'E-Class');
  p_ins_vehicle_model(p_i_desc => 'GLE', p_i_mfg_ref => 'MERCEDES-BENZ', p_i_ref_code => 'GLE');
  p_ins_vehicle_model(p_i_desc => 'Golf', p_i_mfg_ref => 'VOLKSWAGEN'   , p_i_ref_code => 'Golf');
  p_ins_vehicle_model(p_i_desc => 'Passat', p_i_mfg_ref => 'VOLKSWAGEN'   , p_i_ref_code => 'Passat');
  p_ins_vehicle_model(p_i_desc => 'Tiguan', p_i_mfg_ref => 'VOLKSWAGEN'   , p_i_ref_code => 'Tiguan');
  p_ins_vehicle_model(p_i_desc => 'Altima', p_i_mfg_ref => 'NISSAN'       , p_i_ref_code => 'Altima');
  p_ins_vehicle_model(p_i_desc => 'Rogue', p_i_mfg_ref => 'NISSAN'       , p_i_ref_code => 'Rogue');
  p_ins_vehicle_model(p_i_desc => 'Pathfinder', p_i_mfg_ref => 'NISSAN'       , p_i_ref_code => 'Pathfinder');
  p_ins_vehicle_model(p_i_desc => 'A4', p_i_mfg_ref => 'AUDI'         , p_i_ref_code => 'A4');
  p_ins_vehicle_model(p_i_desc => 'Q5', p_i_mfg_ref => 'AUDI'         , p_i_ref_code => 'Q5');
  p_ins_vehicle_model(p_i_desc => 'A8', p_i_mfg_ref => 'AUDI'         , p_i_ref_code => 'A8');
  p_ins_vehicle_model(p_i_desc => 'Elantra', p_i_mfg_ref => 'HYUNDAI'      , p_i_ref_code => 'Elantra');
  p_ins_vehicle_model(p_i_desc => 'Tucson', p_i_mfg_ref => 'HYUNDAI'      , p_i_ref_code => 'Tucson');
  p_ins_vehicle_model(p_i_desc => 'Santa Fe', p_i_mfg_ref => 'HYUNDAI'      , p_i_ref_code => 'Santa Fe');
  p_ins_vehicle_model(p_i_desc => 'Optima', p_i_mfg_ref => 'KIA'          , p_i_ref_code => 'Optima');
  p_ins_vehicle_model(p_i_desc => 'Sportage', p_i_mfg_ref => 'KIA'          , p_i_ref_code => 'Sportage');
  p_ins_vehicle_model(p_i_desc => 'Sorento', p_i_mfg_ref => 'KIA'          , p_i_ref_code => 'Sorento');
  p_ins_vehicle_model(p_i_desc => '500', p_i_mfg_ref => 'FIAT'         , p_i_ref_code => '500');
  p_ins_vehicle_model(p_i_desc => 'Panda', p_i_mfg_ref => 'FIAT'         , p_i_ref_code => 'Panda');
  p_ins_vehicle_model(p_i_desc => 'Tipo', p_i_mfg_ref => 'FIAT'         , p_i_ref_code => 'Tipo');
  p_ins_vehicle_model(p_i_desc => 'Mazda3', p_i_mfg_ref => 'MAZDA'        , p_i_ref_code => 'Mazda3');
  p_ins_vehicle_model(p_i_desc => 'CX-5', p_i_mfg_ref => 'MAZDA'        , p_i_ref_code => 'CX-5');
  p_ins_vehicle_model(p_i_desc => 'Mazda6', p_i_mfg_ref => 'MAZDA'        , p_i_ref_code => 'Mazda6');
  p_ins_vehicle_model(p_i_desc => 'Impreza', p_i_mfg_ref => 'SUBARU'       , p_i_ref_code => 'Impreza');
  p_ins_vehicle_model(p_i_desc => 'Outback', p_i_mfg_ref => 'SUBARU'       , p_i_ref_code => 'Outback');
  p_ins_vehicle_model(p_i_desc => 'Forester', p_i_mfg_ref => 'SUBARU'       , p_i_ref_code => 'Forester');
  p_ins_vehicle_model(p_i_desc => 'Wrangler', p_i_mfg_ref => 'JEEP'         , p_i_ref_code => 'Wrangler');
  p_ins_vehicle_model(p_i_desc => 'Grand Cherokee', p_i_mfg_ref => 'JEEP'         , p_i_ref_code => 'Grand Cherokee');
  p_ins_vehicle_model(p_i_desc => 'Cherokee', p_i_mfg_ref => 'JEEP'         , p_i_ref_code => 'Cherokee');
  p_ins_vehicle_model(p_i_desc => 'RX', p_i_mfg_ref => 'LEXUS'        , p_i_ref_code => 'RX');
  p_ins_vehicle_model(p_i_desc => 'ES', p_i_mfg_ref => 'LEXUS'        , p_i_ref_code => 'ES');
  p_ins_vehicle_model(p_i_desc => 'NX', p_i_mfg_ref => 'LEXUS'        , p_i_ref_code => 'NX');
  p_ins_vehicle_model(p_i_desc => 'XC60', p_i_mfg_ref => 'VOLVO'        , p_i_ref_code => 'XC60');
  p_ins_vehicle_model(p_i_desc => 'S60', p_i_mfg_ref => 'VOLVO'        , p_i_ref_code => 'S60');
  p_ins_vehicle_model(p_i_desc => 'V90', p_i_mfg_ref => 'VOLVO'        , p_i_ref_code => 'V90');
  p_ins_vehicle_model(p_i_desc => '911', p_i_mfg_ref => 'PORSCHE'      , p_i_ref_code => '911');
  p_ins_vehicle_model(p_i_desc => 'Cayenne', p_i_mfg_ref => 'PORSCHE'      , p_i_ref_code => 'Cayenne');
  p_ins_vehicle_model(p_i_desc => 'Panamera', p_i_mfg_ref => 'PORSCHE'      , p_i_ref_code => 'Panamera');
  p_ins_vehicle_model(p_i_desc => 'Model S', p_i_mfg_ref => 'TESLA'        , p_i_ref_code => 'Model S');
  p_ins_vehicle_model(p_i_desc => 'Model 3', p_i_mfg_ref => 'TESLA'        , p_i_ref_code => 'Model 3');
  p_ins_vehicle_model(p_i_desc => 'Model X', p_i_mfg_ref => 'TESLA'        , p_i_ref_code => 'Model X');
  p_ins_vehicle_model(p_i_desc => 'F-Type', p_i_mfg_ref => 'JAGUAR'       , p_i_ref_code => 'F-Type');
  p_ins_vehicle_model(p_i_desc => 'XF', p_i_mfg_ref => 'JAGUAR'       , p_i_ref_code => 'XF');
  p_ins_vehicle_model(p_i_desc => 'I-PACE', p_i_mfg_ref => 'JAGUAR'       , p_i_ref_code => 'I-PACE');
  p_ins_vehicle_model(p_i_desc => 'Clio', p_i_mfg_ref => 'RENAULT'      , p_i_ref_code => 'Clio');
  p_ins_vehicle_model(p_i_desc => 'Megane', p_i_mfg_ref => 'RENAULT'      , p_i_ref_code => 'Megane');
  p_ins_vehicle_model(p_i_desc => 'Captur', p_i_mfg_ref => 'RENAULT'      , p_i_ref_code => 'Captur');

  
  commit;
exception
  when others
  then
    rollback;
    raise;
end;

/

--DDL
--evp_vehicle
CREATE TABLE wksp_evp.evp_vehicle (
    id                NUMBER NOT NULL,
    vin               CHAR(17 CHAR) NOT NULL,
    jom               VARCHAR2(50 CHAR) NOT NULL,
    prodaction_date   DATE NOT NULL,
    first_reg_date    DATE NOT NULL,
    plate_number      VARCHAR2(30 CHAR),
    door_number       NUMBER,
    seat_number       NUMBER,
    wheel_number      NUMBER,
    motor_volume      NUMBER NOT NULL,
    co2_emission      NUMBER NOT NULL,
    power_kw          NUMBER NOT NULL,
    euro_norm         VARCHAR2(10 CHAR) NOT NULL,
    fuel_type         VARCHAR2(20 CHAR) NOT NULL,
    color             VARCHAR2(250 CHAR) NOT NULL,
    axel_number       NUMBER NOT NULL,
    drive_axel_number NUMBER NOT NULL,
    note              VARCHAR2(500 CHAR),
    user_crated       VARCHAR2(50 CHAR) NOT NULL,
    date_crated       DATE NOT NULL,
    user_updated      VARCHAR2(50 CHAR),
    date_updated      DATE,
    owner_id          NUMBER NOT NULL,
    category_id       NUMBER NOT NULL,
    model_id          NUMBER NOT NULL,
    body_shape_id     NUMBER NOT NULL
);

ALTER TABLE wksp_evp.evp_vehicle
    ADD CHECK ( euro_norm IN ( 'Euro 3 ili niže', 'Euro 4', 'Euro 5', 'Euro 6', 'Euro 7',
                               'Nije primjenjivo' ) );

ALTER TABLE wksp_evp.evp_vehicle
    ADD CHECK ( fuel_type IN ( 'Benzin', 'Diesel', 'Elektro', 'Hibrid' ) );

COMMENT ON COLUMN wksp_evp.evp_vehicle.id IS
    'Primary key';

COMMENT ON COLUMN wksp_evp.evp_vehicle.vin IS
    'Vechicle unique number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.jom IS
    'jedinstvena oznaka modela';

COMMENT ON COLUMN wksp_evp.evp_vehicle.prodaction_date IS
    'Vehicle production date';

COMMENT ON COLUMN wksp_evp.evp_vehicle.first_reg_date IS
    'Vehicle first registration date';

COMMENT ON COLUMN wksp_evp.evp_vehicle.plate_number IS
    'Registration plate number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.door_number IS
    'Vehicle door number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.seat_number IS
    'Vehicle seat number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.wheel_number IS
    'Vehicle wheel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.motor_volume IS
    'Motor volume';

COMMENT ON COLUMN wksp_evp.evp_vehicle.co2_emission IS
    'Vehicle co2 emisson';

COMMENT ON COLUMN wksp_evp.evp_vehicle.power_kw IS
    'Vehicle power in Kw';

COMMENT ON COLUMN wksp_evp.evp_vehicle.euro_norm IS
    'Euro norm';

COMMENT ON COLUMN wksp_evp.evp_vehicle.fuel_type IS
    'Fuel type';

COMMENT ON COLUMN wksp_evp.evp_vehicle.color IS
    'Color';

COMMENT ON COLUMN wksp_evp.evp_vehicle.axel_number IS
    'Vehicle axel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.drive_axel_number IS
    'Vehicle drive axel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle.note IS
    'Additional notes';

COMMENT ON COLUMN wksp_evp.evp_vehicle.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle.date_updated IS
    'Updated date';

COMMENT ON COLUMN wksp_evp.evp_vehicle.owner_id IS
    'Owner FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle.category_id IS
    'Category FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle.model_id IS
    'Model FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle.body_shape_id IS
    'Body shape FK ID';

CREATE INDEX wksp_evp.evp_vehicle_own_idx ON
    wksp_evp.evp_vehicle (
        owner_id
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_vca_idx ON
    wksp_evp.evp_vehicle (
        category_id
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_vmo_idx ON
    wksp_evp.evp_vehicle (
        model_id
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_vin_idx ON
    wksp_evp.evp_vehicle (
        vin
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_vbs_idx ON
    wksp_evp.evp_vehicle (
        body_shape_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle ADD CONSTRAINT evp_vehicle_pk PRIMARY KEY ( id );


ALTER TABLE wksp_evp.evp_vehicle ADD CONSTRAINT evp_vehicle_vin_plnum_un UNIQUE ( vin,
                                                                                  plate_number );

ALTER TABLE wksp_evp.evp_vehicle
    ADD CONSTRAINT evp_vehicle_evp_owners_fk FOREIGN KEY ( owner_id )
        REFERENCES wksp_evp.evp_owner ( id );

ALTER TABLE wksp_evp.evp_vehicle
    ADD CONSTRAINT evp_vehicle_evp_vbs_fk FOREIGN KEY ( body_shape_id )
        REFERENCES wksp_evp.evp_vehicle_body_shape ( id );

ALTER TABLE wksp_evp.evp_vehicle
    ADD CONSTRAINT evp_vehicle_evp_vca_fk FOREIGN KEY ( category_id )
        REFERENCES wksp_evp.evp_vehicle_category ( id );

ALTER TABLE wksp_evp.evp_vehicle
    ADD CONSTRAINT evp_vehicle_evp_vmo_fk FOREIGN KEY ( model_id )
        REFERENCES wksp_evp.evp_vehicle_model ( id );

create or replace trigger wksp_evp.evp_trg_veh_biu
  before insert or update
  on wksp_evp.evp_vehicle
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/
--dodano 03.04.2024. owner više nije mandatory
alter table wksp_evp.evp_vehicle
  modify owner_id null;

/


--DDL
--evp_vehicle_photos
CREATE TABLE wksp_evp.evp_vehicle_photo (
    id           NUMBER NOT NULL,
    file_number  NUMBER NOT NULL,
    mime_type    VARCHAR2(1000 CHAR) NOT NULL,
    file_blob    BLOB NOT NULL,
    main_photo   CHAR(1 CHAR) NOT NULL,
    file_name    VARCHAR2(200 CHAR) NOT NULL,
    extension    VARCHAR2(10),
    description  VARCHAR2(4000 CHAR),
    file_type    VARCHAR2(50 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE,
    vehicle_id   NUMBER NOT NULL
);

ALTER TABLE wksp_evp.evp_vehicle_photo
    ADD CHECK ( file_type IN ( 'DOCUMENT', 'OTHER', 'PICTURE' ) );

COMMENT ON TABLE wksp_evp.evp_vehicle_photo IS
    'Vehicle body shape';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.id IS
    'Photo ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.file_number IS
    'Photo number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.mime_type IS
    'MIME type';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.file_blob IS
    'Photo data';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.main_photo IS
    'Main photo flag';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.file_name IS
    'Photo file name';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.extension IS
    'Extenstion';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.description IS
    'Photo description';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.file_type IS
    'Photo type';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.date_updated IS
    'Updated date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_photo.vehicle_id IS
    'Vehice FK ID';

CREATE INDEX wksp_evp.evp_vph_idx ON
    wksp_evp.evp_vehicle_photo (
        file_number
    ASC,
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_photo
    ADD CONSTRAINT evp_vehicle_photos_ck_1 CHECK ( main_photo IN ( '0', '1' ) );

ALTER TABLE wksp_evp.evp_vehicle_photo ADD CONSTRAINT evp_vehicle_photos_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_photo ADD CONSTRAINT evp_vehicle_photos__un UNIQUE ( file_number,
                                                                                      vehicle_id );

--ALTER TABLE wksp_evp.evp_vehicle_photo ADD CONSTRAINT evp_vehicle_photos__unv1 UNIQUE ( vehicle_id,
--                                                                                        main_photo );

--ALTER TABLE wksp_evp.evp_vehicle_photo drop constraint EVP_VEHICLE_PHOTOS__UNV1;

ALTER TABLE wksp_evp.evp_vehicle_photo
    ADD CONSTRAINT evp_vehicle_photos_veh_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
        
create or replace trigger wksp_evp.evp_trg_vph_biu
  before insert or update
  on wksp_evp.evp_vehicle_photo
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--DDL
--evp_tyre_type
CREATE TABLE wksp_evp.evp_tyre_type (
    id           NUMBER NOT NULL,
    ref_code     VARCHAR2(50) NOT NULL,
    description  VARCHAR2(4000 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_tyre_type IS
    'Vehicle categories';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.id IS
    'Tyre type ID';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.ref_code IS
    'Tyre type ref code';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.description IS
    'Tyre type description';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_tyre_type.date_updated IS
    'Updated date';

ALTER TABLE wksp_evp.evp_tyre_type ADD CONSTRAINT evp_tyres_types_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_tyre_type ADD CONSTRAINT evp_tyres_types_ref_code_un UNIQUE ( ref_code );

create or replace trigger wksp_evp.evp_trg_tyr_biu
  before insert or update
  on wksp_evp.evp_tyre_type
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--PL/SQL insert tyre types
declare
  procedure p_ins_tyre_type (
    p_i_ref_code  in wksp_evp.evp_tyre_type.ref_code%type
   ,p_i_desc      in wksp_evp.evp_tyre_type.description%type)
  is
    v_id      number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_tyre_type
     where ref_code = p_i_ref_code;

    if v_id is null
    then
      insert into wksp_evp.evp_tyre_type (
                    ref_code
                   ,description)
           values (p_i_ref_code, p_i_desc);
    else
      update wksp_evp.evp_tyre_type
         set ref_code = p_i_ref_code
            ,description = p_i_desc
       where id = v_id;
    end if;
  end;
begin

  p_ins_tyre_type(p_i_desc => '205/55R16', p_i_ref_code => '205/55R16');
  p_ins_tyre_type(p_i_desc => '225/45R17', p_i_ref_code => '225/45R17');
  p_ins_tyre_type(p_i_desc => '195/65R15', p_i_ref_code => '195/65R15');
  p_ins_tyre_type(p_i_desc => '245/40R18', p_i_ref_code => '245/40R18');
  p_ins_tyre_type(p_i_desc => '265/70R16', p_i_ref_code => '265/70R16');
  p_ins_tyre_type(p_i_desc => '185/60R14', p_i_ref_code => '185/60R14');
  p_ins_tyre_type(p_i_desc => '215/60R16', p_i_ref_code => '215/60R16');
  p_ins_tyre_type(p_i_desc => '175/70R13', p_i_ref_code => '175/70R13');
  p_ins_tyre_type(p_i_desc => '255/35R20', p_i_ref_code => '255/35R20');
  p_ins_tyre_type(p_i_desc => '235/75R15', p_i_ref_code => '235/75R15');    
  
  commit;
exception
  when others
  then
    rollback;
    raise;
end;

/



--DDL
--evp_vehicle_tyre
CREATE TABLE wksp_evp.evp_vehicle_tyre (
    id           NUMBER NOT NULL,
    tyre_type_id NUMBER NOT NULL,
    vehicle_id   NUMBER NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_tyre IS
    'FK vehicle and allowed tyres';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.id IS
    'Primary key';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.tyre_type_id IS
    'Tyre type FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.vehicle_id IS
    'Vehicel FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_tyre.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_vehicle_tyres__idx ON
    wksp_evp.evp_vehicle_tyre (
        tyre_type_id
    ASC,
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_tyre ADD CONSTRAINT evp_vehicle_tyres_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_tyre
    ADD CONSTRAINT evp_vehicle_tyres_tyr_fk FOREIGN KEY ( tyre_type_id )
        REFERENCES wksp_evp.evp_tyre_type ( id );

ALTER TABLE wksp_evp.evp_vehicle_tyre
    ADD CONSTRAINT evp_vehicle_tyres_veh_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );

create or replace trigger wksp_evp.evp_trg_vet_biu
  before insert or update
  on wksp_evp.evp_vehicle_tyre
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--DDL
--evp_vehicle_history
CREATE TABLE wksp_evp.evp_vehicle_history (
    id                NUMBER NOT NULL,
    vin               CHAR(17 CHAR) NOT NULL,
    jom               VARCHAR2(50 CHAR) NOT NULL,
    prodaction_date   DATE NOT NULL,
    first_reg_date    DATE NOT NULL,
    plate_number      VARCHAR2(30 CHAR),
    door_number       NUMBER,
    seat_number       NUMBER,
    wheel_number      NUMBER,
    motor_volume      NUMBER NOT NULL,
    co2_emission      NUMBER NOT NULL,
    power_kw          NUMBER NOT NULL,
    euro_norm         VARCHAR2(10 CHAR) NOT NULL,
    fuel_type         VARCHAR2(20 CHAR) NOT NULL,
    color             VARCHAR2(250 CHAR) NOT NULL,
    axel_number       NUMBER NOT NULL,
    drive_axel_number NUMBER NOT NULL,
    note              VARCHAR2(500 CHAR),
    user_crated       VARCHAR2(50 CHAR) NOT NULL,
    date_crated       DATE NOT NULL,
    user_updated      VARCHAR2(50 CHAR),
    date_updated      DATE,
    valid_from        DATE NOT NULL,
    valid_to          DATE,
    vehicle_id        NUMBER NOT NULL,
    owner_id          NUMBER NOT NULL,
    category_id       NUMBER NOT NULL,
    model_id          NUMBER NOT NULL,
    body_shape_id     NUMBER NOT NULL
);

ALTER TABLE wksp_evp.evp_vehicle_history
    ADD CHECK ( euro_norm IN ( 'Euro 3 ili niže', 'Euro 4', 'Euro 5', 'Euro 6', 'Euro 7',
                               'Nije primjenjivo' ) );

ALTER TABLE wksp_evp.evp_vehicle_history
    ADD CHECK ( fuel_type IN ( 'Benzin', 'Diesel', 'Elektro', 'Hibrid' ) );

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.vin IS
    'Vechicle unique number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.prodaction_date IS
    'Vehicle production date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.first_reg_date IS
    'Vehicle first registration date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.plate_number IS
    'Registration plate number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.door_number IS
    'Vehicle door number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.seat_number IS
    'Vehicle seat number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.wheel_number IS
    'Vehicle wheel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.co2_emission IS
    'Vehicle co2 emisson';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.power_kw IS
    'Vehicle power in Kw';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.euro_norm IS
    'Euro norm';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.fuel_type IS
    'Euro norm';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.axel_number IS
    'Vehicle axel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.drive_axel_number IS
    'Vehicle drive axel number';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.note IS
    'Additional notes';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.date_updated IS
    'Updated date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.valid_from IS
    'Valid from date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.valid_to IS
    'Valid to date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.owner_id IS
    'Owner FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.category_id IS
    'Category FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.model_id IS
    'Model FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_history.body_shape_id IS
    'Body shape FK ID';

CREATE INDEX wksp_evp.evp_vehicle_history_veh_idx ON
    wksp_evp.evp_vehicle_history (
        vehicle_id
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_history_jom_idx ON
    wksp_evp.evp_vehicle_history (
        jom
    ASC );

CREATE INDEX wksp_evp.evp_vehicle_history_vin_idx ON
    wksp_evp.evp_vehicle_history (
        vin
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_history ADD CONSTRAINT evp_vehicle_history_pk PRIMARY KEY ( id );

create or replace trigger wksp_evp.evp_trg_vhh_biu
  before insert or update
  on wksp_evp.evp_vehicle_history
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/

/* Formatted on 11/11/2023/ 9:38:14 (QP5 v5.391) */
create or replace trigger wksp_evp.evp_trg_veh_aiu
  after insert or update or delete
  on wksp_evp.evp_vehicle
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  wksp_evp.evp_vehicle_history.action%type;
  v_veh_hist_row   wksp_evp.evp_vehicle_history%rowtype;
  greska           exception;
begin
  if inserting
  then
    v_radnja_oznaka := 'INSERT';
  elsif updating
  then
    v_radnja_oznaka := 'UPDATE';
  else
    v_radnja_oznaka := 'DELETE';
  end if;


  v_veh_hist_row.vin := nvl (:new.vin, :old.vin);
  v_veh_hist_row.jom := nvl (:new.jom, :old.jom);
  v_veh_hist_row.prodaction_date :=
    nvl (:new.prodaction_date, :old.prodaction_date);
  v_veh_hist_row.first_reg_date :=
    nvl (:new.first_reg_date, :old.first_reg_date);
  v_veh_hist_row.plate_number := nvl (:new.plate_number, :old.plate_number);
  v_veh_hist_row.door_number := nvl (:new.door_number, :old.door_number);
  v_veh_hist_row.seat_number := nvl (:new.seat_number, :old.seat_number);
  v_veh_hist_row.wheel_number := nvl (:new.wheel_number, :old.wheel_number);
  v_veh_hist_row.motor_volume := nvl (:new.motor_volume, :old.motor_volume);
  v_veh_hist_row.co2_emission := nvl (:new.co2_emission, :old.co2_emission);
  v_veh_hist_row.power_kw := nvl (:new.power_kw, :old.power_kw);
  v_veh_hist_row.euro_norm := nvl (:new.euro_norm, :old.euro_norm);
  v_veh_hist_row.fuel_type := nvl (:new.fuel_type, :old.fuel_type);
  v_veh_hist_row.color := nvl (:new.color, :old.color);
  v_veh_hist_row.axel_number := nvl (:new.axel_number, :old.axel_number);
  v_veh_hist_row.drive_axel_number :=
    nvl (:new.drive_axel_number, :old.drive_axel_number);
  v_veh_hist_row.note := nvl (:new.note, :old.note);
  v_veh_hist_row.valid_from := sysdate;
  v_veh_hist_row.vehicle_id := nvl (:new.id, :old.id);
  v_veh_hist_row.owner_id := nvl (:new.owner_id, :old.owner_id);
  v_veh_hist_row.category_id := nvl (:new.category_id, :old.category_id);
  v_veh_hist_row.model_id := nvl (:new.model_id, :old.model_id);
  v_veh_hist_row.body_shape_id :=
    nvl (:new.body_shape_id, :old.body_shape_id);
  v_veh_hist_row.action := v_radnja_oznaka;

  update wksp_evp.evp_vehicle_history
     set valid_to = sysdate
   where vehicle_id = v_veh_hist_row.vehicle_id
         and valid_from = (select max (valid_from)
                             from wksp_evp.evp_vehicle_history
                            where vehicle_id = v_veh_hist_row.vehicle_id);

  insert into wksp_evp.evp_vehicle_history
       values v_veh_hist_row;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/
--dodano 05.04.2024. owner više nije mandatory
alter table wksp_evp.evp_vehicle_history
  modify owner_id null;

/



--DDL
--evp_fuel_consumption
CREATE TABLE wksp_evp.evp_fuel_consumption (
    id                 NUMBER NOT NULL,
    vehicle_id         NUMBER NOT NULL,
    date_full_tank     DATE NOT NULL,
    filled_full_amount NUMBER NOT NULL,
    user_crated        VARCHAR2(50 CHAR) NOT NULL,
    date_crated        DATE NOT NULL,
    user_updated       VARCHAR2(50 CHAR),
    date_updated       DATE
);

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.id IS
    'Primary key';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.vehicle_id IS
    'Vehicle FK ID';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.date_full_tank IS
    'Date tank was filled full';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.filled_full_amount IS
    'Littes filed to full tank';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_fuel_consumption.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_fuel_consumption_veh_idx ON
    wksp_evp.evp_fuel_consumption (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_fuel_consumption ADD CONSTRAINT evp_fuel_consumption_pk PRIMARY KEY ( id );


ALTER TABLE wksp_evp.evp_fuel_consumption
    ADD CONSTRAINT evp_fuel_consumption_vhl_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
create or replace trigger wksp_evp.evp_trg_flc_biu
  before insert or update
  on wksp_evp.evp_fuel_consumption
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/

--DDL
--evp_travel_evidention
CREATE TABLE wksp_evp.evp_travel_evidention (
    id                       NUMBER NOT NULL,
    vehicle_id               NUMBER NOT NULL,
    date_traveled_evidention DATE NOT NULL,
    traveled_distance        NUMBER NOT NULL,
    user_crated              VARCHAR2(50 CHAR) NOT NULL,
    date_crated              DATE NOT NULL,
    user_updated             VARCHAR2(50 CHAR),
    date_updated             DATE
);

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.id IS
    'Primary key';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.vehicle_id IS
    'Vehicle FK ID';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.date_traveled_evidention IS
    'Date of evidention';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.traveled_distance IS
    'Distance traveled on date';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_travel_evidention.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_travel_evidention_veh_idx ON
    wksp_evp.evp_travel_evidention (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_travel_evidention ADD CONSTRAINT evp_travel_evidention_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_travel_evidention
    ADD CONSTRAINT evp_travel_evidention_veh_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
create or replace trigger wksp_evp.evp_trg_tre_biu
  before insert or update
  on wksp_evp.evp_travel_evidention
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/

--PL & DDL
--add history action

alter table wksp_evp.evp_vehicle_history
  add action varchar2 (50 char);

alter table wksp_evp.evp_vehicle_history
  add check (action in ('DELETE', 'INSERT', 'UPDATE'));

comment on column wksp_evp.evp_vehicle_history.action is 'Database action';

update wksp_evp.evp_vehicle_history
   set action = 'INSERT';

alter table wksp_evp.evp_vehicle_history
  modify action varchar2 (50 char) not null;
  
/

--DDL
--evp_v_vehicle_consumption

/* Formatted on 18/11/2023/ 17:47:53 (QP5 v5.391) */
create or replace view wksp_evp.evp_v_vehicle_consumption
as
  with
    fuel_csp_date_cols
    as
      (select vehicle_id
             ,extract (year from flc.date_full_tank)    flc_year
             ,to_char (flc.date_full_tank, 'Q')         flc_quarter
             ,extract (month from flc.date_full_tank)   flc_month
             ,flc.filled_full_amount                    flc_amount
         from wksp_evp.evp_fuel_consumption flc),
    fuel_csp
    as
      (  select vehicle_id
               ,flc.flc_year
               ,flc.flc_quarter
               ,flc.flc_month
               ,sum (flc.flc_amount)   flc_amount_sum
           from fuel_csp_date_cols flc
       group by rollup (vehicle_id
                       ,flc.flc_year
                       ,flc.flc_quarter
                       ,flc.flc_month)
       order by vehicle_id
               ,flc.flc_year
               ,flc.flc_quarter
               ,flc.flc_month),
    travel_evd_date_cols
    as
      (select tre.vehicle_id
             ,tre.traveled_distance                               tre_distance
             ,extract (year from tre.date_traveled_evidention)    tre_year
             ,to_char (tre.date_traveled_evidention, 'Q')         tre_quarter
             ,extract (month from tre.date_traveled_evidention)   tre_month
         from wksp_evp.evp_travel_evidention tre),
    travel_evd
    as
      (  select tre.vehicle_id
               ,tre.tre_year
               ,tre.tre_quarter
               ,tre.tre_month
               ,tre.tre_distance
               ,lag (tre.tre_distance)
                  over (
                    partition by tre.vehicle_id
                    order by
                      tre.vehicle_id
                     ,tre.tre_year
                     ,tre.tre_quarter
                     ,tre.tre_month)  prev_distance
           from travel_evd_date_cols tre
       order by tre.vehicle_id
               ,tre.tre_year
               ,tre.tre_quarter
               ,tre.tre_month),
    travel_evd_diff
    as
      (  select tre.vehicle_id
               ,tre.tre_year
               ,tre.tre_quarter
               ,tre.tre_month
               ,sum (tre.tre_distance - tre.prev_distance)   traveled_dst
           from travel_evd tre
       group by rollup (vehicle_id
                       ,tre.tre_year
                       ,tre.tre_quarter
                       ,tre.tre_month)
       order by tre.vehicle_id
               ,tre.tre_year
               ,tre.tre_quarter
               ,tre.tre_month)
  select case
           when tre.tre_month is not null
           then
             tre.tre_month || '. mjesec ' || tre.tre_year || '.'
           when tre.tre_quarter is not null and tre.tre_month is null
           then
             tre.tre_quarter || '. kvartal ' || tre.tre_year || '.'
           when tre.tre_quarter is null and tre.tre_year is not null
           then
             tre.tre_year || '. godina'
         end                                                       date_period
        ,case
           when tre.tre_month is not null
           then
             'M'
           when tre.tre_quarter is not null and tre.tre_month is null
           then
             'Q'
           when tre.tre_quarter is null and tre.tre_year is not null
           then
             'Y'
         end                                                       date_period_code
        ,round ((csp.flc_amount_sum / tre.traveled_dst) * 100, 2)  consumption
        ,csp.flc_year
        ,nvl(csp.flc_quarter ,0) flc_quarter
        ,nvl(csp.flc_month   ,0) flc_month
        ,csp.flc_amount_sum
        ,tre.vehicle_id
        ,tre.tre_year
        ,nvl(tre.tre_quarter,0) tre_quarter
        ,nvl(tre.tre_month  ,0) tre_month
        ,tre.traveled_dst
    from travel_evd_diff tre
         join fuel_csp csp
              on csp.vehicle_id = tre.vehicle_id
                 and csp.flc_year = tre.tre_year
                 and nvl (csp.flc_month, 0) = nvl (tre.tre_month, 0)
                 and nvl (csp.flc_quarter, 0) = nvl (tre.tre_quarter, 0);


/
--DDL
--evp_employee
CREATE TABLE wksp_evp.evp_employee (
    id           NUMBER NOT NULL,
    oib          CHAR(11 CHAR) NOT NULL,
    name         VARCHAR2(100 CHAR) NOT NULL,
    lastname     VARCHAR2(100 CHAR) NOT NULL,
    address      VARCHAR2(4000 CHAR),
    apex_user_id NUMBER,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_employee IS
    'Employee';

COMMENT ON COLUMN wksp_evp.evp_employee.id IS
    'Employee  ID';

COMMENT ON COLUMN wksp_evp.evp_employee.oib IS
    'OIB';

COMMENT ON COLUMN wksp_evp.evp_employee.name IS
    'Firstname';

COMMENT ON COLUMN wksp_evp.evp_employee.lastname IS
    'Lastname';

COMMENT ON COLUMN wksp_evp.evp_employee.address IS
    'Employee  address';

COMMENT ON COLUMN wksp_evp.evp_employee.apex_user_id IS
    'apex_appl_acl_users ID';

COMMENT ON COLUMN wksp_evp.evp_employee.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_employee.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_employee.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_employee.date_updated IS
    'Updated date';

ALTER TABLE wksp_evp.evp_employee ADD CONSTRAINT evp_employee_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_employee ADD CONSTRAINT emp_acl_un UNIQUE ( apex_user_id );

create or replace trigger wksp_evp.evp_trg_emp_biu
  before insert or update
  on wksp_evp.evp_employee
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/


--DDL
--evp_technical_inspection
CREATE TABLE wksp_evp.evp_technical_inspection (
    id           NUMBER NOT NULL,
    valid_from   DATE NOT NULL,
    valid_to     DATE NOT NULL,
    vehicle_id   NUMBER NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_technical_inspection IS
    'Vehicle technical inspection';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.id IS
    'Technical inspection ID';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.valid_from IS
    'Inspection valid from';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.valid_to IS
    'Inspection valid to';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.vehicle_id IS
    'Vehicle FK';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_technical_inspection.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_tin_vehicle_idx ON
    wksp_evp.evp_technical_inspection (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_technical_inspection ADD CONSTRAINT evp_technical_inspection_pk PRIMARY KEY ( id );

create or replace trigger wksp_evp.evp_trg_tin_biu
  before insert or update
  on wksp_evp.evp_technical_inspection
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/

--DDL
--evp_vehicle_registration
CREATE TABLE wksp_evp.evp_vehicle_registration (
    id           NUMBER NOT NULL,
    valid_from   DATE NOT NULL,
    valid_to     DATE NOT NULL,
    vehicle_id   NUMBER NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_registration IS
    'Vehicle registration';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.id IS
    'Vehicle registration ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.valid_from IS
    'Registration valid from';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.valid_to IS
    'Registration valid to';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.vehicle_id IS
    'Vehicle FK';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_registration.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_ver_vehicle_idx ON
    wksp_evp.evp_vehicle_registration (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_registration ADD CONSTRAINT evp_vehicle_registration_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_technical_inspection
    ADD CONSTRAINT evp_tin_vehicle_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );

ALTER TABLE wksp_evp.evp_vehicle_registration
    ADD CONSTRAINT evp_ver_vehicle_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
create or replace trigger wksp_evp.evp_trg_ver_biu
  before insert or update
  on wksp_evp.evp_vehicle_registration
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
/

--DDL
--evp_notification_user_act
CREATE TABLE wksp_evp.evp_notification_user_act (
    id              NUMBER NOT NULL,
    activity_type   VARCHAR2(50 CHAR) NOT NULL,
    notification_id NUMBER,
    user_crated     VARCHAR2(50 CHAR) NOT NULL,
    date_crated     DATE NOT NULL,
    user_updated    VARCHAR2(50 CHAR),
    date_updated    DATE
);

ALTER TABLE wksp_evp.evp_notification_user_act
    ADD CHECK ( activity_type IN ( 'DISMISSED', 'OPENED' ) );

COMMENT ON TABLE wksp_evp.evp_notification_user_act IS
    'Notification user activity';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.id IS
    'Notification user activity ID';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.activity_type IS
    'User activity type';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_notification_user_act.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_nua_ven_idx ON
    wksp_evp.evp_notification_user_act (
        notification_id
    ASC );

ALTER TABLE wksp_evp.evp_notification_user_act ADD CONSTRAINT evp_notification_user_act_pk PRIMARY KEY ( id,
                                                                                                         user_crated );
                                                                                                         
/                                                                                                         
create or replace trigger wksp_evp.evp_trg_nua_biu
  before insert or update
  on wksp_evp.evp_notification_user_act
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/
--DDL
--evp_vehicle_notification
CREATE TABLE wksp_evp.evp_vehicle_notification (
    id           NUMBER NOT NULL,
    receiver     VARCHAR2(200 CHAR) DEFAULT 'USERS' NOT NULL,
    title        VARCHAR2(100 CHAR) NOT NULL,
    content      VARCHAR2(500 CHAR) NOT NULL,
    sender       VARCHAR2(200 CHAR) DEFAULT 'SYSTEM' NOT NULL,
    metadata     CLOB NOT NULL,
    type         VARCHAR2(50 CHAR) NOT NULL,
    priority     VARCHAR2(50 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

ALTER TABLE wksp_evp.evp_vehicle_notification
    ADD CHECK ( type IN ( 'APP', 'E-MAIL' ) );

ALTER TABLE wksp_evp.evp_vehicle_notification
    ADD CHECK ( priority IN ( 'HIGH', 'LOW', 'NO', 'URGENT' ) );

COMMENT ON TABLE wksp_evp.evp_vehicle_notification IS
    'Vehicle notifications';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.id IS
    'Notification  ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.receiver IS
    'Receiver of notification';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.title IS
    'Title';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.content IS
    'Content';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.sender IS
    'Sender of notification';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.metadata IS
    'Metadata more about notification in json format';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.type IS
    'Type';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.priority IS
    'Priority';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_notification.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_ven_receiver_idx ON
    wksp_evp.evp_vehicle_notification (
        receiver
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_notification ADD CONSTRAINT evp_vehicle_notification_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_notification_user_act
    ADD CONSTRAINT evp_nua_ven_fk FOREIGN KEY ( notification_id )
        REFERENCES wksp_evp.evp_vehicle_notification ( id );
        
/

create or replace trigger wksp_evp.evp_trg_ven_biu
  before insert or update
  on wksp_evp.evp_vehicle_notification
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/
--DDL
--evp_settlement
CREATE TABLE wksp_evp.evp_settlement (
    id           NUMBER NOT NULL,
    settlement   VARCHAR2(100 CHAR) NOT NULL,
    postal_code  VARCHAR2(20 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_settlement IS
    'Settlement';

COMMENT ON COLUMN wksp_evp.evp_settlement.id IS
    'Settlement ID';

COMMENT ON COLUMN wksp_evp.evp_settlement.settlement IS
    'Settlment name';

COMMENT ON COLUMN wksp_evp.evp_settlement.postal_code IS
    'Settlement postal code';

COMMENT ON COLUMN wksp_evp.evp_settlement.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_settlement.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_settlement.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_settlement.date_updated IS
    'Updated date';

ALTER TABLE wksp_evp.evp_settlement ADD CONSTRAINT evp_settlement_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_settlement ADD CONSTRAINT evp_sett_postal_un UNIQUE ( settlement,
                                                                      postal_code );
                                                                      
create or replace trigger wksp_evp.evp_trg_set_biu
  before insert or update
  on wksp_evp.evp_settlement
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;                                                                      
                                                                      
/

--DDL
--evp_travelers                                                                
CREATE TABLE wksp_evp.evp_travelers (
    id           NUMBER NOT NULL,
    request_id   NUMBER NOT NULL,
    emp_id       NUMBER NOT NULL,
    driver_ind   VARCHAR2(1 CHAR),
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

ALTER TABLE wksp_evp.evp_travelers
    ADD CONSTRAINT evp_tra_driver_ind_ck CHECK ( driver_ind IN ( '1' ) );

COMMENT ON TABLE wksp_evp.evp_travelers IS
    'Vehicle travelers';

COMMENT ON COLUMN wksp_evp.evp_travelers.id IS
    'Traveler ID';

COMMENT ON COLUMN wksp_evp.evp_travelers.request_id IS
    'Request FK ID';

COMMENT ON COLUMN wksp_evp.evp_travelers.emp_id IS
    'Employee FK ID';

COMMENT ON COLUMN wksp_evp.evp_travelers.driver_ind IS
    'Driver indication';

COMMENT ON COLUMN wksp_evp.evp_travelers.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_travelers.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_travelers.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_travelers.date_updated IS
    'Updated date';

CREATE INDEX evp_tra_request_idx ON
    wksp_evp.evp_travelers (
        request_id
    ASC );

CREATE INDEX evp_tra_employee_idx ON
    wksp_evp.evp_travelers (
        emp_id
    ASC );

CREATE UNIQUE INDEX evp_tra_emp_req_idx ON
    wksp_evp.evp_travelers (
        request_id
    ASC,
        emp_id
    ASC );

ALTER TABLE wksp_evp.evp_travelers ADD CONSTRAINT evp_travelers_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_travelers ADD CONSTRAINT evp_tra_req_un UNIQUE ( request_id,
                                                                 driver_ind );
 

create or replace trigger wksp_evp.evp_trg_tra_biu
  before insert or update
  on wksp_evp.evp_travelers
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;
                                                                
                                                                 
/                                                                 

--DDl
--evp_vehicle_req_sta_history
CREATE TABLE wksp_evp.evp_vehicle_req_sta_history (
    id           NUMBER NOT NULL,
    request_id   NUMBER NOT NULL,
    status_id    NUMBER NOT NULL,
    note         VARCHAR2(4000 CHAR),
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_req_sta_history IS
    'Vehicle request status history';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.id IS
    'Status History  ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.request_id IS
    'Request FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.status_id IS
    'Status FK ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.note IS
    'Status change note';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_req_sta_history.date_updated IS
    'Updated date';

CREATE INDEX evp_rsh_vre_idx ON
    wksp_evp.evp_vehicle_req_sta_history (
        request_id
    ASC );

CREATE INDEX evp_rsh_vrs_idx ON
    wksp_evp.evp_vehicle_req_sta_history (
        stauts_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_req_sta_history ADD CONSTRAINT evp_rsh_pk PRIMARY KEY ( id );

create or replace trigger wksp_evp.evp_trg_rsh_biu
  before insert or update
  on wksp_evp.evp_vehicle_req_sta_history
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/

--DDL
--evp_vehicle_request
CREATE TABLE wksp_evp.evp_vehicle_request (
    id                 NUMBER NOT NULL,
    reservation_code   VARCHAR2(9 CHAR),
    travel_start_date  DATE NOT NULL,
    travel_end_date    DATE NOT NULL,
    settlement_from_id NUMBER NOT NULL,
    settlement_to_id   NUMBER NOT NULL,
    vehicle_id         NUMBER,
    user_crated        VARCHAR2(50 CHAR) NOT NULL,
    date_crated        DATE NOT NULL,
    user_updated       VARCHAR2(50 CHAR),
    date_updated       DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_request IS
    'Vehicle reservation request';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.id IS
    'VEhicle request ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.reservation_code IS
    'Reservation unique code';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.travel_start_date IS
    'Travel start date and time';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.travel_end_date IS
    'Travel end  date and time';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.settlement_from_id IS
    'Settlement travel begin place FK';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.settlement_to_id IS
    'Settlement travel destination  place FK';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.vehicle_id IS
    'VEHICLE ID FK';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request.date_updated IS
    'Updated date';

CREATE UNIQUE INDEX evp_vre_rsrv_code_idxv1 ON
    wksp_evp.evp_vehicle_request (
        reservation_code
    ASC );

CREATE INDEX evp_vre_trv_from_idx ON
    wksp_evp.evp_vehicle_request (
        settlement_from_id
    ASC );

CREATE INDEX evp_vre_trv_to_idx ON
    wksp_evp.evp_vehicle_request (
        settlement_to_id
    ASC );

CREATE INDEX evp_vre_vehicle_idxv2 ON
    wksp_evp.evp_vehicle_request (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_request ADD CONSTRAINT evp_vehicle_request_pk PRIMARY KEY ( id );

create or replace trigger wksp_evp.evp_trg_vre_biu
  before insert or update
  on wksp_evp.evp_vehicle_request
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/

--DDL
--evp_vehicle_request_status
CREATE TABLE wksp_evp.evp_vehicle_request_status (
    id           NUMBER NOT NULL,
    ref_code     VARCHAR2(50) NOT NULL,
    status_name  VARCHAR2(100 CHAR),
    description  VARCHAR2(4000 CHAR) NOT NULL,
    user_crated  VARCHAR2(50 CHAR) NOT NULL,
    date_crated  DATE NOT NULL,
    user_updated VARCHAR2(50 CHAR),
    date_updated DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_request_status IS
    'Vehicle request status';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.id IS
    'Status  ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.ref_code IS
    'Status  ref code';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.status_name IS
    'Status name';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.description IS
    'Status  description';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_request_status.date_updated IS
    'Updated date';

ALTER TABLE wksp_evp.evp_vehicle_request_status ADD CONSTRAINT evp_vehicle_request_status_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_request_status ADD CONSTRAINT evp_vrs_ref_code_un UNIQUE ( ref_code );

create or replace trigger wksp_evp.evp_trg_vrs_biu
  before insert or update
  on wksp_evp.evp_vehicle_request_status
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;

/

ALTER TABLE wksp_evp.evp_vehicle_req_sta_history
    ADD CONSTRAINT evp_rsh_vre_fk FOREIGN KEY ( request_id )
        REFERENCES wksp_evp.evp_vehicle_request ( id );

ALTER TABLE wksp_evp.evp_vehicle_req_sta_history
    ADD CONSTRAINT evp_rsh_vrs_fk FOREIGN KEY ( stauts_id )
        REFERENCES wksp_evp.evp_vehicle_request_status ( id );

ALTER TABLE wksp_evp.evp_travelers
    ADD CONSTRAINT evp_tra_employee_fk FOREIGN KEY ( emp_id )
        REFERENCES wksp_evp.evp_employee ( id );

ALTER TABLE wksp_evp.evp_travelers
    ADD CONSTRAINT evp_tra_request_fk FOREIGN KEY ( request_id )
        REFERENCES wksp_evp.evp_vehicle_request ( id );

ALTER TABLE wksp_evp.evp_vehicle_request
    ADD CONSTRAINT evp_vre_rsh_fk FOREIGN KEY ( settlement_from_id )
        REFERENCES wksp_evp.evp_settlement ( id );

ALTER TABLE wksp_evp.evp_vehicle_request
    ADD CONSTRAINT evp_vre_settl_dest_fk FOREIGN KEY ( settlement_to_id )
        REFERENCES wksp_evp.evp_settlement ( id );

ALTER TABLE wksp_evp.evp_vehicle_request
    ADD CONSTRAINT evp_vre_vehicle_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
/
--DDL
--alter evp_empployee

ALTER TABLE wksp_evp.evp_employee ADD(
    hire_date    DATE NOT NULL,
    finish_date  DATE,
    birth_date   DATE NOT NULL
);

COMMENT ON COLUMN wksp_evp.evp_employee.hire_date IS
    'Hire date';

COMMENT ON COLUMN wksp_evp.evp_employee.finish_date IS
    'Finish  date';

COMMENT ON COLUMN wksp_evp.evp_employee.birth_date IS
    'Birth date';
    
ALTER TABLE wksp_evp.evp_employee ADD(
    gender     VARCHAR2(1 CHAR)
);
    
COMMENT ON COLUMN wksp_evp.evp_employee.gender IS
    'Gender';

/

--PL/SQL insert evp_employee
declare
  procedure p_ins_employees (
    p_i_oib               in wksp_evp.evp_employee.oib%type
   ,p_i_name              in wksp_evp.evp_employee.name%type
   ,p_i_lastname          in wksp_evp.evp_employee.lastname%type
   ,p_i_address           in wksp_evp.evp_employee.address%type
   ,p_i_hire              in wksp_evp.evp_employee.hire_date%type
   ,p_i_gender            in wksp_evp.evp_employee.gender%type
   ,p_i_birth             in wksp_evp.evp_employee.birth_date%type
   ,p_i_job               in wksp_evp.evp_employee.job%type
)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_employee
     where oib = p_i_oib;

    if v_id is null
    then
      insert into wksp_evp.evp_employee (
                    oib
                   ,name
                   ,lastname
                   ,address
                   ,hire_date
                   ,gender
                   ,birth_date
                   ,job)
           values (
                    p_i_oib
                   ,p_i_name
                   ,p_i_lastname
                   ,p_i_address
                   ,p_i_hire
                   ,p_i_gender
                   ,p_i_birth
                   ,p_i_job);
    else
      update wksp_evp.evp_employee
         set oib = p_i_oib
            ,name = p_i_name
            ,lastname = p_i_lastname
            ,address = p_i_address
            ,hire_date = p_i_hire
            ,birth_date = p_i_birth
            ,gender = p_i_gender
            ,job = p_i_job
       where id = v_id;
    end if;
  end;
begin
    
  p_ins_employees(p_i_job => 'Racunovoda', p_i_oib =>'89012345670', p_i_gender => 'F', p_i_name => 'Ana', p_i_lastname =>'Kovacevic', p_i_address =>'Aleja Snova i zvijezda 6, 30130 Sisak', p_i_hire =>to_date('03.08.2009', 'DD.MM.YYYY'), p_i_birth =>to_date('16.07.1991', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Programer', p_i_oib =>'09856543210', p_i_gender => 'M', p_i_name => 'Marko', p_i_lastname =>'Horvat', p_i_address =>'Promenada Nadrealnih prica 51, 40140 Bjelovar', p_i_hire =>to_date('05.08.2010', 'DD.MM.YYYY'), p_i_birth =>to_date('14.06.1989', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Programer', p_i_oib =>'76543210987', p_i_gender => 'F', p_i_name => 'Ivana', p_i_lastname =>'Babic', p_i_address =>'Avenija Beskrajnih mogucnosti 22, 50150 Crikvenica', p_i_hire =>to_date('11.09.2011', 'DD.MM.YYYY'), p_i_birth =>to_date('25.12.1988', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Direktor', p_i_oib =>'43110987654', p_i_gender => 'M', p_i_name => 'Andrej', p_i_lastname =>'Novak', p_i_address =>'Prolaz Carobnih trenutaka 17, 60160 Vukovar', p_i_hire =>to_date('29.02.2012', 'DD.MM.YYYY'), p_i_birth =>to_date('07.04.1993', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Voditelj odjela', p_i_oib =>'21098765432', p_i_gender => 'F', p_i_name => 'Petra', p_i_lastname =>'Juric', p_i_address =>'Naselje Izgubljenih iluzija 38, 70180 Makarska', p_i_hire =>to_date('22.03.2013', 'DD.MM.YYYY'), p_i_birth =>to_date('29.11.1992', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Programer', p_i_oib =>'54321098765', p_i_gender => 'M', p_i_name => 'Nikola', p_i_lastname =>'Tomic', p_i_address =>'Kvart Vrtova mašte 10, 80190 Požega', p_i_hire =>to_date('14.06.2014', 'DD.MM.YYYY'), p_i_birth =>to_date('06.10.1990', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Alatnicar', p_i_oib =>'87650123456', p_i_gender => 'F', p_i_name => 'Marija', p_i_lastname =>'Radic', p_i_address =>'Cesta Tajanstvenih voda 25, 90100 Krapina', p_i_hire =>to_date('25.08.2015', 'DD.MM.YYYY'), p_i_birth =>to_date('18.09.1994', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Mehanicar', p_i_oib =>'12340678901', p_i_gender => 'M', p_i_name => 'Luka', p_i_lastname =>'Vukovic', p_i_address =>'Ulica Raznobojnih horizonta 8, 10010 Vinkovci', p_i_hire =>to_date('09.11.2016', 'DD.MM.YYYY'), p_i_birth =>to_date('28.02.1991', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Racunovoda', p_i_oib =>'87454321098', p_i_gender => 'F', p_i_name => 'Katarina', p_i_lastname =>'Kneževic', p_i_address =>'Trg Nerealnih doživljaja 31, 20030 Županja', p_i_hire =>to_date('03.08.2017', 'DD.MM.YYYY'), p_i_birth =>to_date('01.01.1988', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Pomocnik direktora', p_i_oib =>'98765432109', p_i_gender => 'M', p_i_name => 'Ivan', p_i_lastname =>'Maras', p_i_address =>'Aleja Šarenila i cuda 14, 30070 Kutina', p_i_hire =>to_date('18.09.2018', 'DD.MM.YYYY'), p_i_birth =>to_date('23.07.1993', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Voditelj odjela', p_i_oib =>'13345098765', p_i_gender => 'F', p_i_name => 'Lea', p_i_lastname =>'Petrovic', p_i_address =>'Promenada Bezvremenih prica 49, 40080 Pakrac', p_i_hire =>to_date('07.04.2019', 'DD.MM.YYYY'), p_i_birth =>to_date('17.03.1995', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Kuhar', p_i_oib =>'65432109876', p_i_gender => 'M', p_i_name => 'David', p_i_lastname =>'Matic', p_i_address =>'Avenija Nestvarnih ljubavi 16, 50020 Novska', p_i_hire =>to_date('01.01.2020', 'DD.MM.YYYY'), p_i_birth =>to_date('30.12.1986', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Programer', p_i_oib =>'10987654321', p_i_gender => 'F', p_i_name => 'Mia', p_i_lastname =>'Peric', p_i_address =>'Prolaz Sjajnih ideja 27, 60040 Vrbovec', p_i_hire =>to_date('16.07.2021', 'DD.MM.YYYY'), p_i_birth =>to_date('11.11.1987', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Cistacica', p_i_oib =>'43210987654', p_i_gender => 'F', p_i_name => 'Matija', p_i_lastname =>'Savic', p_i_address =>'Naselje Zaboravljenih snova 19, 70060 Ðakovo', p_i_hire =>to_date('29.11.2022', 'DD.MM.YYYY'), p_i_birth =>to_date('19.05.1996', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Programer', p_i_oib =>'87654321098', p_i_gender => 'F', p_i_name => 'Ema', p_i_lastname =>'Šimic', p_i_address =>'Kvart Iluzornih planina 32, 80090 Našice', p_i_hire =>to_date('23.07.2023', 'DD.MM.YYYY'), p_i_birth =>to_date('21.03.1992', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Poslovni analiticar', p_i_oib =>'09876543210', p_i_gender => 'M', p_i_name => 'Filip', p_i_lastname =>'Nemet', p_i_address =>'Cesta Nenapisanih prica 21, 90050 Križevci', p_i_hire =>to_date('17.03.2024', 'DD.MM.YYYY'), p_i_birth =>to_date('03.08.1989', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Poslovni analiticar', p_i_oib =>'56789012345', p_i_gender => 'F', p_i_name => 'Sara', p_i_lastname =>'Cvitkovic', p_i_address =>'Ulica Nestvarnih susreta 36, 10020 Ivanec', p_i_hire =>to_date('06.10.2023', 'DD.MM.YYYY'), p_i_birth =>to_date('25.08.1988', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Poslovni analiticar', p_i_oib =>'12345098765', p_i_gender => 'M', p_i_name => 'Antonio', p_i_lastname =>'Mlinaric', p_i_address =>'Trg Izmišljenih prijatelja 13, 20060 Ludbreg', p_i_hire =>to_date('21.03.2022', 'DD.MM.YYYY'), p_i_birth =>to_date('14.06.1990', 'DD.MM.YYYY'));
  p_ins_employees(p_i_job => 'Racunovoda', p_i_oib =>'23456789012', p_i_gender => 'F', p_i_name => 'Helena', p_i_lastname =>'Vidovic', p_i_address =>'Aleja Zabranjenih svjetova 28, 30010 Prelog', p_i_hire =>to_date('01.01.2021', 'DD.MM.YYYY'), p_i_birth =>to_date('29.11.1987', 'DD.MM.YYYY'));

  commit;
exception
  when others
  then
    rollback;
    raise;
end;
/


--PL/SQL insert evp_settlement
declare
  procedure p_ins_settlement (
    p_i_settlement  in wksp_evp.evp_settlement.settlement%type
   ,p_i_postal_code in wksp_evp.evp_settlement.postal_code%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_settlement
     where settlement = p_i_settlement
       and postal_code = p_i_postal_code; 

    if v_id is null
    then
      insert into wksp_evp.evp_settlement (
                    settlement
                   ,postal_code)
           values (
                    p_i_settlement
                   ,p_i_postal_code);
    else
      null;
    end if;
  end;
begin
    
  p_ins_settlement(p_i_settlement =>'Zagreb', p_i_postal_code => '10000');
  p_ins_settlement(p_i_settlement =>'Split', p_i_postal_code => '21000');
  p_ins_settlement(p_i_settlement =>'Rijeka', p_i_postal_code => '51000');
  p_ins_settlement(p_i_settlement =>'Osijek', p_i_postal_code => '31000');
  p_ins_settlement(p_i_settlement =>'Zadar', p_i_postal_code => '23000');
  p_ins_settlement(p_i_settlement =>'Slavonski Brod', p_i_postal_code => '35000');
  p_ins_settlement(p_i_settlement =>'Pula', p_i_postal_code => '52100');
  p_ins_settlement(p_i_settlement =>'Sisak', p_i_postal_code => '44000');
  p_ins_settlement(p_i_settlement =>'Karlovac', p_i_postal_code => '47000');
  p_ins_settlement(p_i_settlement =>'Varaždin', p_i_postal_code => '42000');
  p_ins_settlement(p_i_settlement =>'Šibenik', p_i_postal_code => '22000');
  p_ins_settlement(p_i_settlement =>'Dubrovnik', p_i_postal_code => '20000');
  p_ins_settlement(p_i_settlement =>'Porec', p_i_postal_code => '52440');
  p_ins_settlement(p_i_settlement =>'Rovinj', p_i_postal_code => '52210');
  p_ins_settlement(p_i_settlement =>'Vukovar', p_i_postal_code => '32000');
  p_ins_settlement(p_i_settlement =>'Samobor', p_i_postal_code => '10430');
  p_ins_settlement(p_i_settlement =>'Vinkovci', p_i_postal_code => '32100');
  p_ins_settlement(p_i_settlement =>'Koprivnica', p_i_postal_code => '48000');
  p_ins_settlement(p_i_settlement =>'Požega', p_i_postal_code => '34000');
  p_ins_settlement(p_i_settlement =>'Bjelovar', p_i_postal_code => '43000');
  p_ins_settlement(p_i_settlement =>'Pakrac', p_i_postal_code => '34550');
  p_ins_settlement(p_i_settlement =>'Kutina', p_i_postal_code => '44320');
  p_ins_settlement(p_i_settlement =>'Nova Gradiška', p_i_postal_code => '35400');
  p_ins_settlement(p_i_settlement =>'Ðakovo', p_i_postal_code => '31400');
  p_ins_settlement(p_i_settlement =>'Ivanic Grad', p_i_postal_code => '10310');
  p_ins_settlement(p_i_settlement =>'Opatija', p_i_postal_code => '51410');
  p_ins_settlement(p_i_settlement =>'Virovitica', p_i_postal_code => '33000');
  p_ins_settlement(p_i_settlement =>'Križevci', p_i_postal_code => '48260');
  p_ins_settlement(p_i_settlement =>'Petrinja', p_i_postal_code => '44250');
  p_ins_settlement(p_i_settlement =>'Slatina', p_i_postal_code => '33520');
  p_ins_settlement(p_i_settlement =>'Gospic', p_i_postal_code => '53000');
  p_ins_settlement(p_i_settlement =>'Cakovec', p_i_postal_code => '40000');
  p_ins_settlement(p_i_settlement =>'Vukovar', p_i_postal_code => '32000');
  p_ins_settlement(p_i_settlement =>'Ogulin', p_i_postal_code => '47300');
  p_ins_settlement(p_i_settlement =>'Krapina', p_i_postal_code => '49000');
  p_ins_settlement(p_i_settlement =>'Knin', p_i_postal_code => '22300');
  p_ins_settlement(p_i_settlement =>'Sinj', p_i_postal_code => '21230');
  p_ins_settlement(p_i_settlement =>'Imotski', p_i_postal_code => '21260');
  p_ins_settlement(p_i_settlement =>'Benkovac', p_i_postal_code => '23420');
  p_ins_settlement(p_i_settlement =>'Kutjevo', p_i_postal_code => '34340');
  p_ins_settlement(p_i_settlement =>'Otocac', p_i_postal_code => '53220');
  p_ins_settlement(p_i_settlement =>'Ploce', p_i_postal_code => '20340');
  p_ins_settlement(p_i_settlement =>'Zaprešic', p_i_postal_code => '10290');

  
  commit;
exception
  when others
  then
    rollback;
    raise;
end;
/

--DDL alter evp_employee

alter table wksp_evp.evp_employee
  add job varchar2 (100 char);

comment on column wksp_evp.evp_employee.job is 'Job';

--DDL alter wksp_evp.evp_travelers

alter table wksp_evp.evp_travelers
 drop constraint EVP_TRA_REQ_UN;
 
 /
 
 --DDL alter evp_vehicle_request_status
/* Formatted on 23/5/2024/ 20:49:07 (QP5 v5.391) */
alter table wksp_evp.evp_vehicle_request_status
  add (ind_start char (1 char), ind_end char (1 char));

alter table wksp_evp.evp_vehicle_request_status
  add check (ind_start in ('0', '1'));

alter table wksp_evp.evp_vehicle_request_status
  add check (ind_end in ('0', '1'));

comment on column wksp_evp.evp_vehicle_request_status.ind_start is
  'Starting status indicator';

comment on column wksp_evp.evp_vehicle_request_status.ind_end is
  'Last status indicator';
  
  
/* Formatted on 23/5/2024/ 21:02:07 (QP5 v5.391) */
alter table wksp_evp.evp_vehicle_request_status
  add (color_code varchar2 (50 char));

comment on column wksp_evp.evp_vehicle_request_status.color_code is
  'CSS or other color code or class';
/
--DDL evp_ver_status_translation

CREATE TABLE wksp_evp.evp_ver_status_translation (
    id             NUMBER NOT NULL,
    status_id_from NUMBER NOT NULL,
    status_id_to   NUMBER NOT NULL,
    user_crated    VARCHAR2(50 CHAR) NOT NULL,
    date_crated    DATE NOT NULL,
    user_updated   VARCHAR2(50 CHAR),
    date_updated   DATE
);

COMMENT ON TABLE wksp_evp.evp_ver_status_translation IS
    'Vehicle request status';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.id IS
    'Status translation  ID';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.status_id_from IS
    'FK status id from';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.status_id_to IS
    'FK status id to';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_ver_status_translation.date_updated IS
    'Updated date';

ALTER TABLE wksp_evp.evp_ver_status_translation ADD CONSTRAINT evp_ver_sta_tra_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_ver_status_translation ADD CONSTRAINT evp_ver_status_from_to_un UNIQUE ( status_id_from,
                                                                                                  status_id_to );

ALTER TABLE wksp_evp.evp_ver_status_translation
    ADD CONSTRAINT evp_ver_vst_stat_from_fk FOREIGN KEY ( status_id_from )
        REFERENCES wksp_evp.evp_vehicle_request_status ( id );

ALTER TABLE wksp_evp.evp_ver_status_translation
    ADD CONSTRAINT evp_ver_vst_stat_to_fk FOREIGN KEY ( status_id_to )
        REFERENCES wksp_evp.evp_vehicle_request_status ( id );
        
        
create or replace trigger wksp_evp.evp_trg_vst_biu
  before insert or update
  on wksp_evp.evp_ver_status_translation
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;        

/

--PL/SQL insert evp_vehicle_request_status & evp_ver_status_translation
/* Formatted on 25/5/2024/ 11:20:28 (QP5 v5.391) */
declare
  procedure p_ins_status (
    p_i_refcode      in wksp_evp.evp_vehicle_request_status.ref_code%type
   ,p_i_status_name  in wksp_evp.evp_vehicle_request_status.status_name%type
   ,p_i_desc         in wksp_evp.evp_vehicle_request_status.description%type
   ,p_i_color        in wksp_evp.evp_vehicle_request_status.color_code%type
   ,p_i_start        in wksp_evp.evp_vehicle_request_status.ind_start%type
   ,p_i_end          in wksp_evp.evp_vehicle_request_status.ind_end%type)
  is
    v_id  number;
  begin
    select max (id)
      into v_id
      from wksp_evp.evp_vehicle_request_status
     where ref_code = p_i_refcode;

    if v_id is null
    then
      insert into wksp_evp.evp_vehicle_request_status (
                    ref_code
                   ,status_name
                   ,description
                   ,ind_start
                   ,ind_end
                   ,color_code)
           values (
                    p_i_refcode
                   ,p_i_status_name
                   ,p_i_desc
                   ,p_i_start
                   ,p_i_end
                   ,p_i_color);
    else
      update wksp_evp.evp_vehicle_request_status
         set ref_code = p_i_refcode
            ,status_name = p_i_status_name
            ,description = p_i_desc
            ,ind_start = p_i_start
            ,ind_end = p_i_end
            ,color_code = p_i_color
       where id = v_id;
    end if;
  end;
  procedure p_ins_status_trans (
    p_i_refcode_from    in wksp_evp.evp_vehicle_request_status.ref_code%type
   ,p_i_refcode_to      in wksp_evp.evp_vehicle_request_status.ref_code%type)
  is
    v_id  number;
    v_status_from_id  number;
    v_status_to_id  number;
  begin
  
    select id
      into v_status_from_id
      from wksp_evp.evp_vehicle_request_status
     where ref_code = p_i_refcode_from;
     
    select id
      into v_status_to_id
      from wksp_evp.evp_vehicle_request_status
     where ref_code = p_i_refcode_to;    
    
    select max (id)
      into v_id
      from wksp_evp.evp_ver_status_translation
     where status_id_from = v_status_from_id
       and status_id_to = v_status_to_id;

    if v_id is null
    then
      insert into wksp_evp.evp_ver_status_translation (
                    status_id_from
                   ,status_id_to)
           values (
                    v_status_from_id
                   ,v_status_to_id);
    else
      null;
    end if;
  end;
begin

  p_ins_status (p_i_color => 'apex-cal-blue', p_i_refcode => 'SKICA', p_i_status_name => 'SKICA', p_i_desc => 'Zahtjev je tek snimljen od strane korisnika' , p_i_start => 1 ,p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-yellow', p_i_refcode => 'OTVOREN', p_i_status_name => 'OTVOREN', p_i_desc => 'Korisnik otvara zahtjev za vozilom prema administratoru vozila', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-gray', p_i_refcode => 'PONISTEN', p_i_status_name => 'PONIŠTEN', p_i_desc => 'Korisnik je odustao od zahtjeva', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-green', p_i_refcode => 'REZERVIRAN', p_i_status_name => 'REZERVIRAN', p_i_desc => 'Administrator je odobiro zahtjev za vozilom', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-black', p_i_refcode => 'ODBIJEN', p_i_status_name => 'ODBIJEN', p_i_desc => 'Administrator je odbio zahtjev', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-orange', p_i_refcode => 'U_DORADI', p_i_status_name => 'U DORADI', p_i_desc => 'Zahtjev treba doradu te ga administratir vraca korisniku', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-gray', p_i_refcode => 'STORNO', p_i_status_name => 'STORNO', p_i_desc => 'Administrator je stornirao zahtjev', p_i_start => 0, p_i_end => 0);
  p_ins_status (p_i_color => 'apex-cal-gray', p_i_refcode => 'NEAKTIVAN', p_i_status_name => 'NEAKTIVAN', p_i_desc => 'Sustav prebaciju ne realizirane zatjeve u ovaj status', p_i_start => 0, p_i_end => 1);
  
  p_ins_status_trans (p_i_refcode_from => 'SKICA', p_i_refcode_to => 'OTVOREN');
  p_ins_status_trans (p_i_refcode_from => 'OTVOREN', p_i_refcode_to => 'REZERVIRAN');
  p_ins_status_trans (p_i_refcode_from => 'OTVOREN', p_i_refcode_to => 'ODBIJEN');
  p_ins_status_trans (p_i_refcode_from => 'OTVOREN', p_i_refcode_to => 'PONISTEN');
  p_ins_status_trans (p_i_refcode_from => 'OTVOREN', p_i_refcode_to => 'U_DORADI');
  p_ins_status_trans (p_i_refcode_from => 'OTVOREN', p_i_refcode_to => 'NEAKTIVAN');
  p_ins_status_trans (p_i_refcode_from => 'REZERVIRAN', p_i_refcode_to => 'STORNO');
  p_ins_status_trans (p_i_refcode_from => 'U_DORADI', p_i_refcode_to => 'OTVOREN');
  p_ins_status_trans (p_i_refcode_from => 'U_DORADI', p_i_refcode_to => 'NEAKTIVAN');
  
  commit;
exception
  when others
  then
    rollback;
    raise;
end;

/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
      ,start_date      => TO_TIMESTAMP_TZ('2024/05/29 18:46:47.930682 UTC','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=HOURLY;INTERVAL=1;BYMINUTE=0;BYSECOND=0'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin
  wksp_evp.evp_vehicle_request_pkg.p_deactive_requests;
  commit;
exception
  when others
  then
    rollback;
    raise;
end;'
      ,comments        => 'Job deactives vehicle requests that are inactive and 24 hours from travel start date has passed.'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB'
     ,attribute => 'STORE_OUTPUT'
     ,value     => TRUE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'WKSP_EVP.DEACTIVE_REQUESTS_JOB');
END;
/

-- DDL wksp_evp.evp_technical_inspection
alter table wksp_evp.evp_technical_inspection
  add DATE_OF_INSPECTION date not null;

comment on column wksp_evp.evp_technical_inspection.date_of_inspection is
  'Date of vehicle technical inspection';
  
/

-- DDL  
CREATE TABLE wksp_evp.evp_vehicle_insurance (
    id             NUMBER NOT NULL,
    valid_from     DATE NOT NULL,
    valid_to       DATE NOT NULL,
    vehicle_id     NUMBER NOT NULL,
    insurance_date DATE NOT NULL,
    user_crated    VARCHAR2(50 CHAR) NOT NULL,
    date_crated    DATE NOT NULL,
    user_updated   VARCHAR2(50 CHAR),
    date_updated   DATE
);

COMMENT ON TABLE wksp_evp.evp_vehicle_insurance IS
    'Vehicle registration';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.id IS
    'Vehicle insurance ID';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.valid_from IS
    'Insurance valid from';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.valid_to IS
    'Insurance valid to';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.vehicle_id IS
    'Vehicle FK';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.insurance_date IS
    'Insurance date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.user_crated IS
    'App user created';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.date_crated IS
    'Created date';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.user_updated IS
    'App user updated';

COMMENT ON COLUMN wksp_evp.evp_vehicle_insurance.date_updated IS
    'Updated date';

CREATE INDEX wksp_evp.evp_vei_vehicle_id_idx ON
    wksp_evp.evp_vehicle_insurance (
        vehicle_id
    ASC );

ALTER TABLE wksp_evp.evp_vehicle_insurance ADD CONSTRAINT evp_vehicle_insurance_pk PRIMARY KEY ( id );

ALTER TABLE wksp_evp.evp_vehicle_insurance
    ADD CONSTRAINT evp_vei_evp_vehicle_fk FOREIGN KEY ( vehicle_id )
        REFERENCES wksp_evp.evp_vehicle ( id );
        
create or replace trigger wksp_evp.evp_trg_vei_biu
  before insert or update
  on wksp_evp.evp_vehicle_insurance
  referencing new as new old as old
  for each row
declare
  v_err            varchar2 (1000);
  v_radnja_oznaka  varchar2 (10);
  v_mode           varchar2 (1);
  greska           exception;
begin
  if inserting
  then
    v_mode := 'I';
  elsif updating
  then
    v_mode := 'U';
  else
    v_mode := 'D';
  end if;


  if inserting
  then
    /* insert */
    v_radnja_oznaka := 'INS';

    if :new.id is null
    then
      :new.id := wksp_evp.evp_seq.nextval ();
    end if;
    
    :new.user_crated := nvl (v ('APP_USER'), user);
    :new.date_crated := sysdate;
  elsif updating
  then
    /* update */
    v_radnja_oznaka := 'UPD';
    
    :new.user_updated := nvl (v ('APP_USER'), user);
    :new.date_updated := sysdate;
  else
    /* delete */
    v_radnja_oznaka := 'DEL';
  end if;

  if v_err is not null
  then
    raise greska;
  end if;
exception
  when others
  then
    raise_application_error (-20001, sqlerrm);
end;       

/

--JOB WKSP_EVP.SEND_SYS_NOTIFICATIONS
BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
      ,start_date      => TO_TIMESTAMP_TZ('2024/06/17 20:47:52.463757 UTC','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;BYHOUR=7'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'begin
  wksp_evp.evp_notification_pkg.p_send_system_notifications;
  commit;
exception
  when others
  then
    rollback;
    raise;
end;'
      ,comments        => 'Sent notifications important to vehicle administrator'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'RESTARTABLE'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS'
     ,attribute => 'STORE_OUTPUT'
     ,value     => TRUE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'WKSP_EVP.SEND_SYS_NOTIFICATIONS');
END;
/
