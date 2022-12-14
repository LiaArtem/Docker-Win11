CREATE SCHEMA TEST_SCHEMAS AUTHORIZATION DB2INST1;

-- TEST_SCHEMAS.CURS definition

CREATE TABLE "TEST_SCHEMAS"."CURS"  (
		  "ID" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (
		    START WITH +1
		    INCREMENT BY +1
		    MINVALUE +1
		    MAXVALUE +2147483647
		    NO CYCLE
		    CACHE 20
		    NO ORDER ) ,
		  "CURS_DATE" DATE NOT NULL WITH DEFAULT CURRENT DATE ,
		  "CURR_CODE" VARCHAR(3 OCTETS) NOT NULL ,
		  "RATE" DECIMAL(22,6) )
		 IN "USERSPACE1"
		 ORGANIZE BY ROW;

COMMENT ON TABLE "TEST_SCHEMAS"."CURS" IS 'Курсы валют';

COMMENT ON COLUMN "TEST_SCHEMAS"."CURS"."CURR_CODE" IS 'Код валюты';

COMMENT ON COLUMN "TEST_SCHEMAS"."CURS"."CURS_DATE" IS 'Дата курса';

COMMENT ON COLUMN "TEST_SCHEMAS"."CURS"."ID" IS 'ID';

COMMENT ON COLUMN "TEST_SCHEMAS"."CURS"."RATE" IS 'Курс';

ALTER TABLE "TEST_SCHEMAS"."CURS"
	ADD CONSTRAINT "PK_CURS" PRIMARY KEY
		("ID")
	ENFORCED;

ALTER TABLE "TEST_SCHEMAS"."CURS"
	ADD CONSTRAINT "UK_CURS" UNIQUE
		("CURS_DATE",
		 "CURR_CODE")
	ENFORCED;

--GRANT CONTROL ON TABLE "TEST_SCHEMAS"."CURS" TO USER "DB2ADMIN";

--GRANT CONTROL ON INDEX "TEST_SCHEMAS"."PK_CURS" TO USER "DB2ADMIN";

--GRANT CONTROL ON INDEX "TEST_SCHEMAS"."UK_CURS" TO USER "DB2ADMIN";

-- TEST_SCHEMAS.CURS_AVG_YEAR source

CREATE OR REPLACE VIEW TEST_SCHEMAS.CURS_AVG_YEAR AS
  SELECT
    VARCHAR_FORMAT(k.CURS_DATE, 'YYYY') AS PART_DATE,
         k.CURR_CODE,
         AVG(k.RATE) AS AVG_RATE
FROM
    TEST_SCHEMAS.CURS k
GROUP BY
    VARCHAR_FORMAT(k.CURS_DATE, 'YYYY'),
    k.CURR_CODE;

-- TEST_SCHEMAS.CURS_REPORT source

CREATE OR REPLACE VIEW TEST_SCHEMAS.CURS_REPORT AS
WITH CURS_AVG (PART_DATE,
CURR_CODE,
AVG_RATE) AS
                (
SELECT
    f.PART_DATE AS PART_DATE,
    f.CURR_CODE AS CURR_CODE,
    AVG(f.AVG_RATE) AS AVG_RATE
FROM
    (
    SELECT
        VARCHAR_FORMAT(k.CURS_DATE, 'MM-DD') AS PART_DATE,
        k.CURR_CODE,
        (k.RATE / a.AVG_RATE)* 100 AS AVG_RATE
    FROM
        TEST_SCHEMAS.CURS k
    INNER JOIN TEST_SCHEMAS.CURS_AVG_YEAR a ON
        a.PART_DATE = VARCHAR_FORMAT(k.CURS_DATE, 'YYYY')
        AND a.CURR_CODE = k.CURR_CODE
                      ) f
GROUP BY
    f.PART_DATE,
    f.CURR_CODE
               )
 SELECT
    k.CURS_DATE,
    k.CURR_CODE,
    ROUND(k.RATE,4) AS RATE,
    VARCHAR_FORMAT(k.RATE,'99990.9999') as RATE_STR,
    a.AVG_RATE AS AVG_RATE,
    VARCHAR_FORMAT(a.AVG_RATE,'99990.9999') as AVG_RATE_STR
FROM
    TEST_SCHEMAS.CURS k
INNER JOIN CURS_AVG a ON
    a.PART_DATE = VARCHAR_FORMAT(k.CURS_DATE, 'MM-DD')
    AND a.CURR_CODE = k.CURR_CODE
WHERE
    VARCHAR_FORMAT(k.CURS_DATE, 'YYYY') IN (
    SELECT
        VARCHAR_FORMAT(MAX(kk.CURS_DATE), 'YYYY')
    FROM
        TEST_SCHEMAS.CURS kk)
    AND a.AVG_RATE <= 100;

-- TEST_SCHEMAS.INSERT_KURS source
CREATE OR replace PROCEDURE TEST_SCHEMAS.INSERT_KURS
(
 IN P_KURS_DATE VARCHAR(255),
 IN P_CURRENCY_CODE VARCHAR(3),
 IN P_RATE DECIMAL(22, 6)
)
LANGUAGE SQL
MODIFIES SQL DATA
   INSERT
   INTO    TEST_SCHEMAS.curs (CURS_DATE,
   CURR_CODE,
   RATE)
	     SELECT
   TO_DATE(P_KURS_DATE, 'YYYY-MM-DD'),
               P_CURRENCY_CODE,
               P_RATE
FROM    SYSIBM.SYSDUMMY1
WHERE    NOT EXISTS (
   SELECT
       1
   FROM        TEST_SCHEMAS.curs c
   WHERE        c.curs_date = TO_DATE(P_KURS_DATE, 'YYYY-MM-DD')
           AND c.curr_code = P_CURRENCY_CODE);

CREATE TABLE DB2INST1.COUNTRY (
		  ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1 MINVALUE +1 MAXVALUE +2147483647 NO CYCLE CACHE 20 NO ORDER),
		  NAME VARCHAR(255) NULL,
CONSTRAINT PK_COUNTRY PRIMARY KEY (ID));

CREATE TABLE DB2INST1.USERSDATA (
		  ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1 INCREMENT BY +1 MINVALUE +1 MAXVALUE +2147483647 NO CYCLE CACHE 20 NO ORDER),
		  ROWVERSION timestamp NULL,
		  TEXTVALUE VARCHAR(255) NULL,
		  INTVALUE INTEGER NULL,
		  DOUBLEVALUE DOUBLE PRECISION NULL,
		  BOOLVALUE BOOLEAN NULL,
		  DATEVALUE DATE NULL,
CONSTRAINT PK_USERSDATA PRIMARY KEY (ID));