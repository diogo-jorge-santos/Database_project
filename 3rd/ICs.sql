SET search_path TO 'Project_3';


DROP TRIGGER IF EXISTS check_res on reservation;
DROP TRIGGER IF EXISTS check_spec_port on port;
DROP TRIGGER IF EXISTS check_spec_wharf on wharf;
DROP TRIGGER IF EXISTS check_spec_marina on marina;
DROP TRIGGER IF EXISTS check_spec_trip on trip;
DROP TRIGGER IF EXISTS check_country_boat on boat;


--1
CREATE OR REPLACE FUNCTION check_res_func()
    RETURNS TRIGGER AS

$$
BEGIN

    If EXISTS (Select *
              From reservation r
              where r.cni = new.cni
                  and (( r.start_date>=new.start_date and r.start_date<=new.end_date)
                 or ( r.start_date<=new.start_date and r.end_date>=new.start_date)))

    THEN
        RAISE EXCEPTION 'Overlapping reserve';
    end if;
    return new;
end;
$$ language plpgsql;
--if( (start1 > start2 && start1 < end2) || (start2 > start1 && start2 < end1)  1 start 2 new)
        --(start1 <start2 && end1 > start2)

CREATE TRIGGER check_res
    BEFORE INSERT OR UPDATE
    ON reservation
    FOR EACH ROW
EXECUTE PROCEDURE check_res_func();




/*
ORIGINAL
INSERT INTO reservation
VALUES (1,'PT', 1,'PT', '1990-03-02', '2000-03-02');

UNIT TEST

INSERT INTO reservation VALUES (1,'PT', 1,'PT', '1990-03-02', '2000-03-02');
ERROR
INSERT INTO reservation
VALUES (1,'PT', 1,'PT', '1990-03-01', '2000-03-01');
ERROR
INSERT INTO reservation
VALUES (1,'PT', 1,'PT', '2021-01-01', '2021-12-11');
GOOD
*/

--2
-- we had to divide this ic into 2:
-- check if there is already one specialization when inserting into another specialization an if the location was specialized

--check after each insert to the specialization or location tables if the number of specialization is exactly 1
CREATE OR REPLACE FUNCTION check_if_already_spec_func()
    RETURNS TRIGGER AS

$$
    DECLARE a_count int;
    DECLARE b_count int;
    DECLARE c_count int;


BEGIN

    Select COUNT(*) INTO a_count From port a where a.latitude = new.latitude and a.longitude=new.longitude;
    Select COUNT(*) INTO b_count From marina b where b.latitude = new.latitude and b.longitude=new.longitude;
    Select COUNT(*) INTO c_count From wharf c where c.latitude = new.latitude and c.longitude=new.longitude;

    IF a_count+b_count+c_count=0 then
        RAISE EXCEPTION 'No specialization specified';
    end if;

    IF a_count+b_count+c_count>1 then
        RAISE EXCEPTION 'Already specialized';
    end if;
    return new;
end;
$$ language plpgsql;

CREATE CONSTRAINT TRIGGER check_spec_port
    AFTER INSERT
    ON port DEFERRABLE
    FOR EACH ROW
EXECUTE PROCEDURE check_if_already_spec_func();

CREATE CONSTRAINT TRIGGER check_spec_marina
    AFTER INSERT
    ON marina DEFERRABLE
    FOR EACH ROW
EXECUTE PROCEDURE check_if_already_spec_func();

CREATE CONSTRAINT TRIGGER check_spec_wharf
    AFTER INSERT
    ON wharf DEFERRABLE
    FOR EACH ROW
EXECUTE PROCEDURE check_if_already_spec_func();

CREATE CONSTRAINT TRIGGER check_spec_trip
    AFTER INSERT 
    ON location DEFERRABLE
    FOR EACH ROW
EXECUTE PROCEDURE check_if_already_spec_func();

/*
 UNIT TEST

INSERT INTO location
VALUES ('Port_1',10, 10,  'PT');
--good
INSERT INTO wharf
VALUES (10, 10);
--error
INSERT INTO wharf
VALUES (20.56, 20.32);
 */



/*
 UNIT TEST

INSERT INTO location
VALUES ('NO_SPEC',2, 2,  'PT');

DELETE FROM trip where TRUE;

INSERT INTO trip
VALUES ('1990-04-02', 23, 1,'PT', 1, 'PT' ,'1990-03-02', '2000-03-02', 2, 2, 80, 80);

DELETE FROM trip where TRUE;
INSERT INTO trip
VALUES ('1990-04-02', 23, 1,'PT', 1, 'PT' ,'1990-03-02', '2000-03-02', 80, 80, 2, 2);
DELETE FROM trip where TRUE;

INSERT INTO trip
VALUES ('1990-04-02', 23, 1,'PT', 1, 'PT' ,'1990-03-02', '2000-03-02', 80, 80, 80, 80);

 */


--3
-- assumes that locations and countries are not updatable
CREATE OR REPLACE FUNCTION check_country_boat_func()
    RETURNS TRIGGER AS

$$
BEGIN

    If NOT EXISTS (Select *
              From location l
              where l.iso_code=new.iso_code)

    THEN
        RAISE EXCEPTION '´Country does not have a location';
    end if;
    return new;
end;
$$ language plpgsql;

CREATE TRIGGER check_country_boat
    BEFORE INSERT OR UPDATE
    ON boat
    FOR EACH ROW
EXECUTE PROCEDURE check_country_boat_func();

/*
 UNIT TESTS
 empty country
 INSERT INTO country VALUES ('4','Spain', 'ES');

 good boat
INSERT INTO boat
VALUES ( 'Tomas Miguel boat' ,1990,4, 'PT', 1, 'PT');
error boat
INSERT INTO boat
VALUES ( 'Tomas Miguel boat' ,1990,1, 'ES', 1, 'PT');
 */
