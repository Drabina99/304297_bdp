/*1*/
CREATE DATABASE firma;

/*2*/
CREATE SCHEMA ksiegowosc;

/*4*/
CREATE TABLE ksiegowosc.pracownicy
(
    id_pracownika integer NOT NULL,
    imie character varying(30) NOT NULL,
    nazwisko character varying(30) NOT NULL,
    adres character varying(200) NOT NULL,
    telefon character varying(30) NOT NULL,
    CONSTRAINT pracownicy_pkey PRIMARY KEY (id_pracownika)
);
	
CREATE TABLE ksiegowosc.godziny
(
    id_godziny integer NOT NULL,
    data date NOT NULL,
    liczba_godzin integer NOT NULL,
    id_pracownika integer NOT NULL,
    CONSTRAINT godziny_pkey PRIMARY KEY (id_godziny),
    CONSTRAINT id_pracownika FOREIGN KEY (id_pracownika)
        REFERENCES ksiegowosc.pracownicy (id_pracownika) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
	
CREATE TABLE ksiegowosc.pensja
(
    id_pensji integer NOT NULL,
    stanowisko character varying(100) NOT NULL,
    kwota money NOT NULL,
    CONSTRAINT pensja_pkey PRIMARY KEY (id_pensji)
);
	
CREATE TABLE ksiegowosc.premia
(
    id_premii integer NOT NULL,
    rodzaj character varying(200) NOT NULL,
    kwota money NOT NULL,
    CONSTRAINT premia_pkey PRIMARY KEY (id_premii)
);
	
CREATE TABLE ksiegowosc.wynagrodzenie
(
    id_wynagrodzenia integer NOT NULL,
    data date NOT NULL,
    id_pracownika integer NOT NULL,
    id_godziny integer NOT NULL,
    id_pensji integer NOT NULL,
    id_premii integer,
    CONSTRAINT wynagrodzenie_pkey PRIMARY KEY (id_wynagrodzenia),
    CONSTRAINT id_godziny FOREIGN KEY (id_godziny)
        REFERENCES ksiegowosc.godziny (id_godziny) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT id_pensji FOREIGN KEY (id_pensji)
        REFERENCES ksiegowosc.pensja (id_pensji) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT id_pracownika FOREIGN KEY (id_pracownika)
        REFERENCES ksiegowosc.pracownicy (id_pracownika) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT id_premii FOREIGN KEY (id_premii)
        REFERENCES ksiegowosc.premia (id_premii) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

/*5*/
INSERT INTO ksiegowosc.pracownicy (id_pracownika, imie, nazwisko, adres, telefon) VALUES
(16, 'Charles', 'Leclerc', 'Pl. du Casino, 98000 Monaco, Monaco', '+37798062000'),
(7, 'Cristiano', 'Ronaldo', 'Sir Matt Busby Way, Manchester M16 0RA, UK', '+441616767770'),
(50, 'Walter', 'White', '308 Negra Arroyo Lane, Albuquerque, USA', '+14201239870'),
(88, 'Robert', 'Kubica', 'Piazza del Colosseo, 1, 00184 Roma RM, Italy', '+390639967700'),
(1001, 'Elliot', 'Alderson', '20 W 34th St, New York, NY 10001, USA','+12127363100');

INSERT INTO ksiegowosc.godziny (id_godziny, data, liczba_godzin, id_pracownika) VALUES
(55, '2021-09-30', 50, 16),
(5, '2021-09-30', 70, 7),
(10, '2011-05-31', 160, 50),
(20, '2021-08-31', 30, 88),
(44, '2015-04-30', 160, 1001);

INSERT INTO ksiegowosc.pensja (id_pensji, stanowisko, kwota) VALUES
(10, 'kierowca wyscigowy', 4000000.00),
(20, 'zawodnik', 11300000.00),
(30, 'nauczyciel', 6500.00),
(40, 'kierowca testowy', 80000.00),
(50, 'specjalista ds. bezp. IT', 10000.00);

INSERT INTO ksiegowosc.premia (id_premii, rodzaj, kwota) VALUES
(1, 'Pole Position', 200000.00),
(2, 'Zawodnik Miesiaca', 400000.00),
(3, 'Dzialalnosc pozaszkolna', 5000000.00),
(4, 'Udzial w wyscigu', 100000.00),
(5, 'Premia swiateczna', 2000.00);

INSERT INTO ksiegowosc.wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
(1, '2021-10-10', 16, 55, 10, 1),
(250, '2021-10-08', 7, 5, 20, 2),
(333, '2011-06-03', 50, 10, 30, 3),
(600, '2021-05-09', 88, 20, 40, 4),
(900, '2015-05-05', 1001, 44, 50, 5);

/*6*/
/*a*/
SELECT id_pracownika, nazwisko 
FROM ksiegowosc.pracownicy;

/*b*/
SELECT id_pracownika 
FROM ksiegowosc.wynagrodzenie 
JOIN ksiegowosc.pensja
ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota > CAST(1000 AS money);

/*c*/
SELECT id_pracownika 
FROM ksiegowosc.wynagrodzenie 
	JOIN ksiegowosc.pensja
ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota > CAST(2000 AS money) AND wynagrodzenie.id_premii IS NULL;

/*d*/
SELECT * FROM ksiegowosc.pracownicy
WHERE SUBSTRING(nazwisko, 1, 1) = 'J';

/*e*/
SELECT * FROM ksiegowosc.pracownicy
WHERE LOWER (nazwisko) LIKE '%n%' 
AND RIGHT(imie, 1) = 'a';

/*f*/
SELECT imie, nazwisko, GREATEST(0, godziny.liczba_godzin - 160) AS nadgodziny
FROM ksiegowosc.pracownicy
	JOIN ksiegowosc.godziny
ON pracownicy.id_pracownika = godziny.id_pracownika;

/*g*/
SELECT wyn_pra.imie, wyn_pra.nazwisko 
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
WHERE pen_pra.kwota >= CAST(1500 as money) AND pen_pra.kwota <= CAST(3000 as money);

/*h*/
SELECT wyn_pra.imie, wyn_pra.nazwisko 
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.godziny AS wyn_god
	ON wyn_god.id_godziny = wynagrodzenie.id_godziny
WHERE wynagrodzenie.id_premii IS NULL AND wyn_god.liczba_godzin - 160 > 0;

/*i*/
SELECT wyn_pra.*
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
ORDER BY wyn_pen.kwota;

/*j*/
SELECT wyn_pra.imie, wyn_pra.nazwisko 
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
	JOIN ksiegowosc.premia AS wyn_pre
	ON wyn_pre.id_premii = wynagrodzenie.id_premii
ORDER BY wyn_pen.kwota DESC, wyn_pre.kwota DESC;

/*k*/
SELECT wyn_pen.stanowisko, COUNT (wyn_pra.id_pracownika) AS liczba
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
GROUP BY (wyn_pen.stanowisko);

/*l*/
SELECT 
	ROUND (AVG (wyn_pen.kwota::NUMERIC), 2) AS srednia,
	MIN (ROUND(wyn_pen.kwota::NUMERIC, 2)) AS min,
	MAX (ROUND(wyn_pen.kwota::NUMERIC, 2)) AS maks
FROM ksiegowosc.pensja;
WHERE stanowisko = 'kierownik';

SELECT 
	wyn_pen.stanowisko, 
	ROUND (AVG (wyn_pen.kwota::NUMERIC), 2) AS srednia,
	MIN (ROUND(wyn_pen.kwota::NUMERIC, 2)) AS min,
	MAX (ROUND(wyn_pen.kwota::NUMERIC, 2)) AS maks
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.pracownicy AS wyn_pra 
	ON wyn_pra.id_pracownika = wynagrodzenie.id_pracownika
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
GROUP BY (wyn_pen.stanowisko) HAVING (wyn_pen.stanowisko='kierownik');

/*m*/
SELECT SUM (kwota) FROM ksiegowosc.pensja;

/*n*/
SELECT stanowisko, SUM (kwota) FROM ksiegowosc.pensja GROUP BY stanowisko;

/*o*/
SELECT 
	wyn_pen.stanowisko, 
	COUNT(wyn_pre.id_premii)
FROM ksiegowosc.wynagrodzenie
	JOIN ksiegowosc.premia AS wyn_pre 
	ON wyn_pre.id_premii = wynagrodzenie.id_premii
	JOIN ksiegowosc.pensja AS wyn_pen
	ON wyn_pen.id_pensji = wynagrodzenie.id_pensji
GROUP BY (wyn_pen.stanowisko);

/*p*/
DELETE FROM ksiegowosc.pracownicy 
USING ksiegowosc.wynagrodzenie, ksiegowosc.pensja
WHERE CAST(pensja.kwota AS numeric) < 1200
AND wynagrodzenie.id_pracownika = pracownicy.id_pracownika;
AND wynagrodzenie.id_pensji = pensja.id_pensji;
