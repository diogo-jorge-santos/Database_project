--pode ser necessário colocar um nome caso for defenido outro nome para o schema

--1
SELECT boat_cni,boat_country,boat_name from boat where (boat_cni,boat_country) in (SELECT res_boat_cni,res_boat_country FROM res) ;
--2
SELECT * FROM sailor s join person p on (s.sailor_id,s.sailor_country)=(p.person_id,p.person_country) where (person_id,person_country) in (SELECT res_sailor_id,res_sailor_country from res where res_boat_country = (select country_iso from country where country_name='Portugal'));

--3
SELECT * FROM res where res_schdl_end-res_schdl_start>5;

--4
SELECT boat_name,boat_cni,boat_country from boat where boat_country=(select country_iso from country where country_name='South Africa') and (boat_ownr_id,boat_ownr_country) in (Select p.person_id,p.person_country from ownr o join person p on (o.ownr_id,o.ownr_country)=(p.person_id,p.person_country) where p.person_name like '%Rendeiro');
