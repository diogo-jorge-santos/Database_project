DROP TABLE IF EXISTS country cascade;
DROP TABLE IF EXISTS person cascade;
DROP TABLE IF EXISTS ownr cascade;
DROP TABLE IF EXISTS sailor cascade;
DROP TABLE IF EXISTS boat cascade;
DROP TABLE IF EXISTS boatVHF cascade;
DROP TABLE IF EXISTS schdl cascade;
DROP TABLE IF EXISTS res cascade;
DROP TABLE IF EXISTS loc cascade;
DROP TABLE IF EXISTS marina cascade;
DROP TABLE IF EXISTS warf cascade;
DROP TABLE IF EXISTS port cascade;
DROP TABLE IF EXISTS trip cascade;

-- '--'  -> coments 
-- '---' -> IC's
-- '----' -> restrictions to be implemented with code

-- '!'   -> rever

----------------------------------------
-- Table Creation
----------------------------------------

-- Named constraints are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of primary key constraints
--   2. fk_table_another for names of foreign key constraints

--1
CREATE TABLE country (
    country_iso      CHAR(3) ,
    --(slides' recommendation)
    country_name     VARCHAR(70) NOT NULL,
    --(slides' recommendation)
    UNIQUE(country_name), --- IC-5
    
    country_flag   bytea NOT NULL,
    UNIQUE(country_flag), --- IC-4

    CONSTRAINT pk_country PRIMARY KEY (country_iso)
);

--2
CREATE TABLE person (
    person_id      INTEGER ,
    --!matching integers is faster than strings, although the slides recommend varchar for ids
    person_name    VARCHAR(80) NOT NULL,  
    -- weak entity of country
    person_country  CHAR(3) ,
    FOREIGN	KEY(person_country) REFERENCES country(country_iso),

    CONSTRAINT pk_person PRIMARY KEY (person_country, person_id)

    ---- Every person must exist either in the table 'sailor' or	in the table 'ownr'

);

--3
CREATE TABLE ownr (
    ownr_birhtdate      DATE NOT NULL,

    -- specialization of person
    ownr_country    CHAR(3) ,
    ownr_id      INTEGER ,
    FOREIGN	KEY(ownr_country, ownr_id) REFERENCES person(person_country, person_id),

    CONSTRAINT pk_ownr PRIMARY KEY (ownr_country, ownr_id)

);

--4
CREATE TABLE sailor (
    -- specialization of person
    sailor_country    CHAR(3) ,
    sailor_id      INTEGER ,
    FOREIGN	KEY(sailor_country, sailor_id) REFERENCES person(person_country, person_id),	

    CONSTRAINT pk_sailor PRIMARY KEY (sailor_country, sailor_id)
);

--5
CREATE TABLE boat (
    boat_cni     INTEGER ,
    boat_name    VARCHAR(80) NOT NULL,  
    boat_lenght INTEGER NOT NULL, 
    boat_year INTEGER NOT NULL, 

    -- weak entity of country
    boat_country    CHAR(3) ,
    FOREIGN	KEY(boat_country) REFERENCES country(country_iso),	    

    CONSTRAINT pk_boat PRIMARY KEY (boat_country, boat_cni),

    -- simulates 'weak entity' to ownr
    boat_ownr_id     INTEGER NOT NULL, 
    boat_ownr_country     CHAR(3) NOT NULL, 
    FOREIGN	KEY(boat_ownr_id, boat_ownr_country) REFERENCES ownr(ownr_id, ownr_country)	
);

--6
CREATE TABLE boatVHF (
    mmsi INTEGER NOT NULL,

    -- specialization of boat (weak of country)
    boatVHF_country  CHAR(3) ,
    boatVHF_cni      INTEGER ,
    FOREIGN	KEY(boatVHF_country, boatVHF_cni) REFERENCES boat(boat_country, boat_cni),	

    CONSTRAINT pk_boatVHF PRIMARY KEY (boatVHF_country, boatVHF_cni)
);

--7
CREATE TABLE schdl (
    schdl_start DATE ,
    schdl_end DATE ,

    CONSTRAINT pk_schdl PRIMARY KEY (schdl_start, schdl_end),

    ---- every schdl must exit in the table 'res'
    ---! IC-1 reservation schedules of a boat must not overlap
    
    CHECK (schdl_end>schdl_start) --- IC-6
);

--8
CREATE TABLE res (
    -- boat weak of country
    res_boat_country    CHAR(3) ,
    res_boat_cni     INTEGER ,
    FOREIGN	KEY(res_boat_country, res_boat_cni) REFERENCES boat(boat_country, boat_cni),	    

    -- sailor weak of country
    res_sailor_country    CHAR(3) ,
    res_sailor_id     INTEGER ,
    FOREIGN	KEY(res_sailor_country, res_sailor_id) REFERENCES sailor(sailor_country, sailor_id),

    -- schedule
    res_schdl_start DATE ,
    res_schdl_end DATE ,
    FOREIGN	KEY(res_schdl_start, res_schdl_end) REFERENCES schdl(schdl_start, schdl_end),	  

    CONSTRAINT pk_res PRIMARY KEY (res_boat_cni, res_boat_country, res_sailor_id, res_sailor_country, res_schdl_start, res_schdl_end)

    ---! IC-1 reservation schedules of a boat must not overlap
    ---! IC-2 Trips of a reservation must not overlap.
);

--9
CREATE TABLE loc (
    loc_lat      NUMERIC(8,6) ,
    loc_long     NUMERIC(9,6) ,
    loc_name VARCHAR(80) NOT NULL,

    CONSTRAINT pk_loc PRIMARY KEY (loc_lat, loc_long),

    -- simulating weak entity of country
    loc_country    CHAR(3) NOT NULL,
    FOREIGN	KEY(loc_country) REFERENCES	country(country_iso)

    ---- every location must exist either in the table 'marina', 'port' or 'warf'
    ---! (IC-3) Any two locations must be at least 1-mile distance apart
);

--10
CREATE TABLE marina (
    -- specialization of loc
    marina_lat      NUMERIC(8,6) ,
    marina_long      NUMERIC(9,6) ,
    FOREIGN	KEY(marina_lat, marina_long) REFERENCES loc(loc_lat, loc_long),

    CONSTRAINT pk_marina PRIMARY KEY (marina_lat, marina_long)
);

--11
CREATE TABLE warf (
    -- specialization of loc
    warf_lat      NUMERIC(8,6) ,
    warf_long      NUMERIC(9,6) ,
    FOREIGN	KEY(warf_lat, warf_long) REFERENCES loc(loc_lat, loc_long),	

    CONSTRAINT pk_warf PRIMARY KEY (warf_lat, warf_long)
);

--12
CREATE TABLE port (
    -- specialization of loc
    port_lat      NUMERIC(8,6) ,
    port_long      NUMERIC(9,6) ,
    FOREIGN	KEY(port_lat, port_long) REFERENCES loc(loc_lat, loc_long),	

    CONSTRAINT pk_port PRIMARY KEY (port_lat, port_long)
);

--13
CREATE TABLE trip (
    trip_date      DATE NOT NULL ,
    trip_duration    INTERVAL NOT NULL,

    -- weak entity of res
    trip_boat_country    CHAR(3),
    trip_boat_cni     INTEGER ,
    trip_sailor_country    CHAR(3) ,
    trip_sailor_id     INTEGER ,
    trip_res_start DATE ,
    trip_res_end DATE ,
    FOREIGN	KEY(trip_boat_cni, trip_boat_country, trip_sailor_id, trip_sailor_country, trip_res_start, trip_res_end) REFERENCES res(res_boat_cni, res_boat_country, res_sailor_id, res_sailor_country, res_schdl_start, res_schdl_end),

    CONSTRAINT pk_trip PRIMARY KEY (trip_date, trip_boat_cni, trip_boat_country, trip_sailor_id, trip_sailor_country, trip_res_start, trip_res_end),
    
    -- simulates 'weak entity' to start loc
    trip_start_loc_long      NUMERIC(9,6) NOT NULL, 
    trip_start_loc_lat     NUMERIC(8,6) NOT NULL, 
    FOREIGN	KEY(trip_start_loc_long, trip_start_loc_lat) REFERENCES loc(loc_long, loc_lat),

    -- simulates 'weak entity' to end loc
    trip_end_loc_long      NUMERIC(9,6) NOT NULL, 
    trip_end_loc_lat     NUMERIC(8,6) NOT NULL, 
    FOREIGN	KEY(trip_end_loc_long, trip_end_loc_lat) REFERENCES loc(loc_long, loc_lat),

    CHECK (trip_duration > INTERVAL'0.0 seconds')

);

