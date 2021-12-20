--
-- PostgreSQL database dump
--

-- Dumped from database version 11.14
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dolarhesap(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dolarhesap(fiyat integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $$declare
dolarhesap decimal;
begin
dolarhesap:=fiyat /17;
return dolarhesap;
end;
$$;


ALTER FUNCTION public.dolarhesap(fiyat integer) OWNER TO postgres;

--
-- Name: insertkategori(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertkategori(_kategoriad character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
      BEGIN
        INSERT INTO kategoriler(kategoriid,kategoriad)
        VALUES(default,_kategoriad);
      END;
  $$;


ALTER FUNCTION public.insertkategori(_kategoriad character varying) OWNER TO postgres;

--
-- Name: kar(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kar(satisfiyat integer, alisfiyat integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
karoran integer;
begin
karoran:=satisfiyat-alisfiyat;
return karoran;
end;
$$;


ALTER FUNCTION public.kar(satisfiyat integer, alisfiyat integer) OWNER TO postgres;

--
-- Name: maas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if new.medenihali = 1  then
   update personel set maas = maas + 300;
end if;
  return new;
end;
$$;


ALTER FUNCTION public.maas() OWNER TO postgres;

--
-- Name: personeldepo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.personeldepo(deponumara integer) RETURNS TABLE(numara integer, adi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "personelid", "adısoyadı" FROM personel
                 WHERE "depoid" = deponumara;
END;
$$;


ALTER FUNCTION public.personeldepo(deponumara integer) OWNER TO postgres;

--
-- Name: silinensiparis(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.silinensiparis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
silinenmiktar integer;
begin
silinenmiktar:=(select "miktar" from silinensiparis order by id desc limit 1 );
update urunlerbayi set miktar=silinenmiktar+miktar where urunid = (select urunid from silinensiparis order by id desc limit 1 );
return new;
end;
$$;


ALTER FUNCTION public.silinensiparis() OWNER TO postgres;

--
-- Name: stok(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stok() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
miktarguncel integer ;
begin
miktarguncel:=(select "miktar" from siparis order by sipariskodu desc limit 1 );
update urunlerbayi set miktar =miktar-miktarguncel where urunid = (select "barkodno" from siparis order by sipariskodu desc limit 1 );
return new;
end;
$$;


ALTER FUNCTION public.stok() OWNER TO postgres;

--
-- Name: toplampersonel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplampersonel() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update depo set toplampersonel=toplampersonel+1 where depoid = (select depoid from personel order by personelid desc limit 1 );
return new;
end;
$$;


ALTER FUNCTION public.toplampersonel() OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: depo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depo (
    depoid integer NOT NULL,
    ilceid integer,
    toplampersonel integer
);


ALTER TABLE public.depo OWNER TO postgres;

--
-- Name: depo_depoid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.depo_depoid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.depo_depoid_seq OWNER TO postgres;

--
-- Name: depo_depoid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.depo_depoid_seq OWNED BY public.depo.depoid;


--
-- Name: fatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fatura (
    faturaid integer NOT NULL,
    faturagorsel text
);


ALTER TABLE public.fatura OWNER TO postgres;

--
-- Name: fatura_faturaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fatura_faturaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fatura_faturaid_seq OWNER TO postgres;

--
-- Name: fatura_faturaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fatura_faturaid_seq OWNED BY public.fatura.faturaid;


--
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    ilid integer NOT NULL,
    "iladı" character varying(11)
);


ALTER TABLE public.il OWNER TO postgres;

--
-- Name: il_ilid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.il_ilid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.il_ilid_seq OWNER TO postgres;

--
-- Name: il_ilid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.il_ilid_seq OWNED BY public.il.ilid;


--
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    ilceid integer NOT NULL,
    "ilceadı" character varying(16),
    ilid integer
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- Name: ilce_ilceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ilce_ilceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ilce_ilceid_seq OWNER TO postgres;

--
-- Name: ilce_ilceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ilce_ilceid_seq OWNED BY public.ilce.ilceid;


--
-- Name: kargosirket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kargosirket (
    sirketid integer NOT NULL,
    sirketad character varying(15)
);


ALTER TABLE public.kargosirket OWNER TO postgres;

--
-- Name: kargosirket_sirketid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kargosirket_sirketid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kargosirket_sirketid_seq OWNER TO postgres;

--
-- Name: kargosirket_sirketid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kargosirket_sirketid_seq OWNED BY public.kargosirket.sirketid;


--
-- Name: kategoriler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kategoriler (
    kategoriid integer NOT NULL,
    kategoriad character varying(20)
);


ALTER TABLE public.kategoriler OWNER TO postgres;

--
-- Name: kategoriler_kategoriid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kategoriler_kategoriid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kategoriler_kategoriid_seq OWNER TO postgres;

--
-- Name: kategoriler_kategoriid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kategoriler_kategoriid_seq OWNED BY public.kategoriler.kategoriid;


--
-- Name: markalar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.markalar (
    markaid integer NOT NULL,
    "markadı" character varying(20)
);


ALTER TABLE public.markalar OWNER TO postgres;

--
-- Name: markalar_markaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.markalar_markaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.markalar_markaid_seq OWNER TO postgres;

--
-- Name: markalar_markaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.markalar_markaid_seq OWNED BY public.markalar.markaid;


--
-- Name: medenihal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medenihal (
    medeniid integer NOT NULL,
    medeniad character varying(8)
);


ALTER TABLE public.medenihal OWNER TO postgres;

--
-- Name: medenihal_medeniid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medenihal_medeniid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medenihal_medeniid_seq OWNER TO postgres;

--
-- Name: medenihal_medeniid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medenihal_medeniid_seq OWNED BY public.medenihal.medeniid;


--
-- Name: musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musteri (
    tc character varying(11) NOT NULL,
    adsoyad character varying(30),
    telefon character varying(12),
    adres text,
    email text
);


ALTER TABLE public.musteri OWNER TO postgres;

--
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    personelid integer NOT NULL,
    "adısoyadı" character varying(25),
    medenihali integer,
    depoid integer,
    "dogumyılı" date,
    maas integer
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- Name: personel_personelid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personel_personelid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personel_personelid_seq OWNER TO postgres;

--
-- Name: personel_personelid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personel_personelid_seq OWNED BY public.personel.personelid;


--
-- Name: personelyakini; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personelyakini (
    personeyakinilid integer NOT NULL,
    yakinadisoyadi character varying(20),
    personelid integer
);


ALTER TABLE public.personelyakini OWNER TO postgres;

--
-- Name: personelyakini_personeyakinilid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personelyakini_personeyakinilid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personelyakini_personeyakinilid_seq OWNER TO postgres;

--
-- Name: personelyakini_personeyakinilid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personelyakini_personeyakinilid_seq OWNED BY public.personelyakini.personeyakinilid;


--
-- Name: silinensiparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silinensiparis (
    id integer NOT NULL,
    urunid character varying(11),
    miktar integer
);


ALTER TABLE public.silinensiparis OWNER TO postgres;

--
-- Name: silinensiparis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.silinensiparis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.silinensiparis_id_seq OWNER TO postgres;

--
-- Name: silinensiparis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.silinensiparis_id_seq OWNED BY public.silinensiparis.id;


--
-- Name: siparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparis (
    barkodno character varying(12) NOT NULL,
    musteriid character varying(11) NOT NULL,
    kargoid integer,
    personelid integer,
    faturaid integer,
    miktar integer NOT NULL,
    sipariskodu integer NOT NULL,
    satisfiyat integer
);


ALTER TABLE public.siparis OWNER TO postgres;

--
-- Name: siparis_sirketkodu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.siparis_sirketkodu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.siparis_sirketkodu_seq OWNER TO postgres;

--
-- Name: siparis_sirketkodu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.siparis_sirketkodu_seq OWNED BY public.siparis.sipariskodu;


--
-- Name: sirketler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sirketler (
    sirkerid integer NOT NULL,
    sirketadi character varying(20),
    adres text,
    telefon character varying(12)
);


ALTER TABLE public.sirketler OWNER TO postgres;

--
-- Name: sirketler_sirkerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sirketler_sirkerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sirketler_sirkerid_seq OWNER TO postgres;

--
-- Name: sirketler_sirkerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sirketler_sirkerid_seq OWNED BY public.sirketler.sirkerid;


--
-- Name: urunler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urunler (
    barkodno character varying(12) NOT NULL,
    kategori integer,
    marka integer,
    "urunadı" character varying(20),
    sirketid integer,
    alisfiyat integer
);


ALTER TABLE public.urunler OWNER TO postgres;

--
-- Name: urunlerbayi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urunlerbayi (
    urunbayideid integer NOT NULL,
    urunid character varying(12),
    bayiid integer,
    miktar integer NOT NULL
);


ALTER TABLE public.urunlerbayi OWNER TO postgres;

--
-- Name: urunlerbayi_urunbayideid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.urunlerbayi_urunbayideid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.urunlerbayi_urunbayideid_seq OWNER TO postgres;

--
-- Name: urunlerbayi_urunbayideid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.urunlerbayi_urunbayideid_seq OWNED BY public.urunlerbayi.urunbayideid;


--
-- Name: depo depoid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depo ALTER COLUMN depoid SET DEFAULT nextval('public.depo_depoid_seq'::regclass);


--
-- Name: fatura faturaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura ALTER COLUMN faturaid SET DEFAULT nextval('public.fatura_faturaid_seq'::regclass);


--
-- Name: il ilid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il ALTER COLUMN ilid SET DEFAULT nextval('public.il_ilid_seq'::regclass);


--
-- Name: ilce ilceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce ALTER COLUMN ilceid SET DEFAULT nextval('public.ilce_ilceid_seq'::regclass);


--
-- Name: kargosirket sirketid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kargosirket ALTER COLUMN sirketid SET DEFAULT nextval('public.kargosirket_sirketid_seq'::regclass);


--
-- Name: kategoriler kategoriid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kategoriler ALTER COLUMN kategoriid SET DEFAULT nextval('public.kategoriler_kategoriid_seq'::regclass);


--
-- Name: markalar markaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.markalar ALTER COLUMN markaid SET DEFAULT nextval('public.markalar_markaid_seq'::regclass);


--
-- Name: medenihal medeniid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medenihal ALTER COLUMN medeniid SET DEFAULT nextval('public.medenihal_medeniid_seq'::regclass);


--
-- Name: personel personelid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel ALTER COLUMN personelid SET DEFAULT nextval('public.personel_personelid_seq'::regclass);


--
-- Name: personelyakini personeyakinilid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personelyakini ALTER COLUMN personeyakinilid SET DEFAULT nextval('public.personelyakini_personeyakinilid_seq'::regclass);


--
-- Name: silinensiparis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silinensiparis ALTER COLUMN id SET DEFAULT nextval('public.silinensiparis_id_seq'::regclass);


--
-- Name: siparis sipariskodu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis ALTER COLUMN sipariskodu SET DEFAULT nextval('public.siparis_sirketkodu_seq'::regclass);


--
-- Name: sirketler sirkerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sirketler ALTER COLUMN sirkerid SET DEFAULT nextval('public.sirketler_sirkerid_seq'::regclass);


--
-- Name: urunlerbayi urunbayideid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunlerbayi ALTER COLUMN urunbayideid SET DEFAULT nextval('public.urunlerbayi_urunbayideid_seq'::regclass);


--
-- Data for Name: depo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.depo VALUES
	(1, 2, 5);


--
-- Data for Name: fatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fatura VALUES
	(1, NULL);


--
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.il VALUES
	(1, 'tokat'),
	(2, 'sivas');


--
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ilce VALUES
	(1, 'şarkışla', NULL),
	(2, 'merkez', NULL);


--
-- Data for Name: kargosirket; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kargosirket VALUES
	(1, 'yurtiçi'),
	(2, 'surat');


--
-- Data for Name: kategoriler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kategoriler VALUES
	(1, 'bilgisayar'),
	(2, 'mutfakeşyası'),
	(3, 'makina');


--
-- Data for Name: markalar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.markalar VALUES
	(1, 'samsung'),
	(2, 'monster'),
	(3, 'karaca');


--
-- Data for Name: medenihal; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medenihal VALUES
	(1, 'evli'),
	(3, 'bekar'),
	(4, 'boşanmış'),
	(5, 'dul');


--
-- Data for Name: musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.musteri VALUES
	('11111111111', 'hakanahmet', '111111111111', 'bla,blabla', '@hotmail'),
	('22222222222', 'dewdadwdw', '222222222222', 'bla,blabla', '@mail.com.tr');


--
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.personel VALUES
	(1, 'turgut', 1, 1, '1989-03-14', NULL),
	(3, 'fatih', 3, 1, '1998-03-14', NULL),
	(4, 'izelyılmaz', 1, 1, NULL, NULL),
	(5, 'izelyılmaz', 1, 1, NULL, NULL),
	(6, 'izelyılmaz', 1, 1, NULL, NULL),
	(7, 'izelyılmaz', 1, 1, NULL, NULL),
	(10, 'izelyılmaz', 1, 1, NULL, 2300);


--
-- Data for Name: personelyakini; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: silinensiparis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.silinensiparis VALUES
	(1, '5000', 20),
	(4, '5000', 20),
	(5, 'wdd', 200);


--
-- Data for Name: siparis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.siparis VALUES
	('5000', '22222222222', 1, 1, 1, 54, 15, 5875);


--
-- Data for Name: sirketler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sirketler VALUES
	(1, 'hakanholding', 'blalbla', '05487288');


--
-- Data for Name: urunler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.urunler VALUES
	('22222', 1, 1, 'fx154', 1, NULL),
	('wdwd', 1, 1, 'adw', 1, NULL),
	('1111', 1, 1, 'hakan', 1, NULL),
	('1202', 1, 1, '22', 1, NULL),
	('2222', 1, 1, 'wd', 1, NULL),
	('45', 1, 1, 'wd', 1, NULL),
	('wd', 1, 1, 'www', 1, NULL),
	('wdd', 1, 1, '22', 1, NULL),
	('5000', 1, 1, 'dell', 1, NULL),
	('', 1, 1, '', 1, NULL),
	('485', 1, 1, 'hakan', 1, NULL);


--
-- Data for Name: urunlerbayi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.urunlerbayi VALUES
	(1, 'wdd', 1, 200),
	(3, '485', 1, 5878),
	(2, '5000', 1, 1876);


--
-- Name: depo_depoid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.depo_depoid_seq', 1, true);


--
-- Name: fatura_faturaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fatura_faturaid_seq', 1, true);


--
-- Name: il_ilid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.il_ilid_seq', 2, true);


--
-- Name: ilce_ilceid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ilce_ilceid_seq', 2, true);


--
-- Name: kargosirket_sirketid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kargosirket_sirketid_seq', 2, true);


--
-- Name: kategoriler_kategoriid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kategoriler_kategoriid_seq', 3, true);


--
-- Name: markalar_markaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.markalar_markaid_seq', 3, true);


--
-- Name: medenihal_medeniid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medenihal_medeniid_seq', 5, true);


--
-- Name: personel_personelid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_personelid_seq', 10, true);


--
-- Name: personelyakini_personeyakinilid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personelyakini_personeyakinilid_seq', 1, false);


--
-- Name: silinensiparis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.silinensiparis_id_seq', 5, true);


--
-- Name: siparis_sirketkodu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.siparis_sirketkodu_seq', 15, true);


--
-- Name: sirketler_sirkerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sirketler_sirkerid_seq', 1, true);


--
-- Name: urunlerbayi_urunbayideid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.urunlerbayi_urunbayideid_seq', 3, true);


--
-- Name: depo depo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depo
    ADD CONSTRAINT depo_pkey PRIMARY KEY (depoid);


--
-- Name: fatura fatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT fatura_pkey PRIMARY KEY (faturaid);


--
-- Name: il il_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pkey PRIMARY KEY (ilid);


--
-- Name: ilce ilce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pkey PRIMARY KEY (ilceid);


--
-- Name: kargosirket kargosirket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kargosirket
    ADD CONSTRAINT kargosirket_pkey PRIMARY KEY (sirketid);


--
-- Name: kategoriler kategoriler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kategoriler
    ADD CONSTRAINT kategoriler_pkey PRIMARY KEY (kategoriid);


--
-- Name: markalar markalar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.markalar
    ADD CONSTRAINT markalar_pkey PRIMARY KEY (markaid);


--
-- Name: medenihal medenihal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medenihal
    ADD CONSTRAINT medenihal_pkey PRIMARY KEY (medeniid);


--
-- Name: musteri musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (tc);


--
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personelid);


--
-- Name: personelyakini personelyakini_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personelyakini
    ADD CONSTRAINT personelyakini_pkey PRIMARY KEY (personeyakinilid);


--
-- Name: silinensiparis silinensiparis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silinensiparis
    ADD CONSTRAINT silinensiparis_pkey PRIMARY KEY (id);


--
-- Name: siparis sipariskodu_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT sipariskodu_pk PRIMARY KEY (sipariskodu);


--
-- Name: sirketler sirketler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sirketler
    ADD CONSTRAINT sirketler_pkey PRIMARY KEY (sirkerid);


--
-- Name: urunler urunler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunler
    ADD CONSTRAINT urunler_pkey PRIMARY KEY (barkodno);


--
-- Name: urunlerbayi urunlerbayi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunlerbayi
    ADD CONSTRAINT urunlerbayi_pkey PRIMARY KEY (urunbayideid);


--
-- Name: fki_barkod_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_barkod_frkey ON public.siparis USING btree (barkodno);


--
-- Name: fki_d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_d ON public.siparis USING btree (faturaid);


--
-- Name: fki_depo_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_depo_frkey ON public.personel USING btree (depoid);


--
-- Name: fki_il_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_il_frkey ON public.ilce USING btree (ilid);


--
-- Name: fki_ilceid_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_ilceid_frkey ON public.depo USING btree (ilceid);


--
-- Name: fki_kargoid_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kargoid_frkey ON public.siparis USING btree (kargoid);


--
-- Name: fki_kategoriid_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kategoriid_frkey ON public.urunler USING btree (kategori);


--
-- Name: fki_markalar_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_markalar_frkey ON public.urunler USING btree (marka);


--
-- Name: fki_musteri_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_musteri_frkey ON public.siparis USING btree (musteriid);


--
-- Name: fki_personelid_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_personelid_frkey ON public.siparis USING btree (personelid);


--
-- Name: fki_personelmedeni_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_personelmedeni_frkey ON public.personel USING btree (medenihali);


--
-- Name: fki_personelyakini; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_personelyakini ON public.personelyakini USING btree (personelid);


--
-- Name: fki_sirketler_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_sirketler_frkey ON public.urunler USING btree (sirketid);


--
-- Name: fki_urunlerid_frkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_urunlerid_frkey ON public.urunlerbayi USING btree (urunid);


--
-- Name: fki_v; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_v ON public.urunlerbayi USING btree (bayiid);


--
-- Name: personel personelmaas; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER personelmaas AFTER INSERT ON public.personel FOR EACH ROW EXECUTE PROCEDURE public.maas();


--
-- Name: siparis stoktrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stoktrig AFTER INSERT ON public.siparis FOR EACH ROW EXECUTE PROCEDURE public.stok();


--
-- Name: silinensiparis trigsilinensiparis; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigsilinensiparis AFTER INSERT ON public.silinensiparis FOR EACH ROW EXECUTE PROCEDURE public.silinensiparis();


--
-- Name: personel trigtoplampersonel; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigtoplampersonel AFTER INSERT ON public.personel FOR EACH ROW EXECUTE PROCEDURE public.toplampersonel();


--
-- Name: siparis barkod_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT barkod_frkey FOREIGN KEY (barkodno) REFERENCES public.urunler(barkodno) NOT VALID;


--
-- Name: urunlerbayi bayiid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunlerbayi
    ADD CONSTRAINT bayiid_frkey FOREIGN KEY (bayiid) REFERENCES public.depo(depoid) NOT VALID;


--
-- Name: personel depo_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT depo_frkey FOREIGN KEY (depoid) REFERENCES public.depo(depoid) NOT VALID;


--
-- Name: siparis fatura_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT fatura_frkey FOREIGN KEY (faturaid) REFERENCES public.fatura(faturaid) NOT VALID;


--
-- Name: ilce il_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT il_frkey FOREIGN KEY (ilid) REFERENCES public.il(ilid) NOT VALID;


--
-- Name: depo ilceid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depo
    ADD CONSTRAINT ilceid_frkey FOREIGN KEY (ilceid) REFERENCES public.ilce(ilceid) NOT VALID;


--
-- Name: siparis kargoid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT kargoid_frkey FOREIGN KEY (kargoid) REFERENCES public.kargosirket(sirketid) NOT VALID;


--
-- Name: urunler kategoriid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunler
    ADD CONSTRAINT kategoriid_frkey FOREIGN KEY (kategori) REFERENCES public.kategoriler(kategoriid) NOT VALID;


--
-- Name: urunler markalar_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunler
    ADD CONSTRAINT markalar_frkey FOREIGN KEY (marka) REFERENCES public.markalar(markaid) NOT VALID;


--
-- Name: siparis musteri_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT musteri_frkey FOREIGN KEY (musteriid) REFERENCES public.musteri(tc) NOT VALID;


--
-- Name: siparis personelid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT personelid_frkey FOREIGN KEY (personelid) REFERENCES public.personel(personelid) NOT VALID;


--
-- Name: personel personelmedeni_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personelmedeni_frkey FOREIGN KEY (medenihali) REFERENCES public.medenihal(medeniid) NOT VALID;


--
-- Name: personelyakini personelyakini; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personelyakini
    ADD CONSTRAINT personelyakini FOREIGN KEY (personelid) REFERENCES public.personel(personelid) NOT VALID;


--
-- Name: urunler sirketler_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunler
    ADD CONSTRAINT sirketler_frkey FOREIGN KEY (sirketid) REFERENCES public.sirketler(sirkerid) NOT VALID;


--
-- Name: urunlerbayi urunlerid_frkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urunlerbayi
    ADD CONSTRAINT urunlerid_frkey FOREIGN KEY (urunid) REFERENCES public.urunler(barkodno) NOT VALID;


--
-- PostgreSQL database dump complete
--

