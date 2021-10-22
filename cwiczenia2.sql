/*2*/
CREATE DATABASE cw2;
	
/*3*/
CREATE EXTENSION postgis;

/*4*/ 
CREATE TABLE public.buildings
(
    id integer NOT NULL,
    geometry geometry NOT NULL,
    name character varying(20) NOT NULL,
    CONSTRAINT buildings_pkey PRIMARY KEY (id)
);

CREATE TABLE public.roads
(
    id integer NOT NULL,
    geometry geometry NOT NULL,
    name character varying(20) NOT NULL,
    CONSTRAINT roads_pkey PRIMARY KEY (id)
);

CREATE TABLE public.poi
(
    id integer NOT NULL,
    geometry geometry NOT NULL,
    name character varying(20) NOT NULL,
    CONSTRAINT roads_pkey PRIMARY KEY (id)
);

/*5*/
INSERT INTO buildings VALUES('1', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'), 'BuildingA');
INSERT INTO buildings VALUES('2', ST_GeomFromText('POLYGON((6 7, 6 5, 4 5, 4 7, 6 7))'), 'BuildingB');
INSERT INTO buildings VALUES('3', ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))'), 'BuildingC');
INSERT INTO buildings VALUES('4', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'), 'BuildingD');
INSERT INTO buildings VALUES('5', ST_GeomFromText('POLYGON((2 2,2 1,1 1,1 2,2 2))'), 'BuildingF');

INSERT INTO roads VALUES('1', ST_GeomFromText('LINESTRING(0 4.5,12 4.5)'), 'RoadX');
INSERT INTO roads VALUES('2', ST_GeomFromText('LINESTRING(7.5 0,7.5 10.5)'), 'RoadY');

INSERT INTO poi VALUES('1', ST_Point(1,3.5), 'G');
INSERT INTO poi VALUES('2', ST_Point(5.5, 1.5), 'H');
INSERT INTO poi VALUES('3', ST_Point(9.5, 6), 'I');
INSERT INTO poi VALUES('4', ST_Point(6.5, 6), 'J');
INSERT INTO poi VALUES('5', ST_Point(6, 9.5), 'K');

/*6*/
/*a*/
SELECT SUM (ST_Length(geometry)) FROM roads;

/*b*/
SELECT geometry, ST_AREA(geometry), ST_PERIMETER(geometry) FROM buildings WHERE name='BuildingA';

/*c*/
SELECT name, ST_AREA(geometry), ST_PERIMETER(geometry) FROM buildings ORDER BY name;

/*d*/
SELECT name, ST_PERIMETER(geometry) AS perimeter FROM buildings ORDER BY perimeter DESC LIMIT 2;

/*e*/
SELECT ST_DISTANCE(geometry, POINT(1, 3.5)::geometry) FROM buildings WHERE name='BuildingC';

/*f*/
SELECT (SELECT ST_Area(geometry) FROM buildings WHERE  name = 'BuildingC') - (SELECT ST_Area(ST_Intersection(ST_Buffer(geometry , 0.5), (SELECT geometry FROM buildings WHERE name = 'BuildingC')))
FROM buildings
WHERE name = 'BuildingB');

/*g*/
SELECT * FROM buildings WHERE 
ST_Y(ST_CENTROID(geometry)) > (SELECT ST_Y(ST_POINTN(geometry, 1)) FROM roads WHERE name='RoadX');

/*h*/
SELECT ST_AREA(geometry) + ST_AREA('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))') - 2 * ST_AREA(ST_INTERSECTION (geometry, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
FROM buildings
WHERE name='BuildingC';

