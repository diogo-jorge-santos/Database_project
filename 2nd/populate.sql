

DELETE FROM trip cascade;
DELETE FROM res cascade;

DELETE FROM schdl cascade;
DELETE FROM boatVHF cascade;
DELETE FROM boat cascade;

DELETE FROM ownr cascade;
DELETE FROM sailor cascade;
DELETE FROM person cascade;



DELETE FROM marina cascade;
DELETE FROM warf cascade;
DELETE FROM port cascade;
DELETE FROM loc cascade;

DELETE FROM country cascade;



----------------------------------------
-- Populate Relations
----------------------------------------


-- Populate country:     
--    country_iso      VARCHAR(80) 
--    country_name     VARCHAR(80) UNIQUE
--    country_flag     VARCHAR(80) NOT NULL


-- the rules for part2 do not allow add extra files, so we'll be using some random bytea type to simulate the binary string of an png of a specific flag.
INSERT INTO country VALUES ('PRT', 'Portugal', '1'::bytea);
INSERT INTO country VALUES ('ZAF', 'South Africa', '2'::bytea);
INSERT INTO country VALUES ('ZWE', 'Zimbabwe', '3'::bytea);

-- Populate person
--    person_id      INTEGER NOT NULL, 
--    person_name    VARCHAR(80) NOT NULL,  
--    person_country    VARCHAR(80) NOT NULL,

INSERT INTO person VALUES (1, 'Tomas Miguel',  'PRT');
INSERT INTO person VALUES (2,'Joao Rendeiro' , 'PRT');
INSERT INTO person VALUES (3,'Maria Rendeiro' , 'PRT');
INSERT INTO person VALUES (1, 'Tomas Miguel',  'ZWE');
INSERT INTO person VALUES (2,'Joao Rendeiro' , 'ZWE');
INSERT INTO person VALUES (1,'Joana Miguel' , 'ZAF');
INSERT INTO person VALUES (2,'Tomas Rendeiro', 'ZAF');


-- Populate ownr
--    ownr_birhtdate      DATE
--    ownr_country    VARCHAR(80) NOT NULL,
--    ownr_id      INTEGER NOT NULL	

INSERT INTO ownr VALUES ('1990-03-02',  'PRT', 1);
INSERT INTO ownr VALUES ('1990-04-02',  'PRT', 2);
INSERT INTO ownr VALUES ('1990-07-02',  'PRT', 3);
INSERT INTO ownr VALUES ('1990-03-02',  'ZWE', 1);
INSERT INTO ownr VALUES ('1952-05-22',  'ZAF', 2);



-- Populate sailor
--    sailor_country    VARCHAR(80) NOT NULL,
--    sailor_id      INTEGER NOT NULL,

INSERT INTO sailor VALUES ('PRT', 1);
INSERT INTO sailor VALUES ('PRT', 2);
INSERT INTO sailor VALUES ('PRT', 3);
INSERT INTO sailor VALUES ('ZWE', 2);
INSERT INTO sailor VALUES ('ZAF', 1);


-- Populate boat
--    boat_cni     INTEGER NOT NULL, 
--    boat_name    VARCHAR(80) NOT NULL,  
--    boat_lenght INTEGER NOT NULL,? 
--    boat_year INTEGER NOT NULL, 
--    boat_country    VARCHAR(80) NOT NULL,	    
--    boat_ownr_id     INTEGER NOT NULL, 
--    boat_ownr_country     INTEGER NOT NULL, 

INSERT INTO boat VALUES (1, 'Tomas Miguel boat', 123, 1990, 'PRT', 1, 'PRT');
INSERT INTO boat VALUES (1, 'Tomas Miguel boat', 431, 1990, 'ZAF', 1, 'PRT');
INSERT INTO boat VALUES (1, 'Tomas Miguel boat', 378, 1990, 'ZWE', 1, 'PRT');
INSERT INTO boat VALUES (2, 'Joao Rendeiro boat', 12, 1990, 'PRT', 2, 'PRT');
INSERT INTO boat VALUES (2, 'boat', 1, 1990, 'ZAF', 2, 'ZAF');
INSERT INTO boat VALUES (3, 'boat', 177, 1990, 'PRT', 1, 'ZWE');



-- Populate boatVHF
--    mmsi INTEGER NOT NULL
--    boatVHF_country  VARCHAR(80) NOT NULL,
--    boatVHF_cni      INTEGER NOT NULL, 

INSERT INTO boatVHF VALUES (123456, 'PRT', 1);

-- Populate schdl
--    schdl_start DATE --! rever tipo
--    schdl_end DATE

INSERT INTO schdl VALUES ('1990-03-02', '2000-03-02');
INSERT INTO schdl VALUES ('1990-03-02', '1990-03-04');
INSERT INTO schdl VALUES ('2021-01-01', '2021-12-11');
INSERT INTO schdl VALUES ('2021-01-01', '2021-01-02');

-- Populate res
--    res_boat_country    VARCHAR(80) NOT NULL,
--    res_boat_cni     INTEGER NOT NULL, 
--    res_sailor_country    VARCHAR(80) NOT NULL,
--    res_sailor_id     INTEGER NOT NULL, 
--    res_schdl_start DATE
--    res_schdl_end DATE

INSERT INTO res VALUES ('PRT', 1, 'PRT', 1, '1990-03-02', '2000-03-02');
INSERT INTO res VALUES ('PRT', 1, 'ZAF', 1, '1990-03-02', '1990-03-04');
INSERT INTO res VALUES ('PRT', 2, 'ZAF', 1, '2021-01-01', '2021-12-11');
INSERT INTO res VALUES ('ZAF', 2, 'ZWE', 2, '2021-01-01', '2021-01-02');
INSERT INTO res VALUES ('ZAF', 2, 'ZWE', 2, '1990-03-02', '2000-03-02');

-- Populate loc
--    loc_lat      INTEGER NOT NULL,
--    loc_long     INTEGER NOT NULL, 
--    loc_name VARCHAR(80) NOT NULL,
--    loc_country    VARCHAR(80) NOT NULL

INSERT INTO loc VALUES (20.56, 20.32, 'Port', 'PRT');
INSERT INTO loc VALUES (1, 1, 'Port', 'ZAF');
INSERT INTO loc VALUES (80, 80, 'warf', 'ZAF');
INSERT INTO loc VALUES (90, 120, 'marina', 'ZWE');

-- Populate port
--    port_lat      INTEGER NOT NULL, 
--    port_long      INTEGER NOT NULL, 

INSERT INTO port VALUES (20.56, 20.32);
INSERT INTO port VALUES (1, 1);

INSERT INTO warf VALUES(80,80);

INSERT INTO marina VALUES(90,120);

-- Populate trip
--    trip_date      DATE NOT NULL, 
--    trip_duration    INTEGER NOT NULL, 
--    trip_boat_country    VARCHAR(80) NOT NULL,
--    trip_boat_cni     INTEGER NOT NULL, 
--    trip_sailor_country    VARCHAR(80) NOT NULL,
--    trip_sailor_id     INTEGER NOT NULL, 
--    trip_res_start DATE
--    trip_res_end DATE
--    trip_start_loc_long      INTEGER NOT NULL, 
--    trip_start_loc_lat     INTEGER NOT NULL, 
--    trip_end_loc_long      INTEGER NOT NULL, 
--    trip_end_loc_lat     INTEGER NOT NULL, 

INSERT INTO trip VALUES ('1990-04-02', '23 days', 'PRT', 1, 'PRT', 1, '1990-03-02', '2000-03-02', 80, 80, 80, 80);
