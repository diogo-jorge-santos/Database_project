--CREATE VIEW trip_info as
SET search_path TO 'Project_3';

drop view if exists "Project_3".trip_info;

CREATE VIEW trip_info(country_iso_origin,country_name_origin
    ,country_iso_dest,country_name_dest,loc_name_origin
    ,loc_name_dest,cni_boat,country_name_boat
    ,country_iso_boat,trip_start_date) as
    SELECT
       l_o.iso_code as "country_iso_origin",
       c_o.name as "country_name_origin",

       l_d.iso_code as "country_iso_dest",
       c_d.name as "country_name_dest",

       l_o.name as "loc_name_origin",
       l_d.name as "loc_name_dest",

       t.cni as "cni_boat" ,
       c_b.name as "country_name_boat" ,
       t.iso_code_boat as "country_iso_boat" ,
       t.date as "trip_start_date"
        from trip t
        inner join country c_b on (t.iso_code_boat=c_b.iso_code)
        inner join location l_o on (t.start_latitude=l_o.latitude and t.start_longitude=l_o.longitude)
        inner join location l_d on (t.end_latitude=l_d.latitude and t.end_longitude=l_d.longitude)
        inner join country c_o on (l_o.iso_code=c_o.iso_code)
        inner join country c_d on (l_d.iso_code=c_d.iso_code);
