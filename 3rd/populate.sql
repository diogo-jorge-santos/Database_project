SET search_path TO 'Project_3';

DELETE
FROM trip cascade;
DELETE
FROM reservation cascade;

DELETE
FROM schedule cascade;
DELETE
FROM boat_vhf cascade;
DELETE
FROM boat cascade;

DELETE
FROM owner cascade;
DELETE
FROM sailor cascade;
DELETE
FROM person cascade;



DELETE
FROM marina cascade;
DELETE
FROM wharf cascade;
DELETE
FROM port cascade;
DELETE
FROM location cascade;

DELETE
FROM country cascade;



----------------------------------------
-- Populate Relations
----------------------------------------

INSERT INTO country
VALUES ( '1','Portugal', 'PT');
INSERT INTO country
VALUES ('2','South Africa', 'ZA');
INSERT INTO country
VALUES ('3','Zimbabwe', 'ZW');


START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO location
VALUES ('Port',20, 20,  'PT');
INSERT INTO port
VALUES (20, 20);
COMMIT;

START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO location
VALUES ('Port',1, 1,  'ZA');
INSERT INTO port
VALUES (1, 1);
COMMIT;

START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO location
VALUES ('wharf',80, 80,  'ZA');
INSERT INTO wharf
VALUES (80, 80);
COMMIT;

START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO location
VALUES ('marina',90, 120,  'ZW');
INSERT INTO marina
VALUES (90, 120);
COMMIT;








INSERT INTO person
VALUES (1, 'Tomas Miguel', 'PT');
INSERT INTO person
VALUES (2, 'Joao Rendeiro', 'PT');
INSERT INTO person
VALUES (3, 'Maria Rendeiro', 'PT');
INSERT INTO person
VALUES (1, 'Tomas Miguel', 'ZW');
INSERT INTO person
VALUES (2, 'Joao Rendeiro', 'ZW');
INSERT INTO person
VALUES (1, 'Joana Miguel', 'ZA');
INSERT INTO person
VALUES (2, 'Tomas Rendeiro', 'ZA');




INSERT INTO owner
VALUES ( 1,'PT','1990-03-02');
INSERT INTO owner
VALUES ( 2,'PT','1990-04-02');
INSERT INTO owner
VALUES ( 3,'PT','1990-07-02');
INSERT INTO owner
VALUES  (1,'ZW','1990-03-02');
INSERT INTO owner
VALUES (2,'ZA','1952-05-22');



INSERT INTO sailor
VALUES (1,'PT');
INSERT INTO sailor
VALUES (2,'PT');
INSERT INTO sailor
VALUES (3,'PT');
INSERT INTO sailor
VALUES (2,'ZW');
INSERT INTO sailor
VALUES (1,'ZA');


INSERT INTO boat
VALUES ( 'Tomas Miguel boat',1990,1, 'PT', 1, 'PT');
INSERT INTO boat
VALUES ( 'Tomas Miguel boat' ,1990,1, 'ZA', 1, 'PT');
INSERT INTO boat
VALUES ('Tomas Miguel boat',  1990,1, 'ZW', 1, 'PT');
INSERT INTO boat
VALUES ('Joao Rendeiro boat',  1990,2, 'PT', 2, 'PT');
INSERT INTO boat
VALUES ( 'boat', 1990,2, 'ZA', 2, 'ZA');
INSERT INTO boat
VALUES ( 'boat', 1990,3, 'PT', 1, 'ZW');




INSERT INTO boat_vhf
VALUES (123456, 1,'PT');


INSERT INTO schedule
VALUES ('1990-03-02', '2000-03-02');
INSERT INTO schedule
VALUES ('2021-01-01', '2021-12-11');


INSERT INTO reservation
VALUES (1,'PT', 1,'PT', '1990-03-02', '2000-03-02');
INSERT INTO reservation
VALUES (2,'PT', 1,'ZA', '1990-03-02', '2000-03-02');
INSERT INTO reservation
VALUES (2,'ZA', 2,'ZW', '2021-01-01', '2021-12-11');

INSERT INTO trip
VALUES ('1990-04-02', 50, 1,'PT', 1, 'PT' ,'1990-03-02', '2000-03-02', 80, 80, 20, 20);

INSERT INTO trip
VALUES ('1990-04-02', 20, 2,'PT', 1,'ZA' ,'1990-03-02', '2000-03-02', 80, 80, 80, 80);
INSERT INTO trip
VALUES ('1995-05-02', 30, 2,'PT', 1,'ZA' ,'1990-03-02', '2000-03-02', 20, 20, 1, 1);
INSERT INTO trip
VALUES ('1996-05-02', 30, 2,'PT', 1,'ZA' ,'1990-03-02', '2000-03-02', 1, 1, 90, 120);

INSERT INTO trip
VALUES ('2021-04-20', 10, 2,'ZA', 2,'ZW', '2021-01-01', '2021-12-11', 80, 80, 1, 1);
INSERT INTO trip
VALUES ('2021-05-20', 10, 2,'ZA', 2,'ZW', '2021-01-01', '2021-12-11', 90, 120, 90, 120);
INSERT INTO trip
VALUES ('2021-06-20', 10, 2,'ZA', 2,'ZW', '2021-01-01', '2021-12-11', 20, 20, 1, 1);

