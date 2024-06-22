CREATE TABLE dokument (
    sifra_dokumenta    NUMBER NOT NULL,
    opis               VARCHAR2(50 CHAR) NOT NULL,
    tip_datoteke       VARCHAR2(50 CHAR) NOT NULL,
    ekstenzija         VARCHAR2(5 CHAR) NOT NULL,
    glavna_fotografija CHAR(1 CHAR),
    naziv              VARCHAR2(50 CHAR) NOT NULL,
    broj_sasije        VARCHAR2(17 CHAR) NOT NULL
);

ALTER TABLE dokument ADD CONSTRAINT dokument_pk PRIMARY KEY ( sifra_dokumenta );

CREATE TABLE evidencija_predenih_kilometara (
    evidencija_id     NUMBER NOT NULL,
    broj_sasije       VARCHAR2(17 CHAR) NOT NULL,
    datum_evidencije  DATE NOT NULL,
    stanje_kilometara NUMBER NOT NULL
);


ALTER TABLE evidencija_predenih_kilometara ADD CONSTRAINT evidencija_predenih_kilometara_pk PRIMARY KEY ( evidencija_id );

CREATE TABLE gorivo (
    sifra_goriva NUMBER NOT NULL,
    naziv        VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE gorivo ADD CONSTRAINT gorivo_pk PRIMARY KEY ( sifra_goriva );

CREATE TABLE kategorija_vozila (
    sifra_kategorije NUMBER NOT NULL,
    opis             VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE kategorija_vozila ADD CONSTRAINT kategorija_vozila_pk PRIMARY KEY ( sifra_kategorije );

CREATE TABLE korisnik_aplikacije (
    korisnicko_ime VARCHAR2(100 CHAR) NOT NULL,
    oib            VARCHAR2(11 CHAR) NOT NULL
);

ALTER TABLE korisnik_aplikacije ADD CONSTRAINT korisnik_aplikacije_pk PRIMARY KEY ( korisnicko_ime );

CREATE TABLE mjesto (
    sifra_mjesta   NUMBER NOT NULL,
    naziv          VARCHAR2(100 CHAR) NOT NULL,
    postanski_broj NUMBER NOT NULL
);

ALTER TABLE mjesto ADD CONSTRAINT mjesto_pk PRIMARY KEY ( sifra_mjesta );

CREATE TABLE model (
    sifra_modela      NUMBER NOT NULL,
    naziv             VARCHAR2(50 CHAR) NOT NULL,
    sifra_proizvodaca NUMBER NOT NULL
);

ALTER TABLE model ADD CONSTRAINT model_pk PRIMARY KEY ( sifra_modela );

CREATE TABLE notifikacija (
    notifikacija_id             NUMBER NOT NULL,
    opis                        VARCHAR2(200 CHAR) NOT NULL,
    datum_slanja                DATE NOT NULL,
    korisnicko_ime_posiljatelja VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE notifikacija ADD CONSTRAINT notifikacija_pk PRIMARY KEY ( notifikacija_id );

CREATE TABLE notifikacija_primatelj (
    notifikacija_id           NUMBER NOT NULL,
    korisnicko_ime_primatelja VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE notifikacija_primatelj ADD CONSTRAINT notifikacija_primatelj_pk PRIMARY KEY ( notifikacija_id,
                                                                                          korisnicko_ime_primatelja );

CREATE TABLE oblik_karoserije (
    sifra_oblika NUMBER NOT NULL,
    opis         VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE oblik_karoserije ADD CONSTRAINT oblik_karoserije_pk PRIMARY KEY ( sifra_oblika );

CREATE TABLE osiguranje_vozila (
    broj_sasije          VARCHAR2(17) NOT NULL,
    sifra_osiguravatelja NUMBER NOT NULL,
    datum_osiguranja     DATE NOT NULL,
    vrijedi_od           DATE NOT NULL,
    vrijedi_do           DATE NOT NULL
);

ALTER TABLE osiguranje_vozila
    ADD CONSTRAINT tenicki_pregled_vozilav1_pk PRIMARY KEY ( sifra_osiguravatelja,
                                                             datum_osiguranja,
                                                             broj_sasije );

CREATE TABLE osiguravajuca_kuca (
    sifra_osiguravatelja NUMBER NOT NULL,
    naziv_kuce           VARCHAR2 (50 char)


);

ALTER TABLE osiguravajuca_kuca ADD CONSTRAINT osiguravajuca_kuca_pk PRIMARY KEY ( sifra_osiguravatelja );

CREATE TABLE potrosnja_goriva (
    potrosnja_id      NUMBER NOT NULL,
    broj_sasije       VARCHAR2(17 CHAR) NOT NULL,
    sifra_goriva      NUMBER NOT NULL,
    datum_tocenja     DATE NOT NULL,
    natocena_kolicina NUMBER NOT NULL
);

ALTER TABLE potrosnja_goriva ADD CONSTRAINT potrosnja_goriva_pk PRIMARY KEY ( potrosnja_id );

CREATE TABLE proizvodac (
    sifra_proizvodaca NUMBER NOT NULL,
    naziv             VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE proizvodac ADD CONSTRAINT proizvodac_pk PRIMARY KEY ( sifra_proizvodaca );

CREATE TABLE putnik (
    putnik_id      NUMBER NOT NULL,
    vozac          CHAR(1 CHAR),
    sifra_zahtjeva NUMBER NOT NULL,
    oib            VARCHAR2(11 CHAR) NOT NULL
);

ALTER TABLE putnik ADD CONSTRAINT putnik_pk PRIMARY KEY ( putnik_id );

CREATE TABLE stanica_za_tehnicki_pregled (
    sifra_stanice NUMBER NOT NULL
);

ALTER TABLE stanica_za_tehnicki_pregled ADD CONSTRAINT stanica_za_tehnicki_pregled_pk PRIMARY KEY ( sifra_stanice );

CREATE TABLE status (
    sifra_statusa NUMBER NOT NULL,
    naziv         VARCHAR2(50 CHAR) NOT NULL,
    opis          VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE status ADD CONSTRAINT status_pk PRIMARY KEY ( sifra_statusa );

CREATE TABLE status_zahtjeva (
    sifra_statusa                      NUMBER NOT NULL,
    sifra_zahtjeva                     NUMBER NOT NULL, 
    datum_vrijeme_postavljanja_statusa DATE NOT NULL
);

ALTER TABLE status_zahtjeva
    ADD CONSTRAINT status_zahtjeva_pk PRIMARY KEY ( sifra_statusa,
                                                    sifra_zahtjeva,
                                                    datum_vrijeme_postavljanja_statusa );

CREATE TABLE tenicki_pregled_vozila (
    broj_sasije    VARCHAR2(17) NOT NULL,
    sifra_stanice  NUMBER NOT NULL,
    datum_pregleda DATE NOT NULL,
    vrijedi_od     DATE NOT NULL,
    vrijedi_do     DATE NOT NULL
);

ALTER TABLE tenicki_pregled_vozila
    ADD CONSTRAINT tenicki_pregled_vozila_pk PRIMARY KEY ( sifra_stanice,
                                                           datum_pregleda,
                                                           broj_sasije );

CREATE TABLE vozilo (
    broj_sasije             VARCHAR2(17 CHAR) NOT NULL,
    boja                    VARCHAR2(50 CHAR) NOT NULL,
    snaga                   NUMBER NOT NULL,
    euro_norma              NUMBER,
    godina_proizvodnje      DATE NOT NULL,
    jom                     VARCHAR2(50 CHAR) NOT NULL,
    datum_prve_registracije DATE NOT NULL,
    broj_sjedala            NUMBER NOT NULL,
    registarska_oznaka      VARCHAR2(20 CHAR) NOT NULL,
    broj_vrata              NUMBER,
    zapremnina_motora       NUMBER NOT NULL,
    co2_emisija             NUMBER NOT NULL,
    vrsta_goriva            VARCHAR2(50 CHAR) NOT NULL,
    broj_osovina            NUMBER NOT NULL,
    broj_pogonskih_osovina  NUMBER NOT NULL,
    sifra_oblika_karoserije NUMBER NOT NULL,
    sifra_kategorije        NUMBER NOT NULL,
    sifra_modela            NUMBER NOT NULL
);

ALTER TABLE vozilo ADD CONSTRAINT vozilo_pk PRIMARY KEY ( broj_sasije );

CREATE TABLE zahtjev_za_putovanje (
    sifra_zahtjeva              NUMBER NOT NULL,
    datum_pocetka_puta          DATE NOT NULL,
    datum_zavrsetka_puta        DATE NOT NULL,
    sifra_mjesta_pocetka_puta   NUMBER NOT NULL,
    sifra_mjesta_zavrsetka_puta NUMBER NOT NULL,
    broj_sasije                 VARCHAR2(17 CHAR) NOT NULL
);

ALTER TABLE zahtjev_za_putovanje ADD CONSTRAINT zahtjev_za_putovanje_pk PRIMARY KEY ( sifra_zahtjeva );

CREATE TABLE zaposlenik (
    oib           VARCHAR2(11 CHAR) NOT NULL,
    spol          CHAR(1 CHAR) NOT NULL,
    datum_rodenja DATE NOT NULL,
    ime           VARCHAR2(50 CHAR) NOT NULL,
    prezime       VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE zaposlenik ADD CONSTRAINT zaposlenik_pk PRIMARY KEY ( oib );

ALTER TABLE dokument
    ADD CONSTRAINT dokument_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );

ALTER TABLE evidencija_predenih_kilometara
    ADD CONSTRAINT evidencija_predenih_kilometara_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );

ALTER TABLE korisnik_aplikacije
    ADD CONSTRAINT korisnik_aplikacije_zaposlenik_fk FOREIGN KEY ( oib )
        REFERENCES zaposlenik ( oib );

ALTER TABLE model
    ADD CONSTRAINT model_proizvodac_fk FOREIGN KEY ( sifra_proizvodaca )
        REFERENCES proizvodac ( sifra_proizvodaca );

ALTER TABLE notifikacija
    ADD CONSTRAINT notifikacija_korisnik_aplikacije_fk FOREIGN KEY ( korisnicko_ime_posiljatelja )
        REFERENCES korisnik_aplikacije ( korisnicko_ime );

ALTER TABLE notifikacija_primatelj
    ADD CONSTRAINT notifikacija_primatelj_korisnik_aplikacije_fk FOREIGN KEY ( korisnicko_ime_primatelja )
        REFERENCES korisnik_aplikacije ( korisnicko_ime );

ALTER TABLE notifikacija_primatelj
    ADD CONSTRAINT notifikacija_primatelj_notifikacija_fk FOREIGN KEY ( notifikacija_id )
        REFERENCES notifikacija ( notifikacija_id );

ALTER TABLE osiguranje_vozila
    ADD CONSTRAINT osiguranje_vozila_osiguravajuca_kuca_fk FOREIGN KEY ( sifra_osiguravatelja )
        REFERENCES osiguravajuca_kuca ( sifra_osiguravatelja );

ALTER TABLE osiguranje_vozila
    ADD CONSTRAINT osiguranje_vozila_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );

ALTER TABLE potrosnja_goriva
    ADD CONSTRAINT potrosnja_goriva_gorivo_fk FOREIGN KEY ( sifra_goriva )
        REFERENCES gorivo ( sifra_goriva );

ALTER TABLE potrosnja_goriva
    ADD CONSTRAINT potrosnja_goriva_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );

ALTER TABLE putnik
    ADD CONSTRAINT putnik_zahtjev_za_putovanje_fk FOREIGN KEY ( sifra_zahtjeva )
        REFERENCES zahtjev_za_putovanje ( sifra_zahtjeva );

ALTER TABLE putnik
    ADD CONSTRAINT putnik_zaposlenik_fk FOREIGN KEY ( oib )
        REFERENCES zaposlenik ( oib );

ALTER TABLE status_zahtjeva
    ADD CONSTRAINT status_zahtjeva_status_fk FOREIGN KEY ( sifra_statusa )
        REFERENCES status ( sifra_statusa );

ALTER TABLE status_zahtjeva
    ADD CONSTRAINT status_zahtjeva_zahtjev_za_putovanje_fk FOREIGN KEY ( sifra_zahtjeva )
        REFERENCES zahtjev_za_putovanje ( sifra_zahtjeva );

ALTER TABLE tenicki_pregled_vozila
    ADD CONSTRAINT tenicki_pregled_vozila_stanica_za_tehnicki_pregled_fk FOREIGN KEY ( sifra_stanice )
        REFERENCES stanica_za_tehnicki_pregled ( sifra_stanice );

ALTER TABLE tenicki_pregled_vozila
    ADD CONSTRAINT tenicki_pregled_vozila_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );

ALTER TABLE vozilo
    ADD CONSTRAINT vozilo_kategorija_vozila_fk FOREIGN KEY ( sifra_kategorije )
        REFERENCES kategorija_vozila ( sifra_kategorije );

ALTER TABLE vozilo
    ADD CONSTRAINT vozilo_model_fk FOREIGN KEY ( sifra_modela )
        REFERENCES model ( sifra_modela );

ALTER TABLE vozilo
    ADD CONSTRAINT vozilo_oblik_karoserije_fk FOREIGN KEY ( sifra_oblika_karoserije )
        REFERENCES oblik_karoserije ( sifra_oblika );

ALTER TABLE zahtjev_za_putovanje
    ADD CONSTRAINT zahtjev_za_putovanje_mjesto_pocetak_fk FOREIGN KEY ( sifra_mjesta_pocetka_puta )
        REFERENCES mjesto ( sifra_mjesta );

ALTER TABLE zahtjev_za_putovanje
    ADD CONSTRAINT zahtjev_za_putovanje_mjesto_zavrsetak_fk FOREIGN KEY ( sifra_mjesta_zavrsetka_puta )
        REFERENCES mjesto ( sifra_mjesta );

ALTER TABLE zahtjev_za_putovanje
    ADD CONSTRAINT zahtjev_za_putovanje_vozilo_fk FOREIGN KEY ( broj_sasije )
        REFERENCES vozilo ( broj_sasije );