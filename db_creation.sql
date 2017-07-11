-- Database: postgres

-- DROP DATABASE postgres;

CREATE DATABASE islr
WITH OWNER = postgres
ENCODING = 'UTF8'
TABLESPACE = pg_default
LC_COLLATE = 'English_United States.1252'
LC_CTYPE = 'English_United States.1252'
CONNECTION LIMIT = -1;

CREATE OR REPLACE FUNCTION update_modified_column()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Table: people_details

-- DROP TABLE people_details;

CREATE TABLE people_details
(
  email             CHARACTER VARYING(50)    NOT NULL,
  id                SERIAL                   NOT NULL,
  password          CHARACTER VARYING(100)   NOT NULL,
  username          CHARACTER VARYING(100)   NOT NULL,
  role              INTEGER DEFAULT 0        NOT NULL,
  is_email_verified BOOLEAN                  NOT NULL DEFAULT FALSE,
  created_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT id_primary_key PRIMARY KEY (id),
  CONSTRAINT email_unique UNIQUE (email),
  CONSTRAINT username_unique UNIQUE (username)
)
WITH (
OIDS =FALSE
);
ALTER TABLE people_details
OWNER TO postgres;

-- Index: id_primary

-- DROP INDEX id_primary;

CREATE INDEX id_primary
ON people_details
USING BTREE
(id);


-- Trigger: update_user_updated_time on people_details

-- DROP TRIGGER update_user_updated_time ON people_details;

CREATE TRIGGER update_user_updated_time
BEFORE UPDATE
ON people_details
FOR EACH ROW
EXECUTE PROCEDURE public.update_modified_column();


-- Table: public.device_ids

-- DROP TABLE public.device_ids;

CREATE TABLE public.device_ids
(
  id            SERIAL                NOT NULL,
  device_id_str CHARACTER VARYING(75) NOT NULL,
  users_id      INTEGER,
  CONSTRAINT id_device_ids_primary_key PRIMARY KEY (id),
  CONSTRAINT device_user_id_foreign_key FOREIGN KEY (users_id)
  REFERENCES public.people_details (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT device_id_str_unique UNIQUE (device_id_str)
)
WITH (
OIDS =FALSE
);
ALTER TABLE public.device_ids
OWNER TO postgres;

-- Index: public.fki_device_user_id_foreign_key

-- DROP INDEX public.fki_device_user_id_foreign_key;

CREATE INDEX fki_device_user_id_foreign_key
ON public.device_ids
USING BTREE
(users_id);


-- Table: server_key_values

-- DROP TABLE server_key_values;

CREATE TABLE server_key_values
(
  key_str    CHARACTER VARYING(200)   NOT NULL,
  value_str  CHARACTER VARYING(200)   NOT NULL,
  id         SERIAL                   NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT server_key_values_pkey PRIMARY KEY (id),
  CONSTRAINT server_key_values_key_str_key UNIQUE (key_str)
)
WITH (
OIDS =FALSE
);
ALTER TABLE server_key_values
OWNER TO postgres;

-- Trigger: update_server_key_values_updated_time on server_key_values

-- DROP TRIGGER update_server_key_values_updated_time ON server_key_values;

CREATE TRIGGER update_server_key_values_updated_time
BEFORE UPDATE
ON server_key_values
FOR EACH ROW
EXECUTE PROCEDURE public.update_modified_column();


-- Table: users_verification

-- DROP TABLE users_verification;

CREATE TABLE users_verification
(
  id         SERIAL                   NOT NULL,
  users_id   INTEGER                  NOT NULL,
  token      CHARACTER VARYING(150)   NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() + ((24) :: DOUBLE PRECISION * '01:00:00' :: INTERVAL)),
  CONSTRAINT users_verification_pkey PRIMARY KEY (id),
  CONSTRAINT users_verification_users_id_fkey FOREIGN KEY (users_id)
  REFERENCES people_details (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT users_verification_users_id_key UNIQUE (users_id)
)
WITH (
OIDS =FALSE
);
ALTER TABLE users_verification
OWNER TO postgres;

-- Index: users_verification_users_id_idx

-- DROP INDEX users_verification_users_id_idx;

CREATE INDEX users_verification_users_id_idx
ON users_verification
USING BTREE
(users_id);


-- Trigger: update_users_verification_updated_time on users_verification

-- DROP TRIGGER update_users_verification_updated_time ON users_verification;

CREATE TRIGGER update_users_verification_updated_time
BEFORE UPDATE
ON users_verification
FOR EACH ROW
EXECUTE PROCEDURE public.update_modified_column();

-- Table: password_change_requests

-- DROP TABLE password_change_requests;

CREATE TABLE password_change_requests
(
  id         SERIAL                   NOT NULL,
  users_id   INTEGER                  NOT NULL,
  token      CHARACTER VARYING(150)   NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() + ((24) :: DOUBLE PRECISION * '01:00:00' :: INTERVAL)),
  CONSTRAINT password_change_requests_pkey PRIMARY KEY (id),
  CONSTRAINT password_change_requests_users_id_fkey FOREIGN KEY (users_id)
  REFERENCES people_details (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT password_change_requests_users_id_key UNIQUE (users_id)
)
WITH (
OIDS =FALSE
);
ALTER TABLE password_change_requests
OWNER TO postgres;

-- Index: password_change_requests_users_id_idx

-- DROP INDEX password_change_requests_users_id_idx;

CREATE INDEX password_change_requests_users_id_idx
ON password_change_requests
USING BTREE
(users_id);


-- Trigger: update_password_change_requests_updated_time on password_change_requests

-- DROP TRIGGER update_password_change_requests_updated_time ON password_change_requests;

CREATE TRIGGER update_password_change_requests_updated_time
BEFORE UPDATE
ON password_change_requests
FOR EACH ROW
EXECUTE PROCEDURE public.update_modified_column();

-- Table: public.epc_users

-- DROP TABLE public.epc_users;

CREATE TABLE public.epc_users
(
  id SERIAL NOT NULL,
  users_id integer NOT NULL,
  company_email character varying(50) NOT NULL,
  company_name character varying(100) NOT NULL,
  company_website character varying(100) NOT NULL,
  company_address character varying(300) NOT NULL,
  company_contact character varying(50) NOT NULL,
  contact_person_name character varying(150) NOT NULL,
  contact_person_designation character varying(100) NOT NULL,
  contact_person_email character varying(100) NOT NULL,
  contact_person_phone character varying(50) NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT id_epc_users_primary_key PRIMARY KEY (id),
  CONSTRAINT fk_epc_users_id_people_details_id FOREIGN KEY (users_id)
  REFERENCES public.device_ids (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
OIDS=FALSE
);
ALTER TABLE public.epc_users
OWNER TO postgres;

-- Index: public.fki_epc_users_id_people_details_id

-- DROP INDEX public.fki_epc_users_id_people_details_id;

CREATE INDEX fki_epc_users_id_people_details_id
ON public.epc_users
USING btree
(users_id);

-- Index: public.id_epc_users_primary

-- DROP INDEX public.id_epc_users_primary;

CREATE INDEX id_epc_users_primary
ON public.epc_users
USING btree
(id);


-- Trigger: update_epc_users_updated_time on public.epc_users

-- DROP TRIGGER update_epc_users_updated_time ON public.epc_users;

CREATE TRIGGER update_epc_users_updated_time
BEFORE UPDATE
ON public.epc_users
FOR EACH ROW
EXECUTE PROCEDURE public.update_modified_column();