/*1*/
create extension postgis;
create table obiekty(id integer primary key, nazwa varchar(10), geom geometry);

insert into obiekty values(1, 'obiekt1', st_curvetoline('multicurve(
	linestring(0 1, 1 1), circularstring(1 1, 2 0, 3 1, 4 2, 5 1), linestring(5 1, 6 1))'));
	
insert into obiekty values(2, 'obiekt2', st_curvetoline('multicurve(
	linestring(10 6, 14 6), circularstring(14 6, 16 4, 14 2, 12 0, 10 2), linestring(10 2, 10 6)),
	circularstring(13 2, 11 2, 13 2)'));


insert into obiekty values(3, 'obiekt3', st_curvetoline('multicurve(
	linestring(10 17, 12 13), linestring(12 13, 7 15), linestring(7 15, 10 17))'));
	
insert into obiekty values(4, 'obiekt4', st_curvetoline('multicurve(
	linestring(20 20, 25 25), linestring(25 25, 27 24), linestring(27 24, 25 22), 
	linestring(25 22, 26 21), linestring(26 21, 22 19), linestring(22 19, 20.5 19.5))'));
	
insert into obiekty values(5, 'obiekt5', st_geomfromewkt('geometrycollection(
	pointz(30 30 59), pointz(38 32 234))'));
	
insert into obiekty values(6, 'obiekt6', st_geomfromewkt('geometrycollection(
	point(4 2), linestring(1 1, 3 2))'));
	

/*2*/
select st_area(st_buffer(st_shortestline(
	(select geom from obiekty where nazwa='obiekt3'), 
	(select geom from obiekty where nazwa='obiekt4')), 5));
	
/*3*/
/*Poligon jest wielokątem, a więc należy sprawić, by obiekt był wielokątem, łącząc odpowiednie punkty.*/
update obiekty set geom=st_buildarea(st_curvetoline('multicurve(
	linestring(20 20, 25 25), linestring(25 25, 27 24), linestring(27 24, 25 22), 
	linestring(25 22, 26 21), linestring(26 21, 22 19), linestring(22 19, 20.5 19.5), 
	linestring(20.5 19.5, 20 20))')) where id=4;
	
/*4*/
insert into
values(7, 'obiekt7', st_collect((select geom from obiekty where nazwa='obiekt3'), 
							  (select geom from obiekty where nazwa='obiekt4')));
							  
/*5*/
select sum(st_area(st_buffer(geom, 5))) from obiekty where st_hasarc(geom)=false;
