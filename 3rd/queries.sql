SET search_path TO 'Project_3';

--1 Who is the owner with the most boats per country? (to each different country, shows the owner(s) with most boats)

SELECT v1.iso_code AS country, v1.iso_code_owner, v1.id_owner, v1.boat_count
FROM (  --boats per country per owner
        SELECT iso_code, id_owner, iso_code_owner, COUNT(*) AS boat_count
        FROM boat
        GROUP BY (id_owner,iso_code_owner,iso_code) ) AS v1
WHERE v1.boat_count >= ALL(     SELECT v2.boat_count
                                FROM (  --boats per country per owner
                                        SELECT iso_code, id_owner, iso_code_owner, COUNT(*) AS boat_count
                                        FROM boat
                                        GROUP BY (id_owner,iso_code_owner,iso_code) ) AS v2
                                WHERE v2.iso_code = v1.iso_code)
ORDER BY country, v1.iso_code_owner; -- order only for readability

--2 List all the owners that have at least two boats in distinct countries.

SELECT id_owner, iso_code_owner, country_count
FROM (  --number of countries where owner owns a boat
        SELECT id_owner, iso_code_owner, COUNT(DISTINCT iso_code) AS country_count
        FROM boat
        GROUP BY (id_owner,iso_code_owner) ) AS v1
WHERE country_count >= 2;

--3 Who are the sailors that have sailed to every location in 'Portugal'? (only end location of trip counts)

--testing inner query
/*
SELECT latitude,longitude FROM location WHERE iso_code = 'PT'
    EXCEPT (    SELECT t.end_latitude,t.end_longitude
                FROM trip t
                WHERE (t.id_sailor='1' AND t.iso_code_sailor='ZW'));
*/
SELECT DISTINCT d.id_sailor,d.iso_code_sailor
FROM trip d
WHERE NOT EXISTS(
    SELECT latitude,longitude FROM location WHERE iso_code = 'PT'
    EXCEPT (    SELECT t.end_latitude,t.end_longitude
                FROM trip t
                WHERE (t.id_sailor=d.id_sailor AND t.iso_code_sailor=d.iso_code_sailor)) );

--4. List the sailors with the most trips along with their reservations (only the sailors with the most trips are listed)

SELECT *
FROM reservation
WHERE (id_sailor, iso_code_sailor) IN (
    --table with all sailors with most trips (more than one if there is a draw)
    SELECT v1.id_sailor, v1.iso_code_sailor
    FROM (  --number of trips per sailor
            SELECT id_sailor, iso_code_sailor, COUNT(*) AS trip_count
            FROM trip
            GROUP BY (id_sailor, iso_code_sailor) ) AS v1
    WHERE v1.trip_count >= ALL( SELECT v2.trip_count
                                FROM (  --number of trips per sailor
                                        SELECT id_sailor, iso_code_sailor, COUNT(*) AS trip_count
                                        FROM trip
                                        GROUP BY (id_sailor, iso_code_sailor) ) AS v2 ));

--5. List the sailors with the longest duration of trips (sum of trip durations) for the same
--single reservation; display also the sum of the trip durations.

SELECT id_sailor, iso_code_sailor, sum_durations
FROM (  --reservations and the sum of their trip durations
        SELECT cni, iso_code_boat, id_sailor, iso_code_sailor, start_date, end_date, SUM(duration) AS sum_durations
        FROM trip
        GROUP BY (cni, iso_code_boat, id_sailor, iso_code_sailor, start_date, end_date)) AS v1
WHERE sum_durations >= ALL( SELECT sum_durations
                            FROM (  --reservations and the sum of their trip durations
                                    SELECT SUM(duration) AS sum_durations
                                    FROM trip
                                    GROUP BY (cni, iso_code_boat, id_sailor, iso_code_sailor, start_date, end_date)) AS v2
                            );