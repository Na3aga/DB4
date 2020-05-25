-- Generated by Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   at:        2020-05-25 03:05:06 EEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g


CREATE TABLE city
(
    city_name    VARCHAR2(40) NOT NULL,
    state_code   VARCHAR2(4),
    country_code VARCHAR2(4)  NOT NULL
);

ALTER TABLE city
    ADD CONSTRAINT city_pk PRIMARY KEY (city_name)
        USING INDEX;

CREATE TABLE countrycode
(
    country_code VARCHAR2(4) NOT NULL
);

ALTER TABLE countrycode
    ADD CONSTRAINT countrycode_pk PRIMARY KEY (country_code)
        USING INDEX;

CREATE TABLE investment
(
    invstid NUMBER(*, 0) NOT NULL,
    name    VARCHAR2(50) NOT NULL,
    seed    NUMBER(*, 0) NOT NULL,
    venture NUMBER(*, 0) NOT NULL
);

CREATE TABLE market
(
    market_name VARCHAR2(40) NOT NULL
);

ALTER TABLE market
    ADD CONSTRAINT market_pk PRIMARY KEY (market_name)
        USING INDEX;

CREATE TABLE startup
(
    startup_name  VARCHAR2(50)  NOT NULL,
    city          VARCHAR2(40)  NOT NULL,
    market        VARCHAR2(40)  NOT NULL,
    total_funding NUMBER(*, 0)  NOT NULL,
    website       VARCHAR2(255) NOT NULL
);

ALTER TABLE startup
    ADD CHECK ( total_funding > 0 );

ALTER TABLE startup
    ADD CONSTRAINT startup_pk PRIMARY KEY (startup_name)
        USING INDEX;

CREATE TABLE statecode
(
    state_code VARCHAR2(4) NOT NULL
);

ALTER TABLE statecode
    ADD CONSTRAINT statecode_pk PRIMARY KEY (state_code)
        USING INDEX;

ALTER TABLE city
    ADD CONSTRAINT city_countrycode_fk FOREIGN KEY (country_code)
        REFERENCES countrycode (country_code)
            NOT DEFERRABLE;

ALTER TABLE city
    ADD CONSTRAINT city_statecode_fk FOREIGN KEY (state_code)
        REFERENCES statecode (state_code)
            NOT DEFERRABLE;

ALTER TABLE investment
    ADD CONSTRAINT investment_startup_fk FOREIGN KEY (name)
        REFERENCES startup (startup_name)
            NOT DEFERRABLE;

ALTER TABLE startup
    ADD CONSTRAINT startup_city_fk FOREIGN KEY (city)
        REFERENCES city (city_name)
            NOT DEFERRABLE;

ALTER TABLE startup
    ADD CONSTRAINT startup_market_fk FOREIGN KEY (market)
        REFERENCES market (market_name)
            NOT DEFERRABLE;

ALTER TABLE investment
    ADD CONSTRAINT invst_pk PRIMARY KEY (invstid);

CREATE SEQUENCE invst_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER invst_bir
    BEFORE INSERT
    ON investment
    FOR EACH ROW

BEGIN
    SELECT invst_seq.NEXTVAL
    INTO :new.invstid
    FROM dual;
END;
/


CREATE OR REPLACE TRIGGER insertstartup
    BEFORE INSERT
    ON startup

    FOR EACH ROW

BEGIN
    IF :new.website IS NULL THEN
        :new.website := 'no_url';
    END IF;

END;
/

CREATE OR REPLACE TRIGGER insertstcity
    BEFORE INSERT
    ON city

    FOR EACH ROW
DECLARE
    any_rows_found number;

BEGIN
    IF :new.state_code IS NULL THEN
        :new.state_code := '';
    END IF;
    select count(*)
    INTO any_rows_found
    from statecode
    where statecode.state_code = ' ';
    if any_rows_found != 1 then
        INSERT INTO statecode VALUES (' ');
    end if;

END;
/


-- Oracle SQL Developer Data Modeler Summary Report:
--
-- CREATE TABLE                             6
-- CREATE INDEX                             1
-- ALTER TABLE                             12
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
--
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
--
-- REDACTION POLICY                         0
--
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
--
-- ERRORS                                   0
-- WARNINGS                                 0