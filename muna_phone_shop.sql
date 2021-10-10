--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Ubuntu 13.4-4.pgdg20.04+1)
-- Dumped by pg_dump version 14.0 (Ubuntu 14.0-1.pgdg20.04+1)

-- Started on 2021-10-10 22:31:43 WAT

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 17201)
-- Name: boot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boot (
    seller_id integer NOT NULL,
    firstname character varying(200) NOT NULL,
    lastname character varying(200) NOT NULL,
    manufacturer character varying(100)
);


ALTER TABLE public.boot OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 17199)
-- Name: boot_seller_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boot_seller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boot_seller_id_seq OWNER TO postgres;

--
-- TOC entry 3050 (class 0 OID 0)
-- Dependencies: 202
-- Name: boot_seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boot_seller_id_seq OWNED BY public.boot.seller_id;


--
-- TOC entry 201 (class 1259 OID 17173)
-- Name: smartphones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.smartphones (
    phone_id integer NOT NULL,
    manufacturer character varying(150),
    model character varying(350) NOT NULL,
    release_year integer,
    memory integer NOT NULL,
    storage integer NOT NULL,
    amount numeric NOT NULL
);


ALTER TABLE public.smartphones OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 17225)
-- Name: consolidated_tables; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.consolidated_tables AS
 SELECT b1.seller_id,
    b1.firstname,
    b1.lastname,
    lower((("left"((b1.firstname)::text, 2) || (b1.lastname)::text) || 'gmail.com'::text)) AS email,
    s1.manufacturer,
    s1.model,
    s1.release_year,
    s1.storage,
    s1.memory,
    s1.amount
   FROM (public.boot b1
     RIGHT JOIN public.smartphones s1 ON (((b1.manufacturer)::text = (s1.manufacturer)::text)));


ALTER TABLE public.consolidated_tables OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 17242)
-- Name: count_of_model; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.count_of_model AS
 SELECT count(DISTINCT consolidated_tables.model) AS count
   FROM public.consolidated_tables;


ALTER TABLE public.count_of_model OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 17246)
-- Name: list_of_model; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.list_of_model AS
 SELECT DISTINCT consolidated_tables.model
   FROM public.consolidated_tables;


ALTER TABLE public.list_of_model OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 17210)
-- Name: modified_boot; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.modified_boot AS
 SELECT b1.seller_id,
    b1.firstname,
    b1.lastname,
    lower((("left"((b1.firstname)::text, 2) || (b1.lastname)::text) || 'gmail.com'::text)) AS email,
    s1.manufacturer,
    s1.model,
    s1.release_year,
    s1.storage,
    s1.memory,
    s1.amount AS price
   FROM (public.boot b1
     RIGHT JOIN public.smartphones s1 ON (((b1.manufacturer)::text = (s1.manufacturer)::text)));


ALTER TABLE public.modified_boot OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 17221)
-- Name: phone_counts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.phone_counts AS
 SELECT sum(
        CASE smartphones.manufacturer
            WHEN 'Nokia'::text THEN 1
            ELSE 0
        END) AS count_of_nokia,
    sum(
        CASE smartphones.manufacturer
            WHEN 'Samsung'::text THEN 1
            ELSE 0
        END) AS count_of_samsung
   FROM public.smartphones;


ALTER TABLE public.phone_counts OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 17217)
-- Name: price_by_year; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.price_by_year AS
 SELECT modified_boot.release_year,
    sum(modified_boot.price) AS sum
   FROM public.modified_boot
  GROUP BY modified_boot.release_year
  ORDER BY modified_boot.release_year;


ALTER TABLE public.price_by_year OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 17238)
-- Name: rewards; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rewards AS
 SELECT consolidated_tables.firstname,
    consolidated_tables.lastname,
    sum(consolidated_tables.amount) AS sum,
        CASE
            WHEN (sum(consolidated_tables.amount) >= (1000000)::numeric) THEN 'Gold'::text
            ELSE 'Bronze'::text
        END AS "case"
   FROM public.consolidated_tables
  GROUP BY consolidated_tables.firstname, consolidated_tables.lastname
  ORDER BY (sum(consolidated_tables.amount)) DESC;


ALTER TABLE public.rewards OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 17230)
-- Name: sale_by_year; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sale_by_year AS
 SELECT consolidated_tables.release_year,
    sum(consolidated_tables.amount) AS total_sales
   FROM public.consolidated_tables
  GROUP BY consolidated_tables.release_year
  ORDER BY consolidated_tables.release_year;


ALTER TABLE public.sale_by_year OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 17171)
-- Name: smartphones_phone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.smartphones_phone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.smartphones_phone_id_seq OWNER TO postgres;

--
-- TOC entry 3051 (class 0 OID 0)
-- Dependencies: 200
-- Name: smartphones_phone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.smartphones_phone_id_seq OWNED BY public.smartphones.phone_id;


--
-- TOC entry 209 (class 1259 OID 17234)
-- Name: total_sales_by_salesman; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_sales_by_salesman AS
 SELECT consolidated_tables.firstname,
    consolidated_tables.lastname,
    sum(consolidated_tables.amount) AS total_sale
   FROM public.consolidated_tables
  GROUP BY consolidated_tables.firstname, consolidated_tables.lastname;


ALTER TABLE public.total_sales_by_salesman OWNER TO postgres;

--
-- TOC entry 2901 (class 2604 OID 17250)
-- Name: boot seller_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boot ALTER COLUMN seller_id SET DEFAULT nextval('public.boot_seller_id_seq'::regclass);


--
-- TOC entry 2900 (class 2604 OID 17251)
-- Name: smartphones phone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smartphones ALTER COLUMN phone_id SET DEFAULT nextval('public.smartphones_phone_id_seq'::regclass);


--
-- TOC entry 2905 (class 2606 OID 17209)
-- Name: boot boot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boot
    ADD CONSTRAINT boot_pkey PRIMARY KEY (seller_id);


--
-- TOC entry 2903 (class 2606 OID 17181)
-- Name: smartphones smartphones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smartphones
    ADD CONSTRAINT smartphones_pkey PRIMARY KEY (phone_id);


-- Completed on 2021-10-10 22:31:43 WAT

--
-- PostgreSQL database dump complete
--

