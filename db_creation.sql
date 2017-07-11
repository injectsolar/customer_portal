--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

-- Started on 2017-07-12 00:06:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = ON;
SET check_function_bodies = FALSE;
SET client_min_messages = WARNING;
SET row_security = OFF;

--
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2217 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 197 (class 1255 OID 16679)
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_modified_column()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column()
OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = FALSE;

--
-- TOC entry 194 (class 1259 OID 16795)
-- Name: device_ids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE device_ids (
  id            INTEGER               NOT NULL,
  device_id_str CHARACTER VARYING(75) NOT NULL,
  users_id      INTEGER
);


ALTER TABLE device_ids OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 16793)
-- Name: device_ids_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_ids_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE device_ids_id_seq OWNER TO postgres;

--
-- TOC entry 2218 (class 0 OID 0)
-- Dependencies: 193
-- Name: device_ids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_ids_id_seq OWNED BY device_ids.id;


--
-- TOC entry 196 (class 1259 OID 16820)
-- Name: epc_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE epc_users (
  id                         INTEGER                                NOT NULL,
  users_id                   INTEGER                                NOT NULL,
  company_email              CHARACTER VARYING(50)                  NOT NULL,
  company_name               CHARACTER VARYING(100)                 NOT NULL,
  company_website            CHARACTER VARYING(100)                 NOT NULL,
  company_address            CHARACTER VARYING(300)                 NOT NULL,
  company_contact            CHARACTER VARYING(50)                  NOT NULL,
  contact_person_name        CHARACTER VARYING(150)                 NOT NULL,
  contact_person_designation CHARACTER VARYING(100)                 NOT NULL,
  contact_person_email       CHARACTER VARYING(100)                 NOT NULL,
  contact_person_phone       CHARACTER VARYING(50)                  NOT NULL,
  created_at                 TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  updated_at                 TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);


ALTER TABLE epc_users OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 16818)
-- Name: epc_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE epc_users_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE epc_users_id_seq OWNER TO postgres;

--
-- TOC entry 2219 (class 0 OID 0)
-- Dependencies: 195
-- Name: epc_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE epc_users_id_seq OWNED BY epc_users.id;


--
-- TOC entry 192 (class 1259 OID 16747)
-- Name: password_change_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE password_change_requests (
  id         INTEGER                                                                                        NOT NULL,
  users_id   INTEGER                                                                                        NOT NULL,
  token      CHARACTER VARYING(150)                                                                         NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()                                                         NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()                                                         NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (now() + ((24) :: DOUBLE PRECISION * '01:00:00' :: INTERVAL)) NOT NULL
);


ALTER TABLE password_change_requests OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 16745)
-- Name: password_change_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE password_change_requests_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE password_change_requests_id_seq OWNER TO postgres;

--
-- TOC entry 2220 (class 0 OID 0)
-- Dependencies: 191
-- Name: password_change_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE password_change_requests_id_seq OWNED BY password_change_requests.id;


--
-- TOC entry 186 (class 1259 OID 16682)
-- Name: people_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE people_details (
  email             CHARACTER VARYING(50)                  NOT NULL,
  id                INTEGER                                NOT NULL,
  password          CHARACTER VARYING(100)                 NOT NULL,
  username          CHARACTER VARYING(100)                 NOT NULL,
  role_str          INTEGER DEFAULT 0                      NOT NULL,
  is_email_verified BOOLEAN DEFAULT FALSE                  NOT NULL,
  created_at        TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  updated_at        TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  epc_users_id      INTEGER
);


ALTER TABLE people_details OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16680)
-- Name: people_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE people_details_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE people_details_id_seq OWNER TO postgres;

--
-- TOC entry 2221 (class 0 OID 0)
-- Dependencies: 185
-- Name: people_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE people_details_id_seq OWNED BY people_details.id;


--
-- TOC entry 188 (class 1259 OID 16714)
-- Name: server_key_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE server_key_values (
  key_str    CHARACTER VARYING(200)                 NOT NULL,
  value_str  CHARACTER VARYING(200)                 NOT NULL,
  id         INTEGER                                NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);


ALTER TABLE server_key_values OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16712)
-- Name: server_key_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE server_key_values_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE server_key_values_id_seq OWNER TO postgres;

--
-- TOC entry 2222 (class 0 OID 0)
-- Dependencies: 187
-- Name: server_key_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE server_key_values_id_seq OWNED BY server_key_values.id;


--
-- TOC entry 190 (class 1259 OID 16727)
-- Name: users_verification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_verification (
  id         INTEGER                                                                                        NOT NULL,
  users_id   INTEGER                                                                                        NOT NULL,
  token      CHARACTER VARYING(150)                                                                         NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()                                                         NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()                                                         NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (now() + ((24) :: DOUBLE PRECISION * '01:00:00' :: INTERVAL)) NOT NULL
);


ALTER TABLE users_verification OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16725)
-- Name: users_verification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_verification_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


ALTER TABLE users_verification_id_seq OWNER TO postgres;

--
-- TOC entry 2223 (class 0 OID 0)
-- Dependencies: 189
-- Name: users_verification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_verification_id_seq OWNED BY users_verification.id;


--
-- TOC entry 2049 (class 2604 OID 16798)
-- Name: device_ids id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_ids ALTER COLUMN id SET DEFAULT nextval('device_ids_id_seq' :: REGCLASS);


--
-- TOC entry 2050 (class 2604 OID 16823)
-- Name: epc_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY epc_users ALTER COLUMN id SET DEFAULT nextval('epc_users_id_seq' :: REGCLASS);


--
-- TOC entry 2045 (class 2604 OID 16750)
-- Name: password_change_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY password_change_requests ALTER COLUMN id SET DEFAULT nextval(
    'password_change_requests_id_seq' :: REGCLASS);


--
-- TOC entry 2033 (class 2604 OID 16685)
-- Name: people_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people_details ALTER COLUMN id SET DEFAULT nextval('people_details_id_seq' :: REGCLASS);


--
-- TOC entry 2038 (class 2604 OID 16717)
-- Name: server_key_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY server_key_values ALTER COLUMN id SET DEFAULT nextval('server_key_values_id_seq' :: REGCLASS);


--
-- TOC entry 2041 (class 2604 OID 16730)
-- Name: users_verification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_verification ALTER COLUMN id SET DEFAULT nextval('users_verification_id_seq' :: REGCLASS);


--
-- TOC entry 2076 (class 2606 OID 16802)
-- Name: device_ids device_id_str_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_ids
ADD CONSTRAINT device_id_str_unique UNIQUE (device_id_str);


--
-- TOC entry 2054 (class 2606 OID 16693)
-- Name: people_details email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people_details
ADD CONSTRAINT email_unique UNIQUE (email);


--
-- TOC entry 2079 (class 2606 OID 16800)
-- Name: device_ids id_device_ids_primary_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_ids
ADD CONSTRAINT id_device_ids_primary_key PRIMARY KEY (id);


--
-- TOC entry 2083 (class 2606 OID 16830)
-- Name: epc_users id_epc_users_primary_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY epc_users
ADD CONSTRAINT id_epc_users_primary_key PRIMARY KEY (id);


--
-- TOC entry 2058 (class 2606 OID 16691)
-- Name: people_details id_primary_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people_details
ADD CONSTRAINT id_primary_key PRIMARY KEY (id);


--
-- TOC entry 2071 (class 2606 OID 16755)
-- Name: password_change_requests password_change_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY password_change_requests
ADD CONSTRAINT password_change_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2074 (class 2606 OID 16757)
-- Name: password_change_requests password_change_requests_users_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY password_change_requests
ADD CONSTRAINT password_change_requests_users_id_key UNIQUE (users_id);


--
-- TOC entry 2062 (class 2606 OID 16723)
-- Name: server_key_values server_key_values_key_str_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY server_key_values
ADD CONSTRAINT server_key_values_key_str_key UNIQUE (key_str);


--
-- TOC entry 2064 (class 2606 OID 16721)
-- Name: server_key_values server_key_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY server_key_values
ADD CONSTRAINT server_key_values_pkey PRIMARY KEY (id);


--
-- TOC entry 2060 (class 2606 OID 16695)
-- Name: people_details username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people_details
ADD CONSTRAINT username_unique UNIQUE (username);


--
-- TOC entry 2066 (class 2606 OID 16735)
-- Name: users_verification users_verification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_verification
ADD CONSTRAINT users_verification_pkey PRIMARY KEY (id);


--
-- TOC entry 2069 (class 2606 OID 16737)
-- Name: users_verification users_verification_users_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_verification
ADD CONSTRAINT users_verification_users_id_key UNIQUE (users_id);


--
-- TOC entry 2077 (class 1259 OID 16808)
-- Name: fki_device_user_id_foreign_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_device_user_id_foreign_key ON device_ids USING BTREE (users_id);


--
-- TOC entry 2080 (class 1259 OID 16836)
-- Name: fki_epc_users_id_people_details_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_epc_users_id_people_details_id ON epc_users USING BTREE (users_id);


--
-- TOC entry 2055 (class 1259 OID 16845)
-- Name: fki_poeple_details_epc_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_poeple_details_epc_users_id ON people_details USING BTREE (epc_users_id);


--
-- TOC entry 2081 (class 1259 OID 16837)
-- Name: id_epc_users_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX id_epc_users_primary ON epc_users USING BTREE (id);


--
-- TOC entry 2056 (class 1259 OID 16696)
-- Name: id_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX id_primary ON people_details USING BTREE (id);


--
-- TOC entry 2072 (class 1259 OID 16763)
-- Name: password_change_requests_users_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_change_requests_users_id_idx ON password_change_requests USING BTREE (users_id);


--
-- TOC entry 2067 (class 1259 OID 16743)
-- Name: users_verification_users_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_verification_users_id_idx ON users_verification USING BTREE (users_id);


--
-- TOC entry 2093 (class 2620 OID 16838)
-- Name: epc_users update_epc_users_updated_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_epc_users_updated_time BEFORE UPDATE ON epc_users FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- TOC entry 2092 (class 2620 OID 16764)
-- Name: password_change_requests update_password_change_requests_updated_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_password_change_requests_updated_time BEFORE UPDATE ON password_change_requests FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- TOC entry 2090 (class 2620 OID 16724)
-- Name: server_key_values update_server_key_values_updated_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_server_key_values_updated_time BEFORE UPDATE ON server_key_values FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- TOC entry 2089 (class 2620 OID 16697)
-- Name: people_details update_user_updated_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_updated_time BEFORE UPDATE ON people_details FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- TOC entry 2091 (class 2620 OID 16744)
-- Name: users_verification update_users_verification_updated_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_verification_updated_time BEFORE UPDATE ON users_verification FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- TOC entry 2087 (class 2606 OID 16803)
-- Name: device_ids device_user_id_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_ids
ADD CONSTRAINT device_user_id_foreign_key FOREIGN KEY (users_id) REFERENCES people_details (id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2088 (class 2606 OID 16851)
-- Name: epc_users fk_epc_users_users_id_people_details_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY epc_users
ADD CONSTRAINT fk_epc_users_users_id_people_details_id FOREIGN KEY (users_id) REFERENCES people_details (id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2084 (class 2606 OID 16840)
-- Name: people_details fk_poeple_details_epc_users_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY people_details
ADD CONSTRAINT fk_poeple_details_epc_users_id FOREIGN KEY (epc_users_id) REFERENCES epc_users (id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2086 (class 2606 OID 16758)
-- Name: password_change_requests password_change_requests_users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY password_change_requests
ADD CONSTRAINT password_change_requests_users_id_fkey FOREIGN KEY (users_id) REFERENCES people_details (id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2085 (class 2606 OID 16738)
-- Name: users_verification users_verification_users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_verification
ADD CONSTRAINT users_verification_users_id_fkey FOREIGN KEY (users_id) REFERENCES people_details (id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2017-07-12 00:06:14

--
-- PostgreSQL database dump complete
--

