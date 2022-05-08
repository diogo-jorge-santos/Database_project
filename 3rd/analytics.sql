SET search_path TO 'Project_3';

--allow you to analyze the total number of trips according to different groups depending on

--1. The start date (i.e., per year, per month independently of year, and per exact date);

SELECT EXTRACT(YEAR FROM trip_start_date) AS year, EXTRACT(MONTH FROM trip_start_date) AS month
       , trip_start_date, COUNT(*) AS total_trips
    FROM trip_info
    GROUP BY GROUPING SETS ((year), (month), (trip_start_date))
    --ROLLUP (year, month, trip_start_date)
    ORDER BY year, month, trip_start_date, total_trips ;

SELECT country_name_origin, loc_name_origin, COUNT(*) AS total_trips FROM trip_info
    GROUP BY ROLLUP (country_name_origin, loc_name_origin)
    ORDER BY loc_name_origin, country_name_origin, total_trips;


