/*4*/
select count(distinct popp.gid) as buildings
from popp
join rivers on 1=1
where popp.f_codedesc='Building' and st_distance(popp.geom, rivers.geom) < 1000;

create table tableB as(
	select distinct popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom
	from popp
	join rivers on 1=1
	where popp.f_codedesc='Building' and st_distance(popp.geom, rivers.geom) < 1000
);

/*5*/
create table airportsNew as(
	select name, geom, elev
	from airports
);

select *
from airportsNew
where ST_X(geom) = (select min(ST_X(geom)) from airportsNew);

select *
from airportsNew
where ST_X(geom) = (select max(ST_X(geom)) from airportsNew);

insert into airportsNew
values('airportB', 
	   st_point(
	       ((select st_x(geom) from airportsNew where st_x(geom) = (select min(st_x(geom)) from airportsNew)) +
		   (select st_x(geom) from airportsNew where st_x(geom) = (select max(st_x(geom)) from airportsNew)))/2,
	       ((select st_y(geom) from airportsNew where st_x(geom) = (select min(st_x(geom)) from airportsNew)) +
		   (select st_y(geom) from airportsNew where st_x(geom) = (select max(st_x(geom)) from airportsNew)))/2
	   ),
	   50
);

/*6*/
select st_area(
	(select st_buffer(
		(select st_shortestline((select geom from lakes where names = 'Iliamna Lake'),
					  	   	    (select geom from airports where name = 'AMBLER'))),
	1000
    ))
);

/*7*/
select joined.vegdesc, sum(joined.sum) 
from((select vegdesc, sum(trees.area_km2) 
	 from trees 
	 join swamp on st_contains(swamp.geom, trees.geom) 
	 group by vegdesc)
	 union all
 	 (select vegdesc, sum(trees.area_km2) 
	 from trees 
	 join tundra on st_contains(tundra.geom, trees.geom) 
	 group by vegdesc)) as joined
group by joined.vegdesc;
