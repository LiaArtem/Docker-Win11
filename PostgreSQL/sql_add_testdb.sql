
CREATE EXTENSION plpython3u;
CREATE EXTENSION pldbgapi;

-- SCHEMA: test_schemas
-- DROP SCHEMA IF EXISTS test_schemas ;

CREATE SCHEMA IF NOT EXISTS test_schemas
    AUTHORIZATION testdb;

--------------------------------------------------------------------------
-- Table: test_schemas.curs
-- DROP TABLE IF EXISTS test_schemas.curs;

CREATE TABLE IF NOT EXISTS test_schemas.curs
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    curs_date date NOT NULL,
    curr_code character varying(3) COLLATE pg_catalog."default" NOT NULL,
    rate numeric,
    CONSTRAINT pk_curs PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS test_schemas.curs
    OWNER to testdb;

COMMENT ON TABLE test_schemas.curs
    IS 'Курсы валют';

COMMENT ON COLUMN test_schemas.curs.id
    IS 'ID';

COMMENT ON COLUMN test_schemas.curs.curs_date
    IS 'Дата курса';

COMMENT ON COLUMN test_schemas.curs.curr_code
    IS 'Код валюты';

COMMENT ON COLUMN test_schemas.curs.rate
    IS 'Курс';

-- Index: uk_curs
-- DROP INDEX IF EXISTS test_schemas.uk_curs;

CREATE UNIQUE INDEX IF NOT EXISTS uk_curs
    ON test_schemas.curs USING btree
    (curs_date ASC NULLS LAST, curr_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- View: test_schemas.view_kurs_report
-- DROP VIEW test_schemas.view_kurs_report;

CREATE OR REPLACE VIEW test_schemas.view_kurs_report
 AS
 WITH curs_avg_year(part_date_year, curr_code, avg_rate) AS (
         SELECT to_char(k_1.curs_date::timestamp with time zone, 'YYYY'::text) AS part_date_year,
            k_1.curr_code,
            avg(k_1.rate) AS avg_rate
           FROM test_schemas.curs k_1
          GROUP BY (to_char(k_1.curs_date::timestamp with time zone, 'YYYY'::text)), k_1.curr_code
        ), curs_avg(part_day_month, curr_code, avg_rate) AS (
         SELECT f.part_day_month,
            f.curr_code,
            avg(f.avg_rate) AS avg_rate
           FROM ( SELECT to_char(k_1.curs_date::timestamp with time zone, 'MM-DD'::text) AS part_day_month,
                    k_1.curr_code,
                    k_1.rate / a_1.avg_rate * 100::numeric AS avg_rate
                   FROM test_schemas.curs k_1
                     JOIN curs_avg_year a_1 ON a_1.part_date_year = to_char(k_1.curs_date::timestamp with time zone, 'YYYY'::text) AND a_1.curr_code::text = k_1.curr_code::text) f
          GROUP BY f.part_day_month, f.curr_code
        )
 SELECT k.curs_date,
    k.curr_code,
    k.rate,
    a.avg_rate
   FROM test_schemas.curs k
     JOIN curs_avg a ON a.part_day_month = to_char(k.curs_date::timestamp with time zone, 'MM-DD'::text) AND a.curr_code::text = k.curr_code::text
  WHERE (to_char(k.curs_date::timestamp with time zone, 'YYYY'::text) IN ( SELECT to_char(max(kk.curs_date)::timestamp with time zone, 'YYYY'::text) AS to_char
           FROM test_schemas.curs kk))
  ORDER BY k.curs_date;

ALTER TABLE test_schemas.view_kurs_report
    OWNER TO testdb;

-- PROCEDURE: test_schemas.insert_curs(character varying, character varying, double precision)
-- DROP PROCEDURE IF EXISTS test_schemas.insert_curs(character varying, character varying, double precision);

CREATE OR REPLACE PROCEDURE test_schemas.insert_curs(
	IN p_curs_date character varying,
	IN p_curr_code character varying,
	IN p_rate double precision)
LANGUAGE 'sql'
AS $BODY$

	   INSERT INTO test_schemas.curs (CURS_DATE, CURR_CODE, RATE)
	       SELECT TO_DATE(p_curs_date, 'YYYY-MM-DD'), p_curr_code, p_rate
	       WHERE NOT EXISTS (SELECT 1 FROM test_schemas.curs c where c.curs_date = TO_DATE(p_curs_date, 'YYYY-MM-DD') and c.curr_code = p_curr_code);
$BODY$;

--------------------------------------------------------------------------
-- DROP SCHEMA p_check;

CREATE SCHEMA p_check AUTHORIZATION testdb;

CREATE OR REPLACE FUNCTION p_check.is_valid_json(p_text text)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
      -- Проверка валидности JSON
      p_json json;

begin
        p_json := p_text::json;
        return 'T';
    exception when others
    then
        return 'F';
    end;	        
    
$function$
;

CREATE OR REPLACE FUNCTION p_check.is_valid_xml(p_text text)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
		-- Проверка валидности XML
        p_xml xml;

BEGIN
        p_xml := p_text::xml;
        return 'T';
    exception when others
    then
        return 'F';
    end;

$function$
;

--------------------------------------------------------------------------
-- DROP SCHEMA p_convert;

CREATE SCHEMA p_convert AUTHORIZATION testdb;

CREATE OR REPLACE FUNCTION p_convert.base64_decode(p_value text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
  -- Преобразование из base64
    m_result text;
begin
    if p_value is null then return null; end if;      
    select convert_from(decode(p_value, 'base64'), 'UTF8') into STRICT m_result;
    return m_result;
  end;
$function$
;

CREATE OR REPLACE FUNCTION p_convert.base64_encode(p_value text)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
  -- Преобразование в base64
    m_result text;
begin
    if p_value is null then return null; end if;    
    select encode(p_value::bytea, 'base64') into STRICT m_result;
    return m_result;
  end;

$function$
;

CREATE OR REPLACE FUNCTION p_convert.convert_str(p_text text, p_char_set_to character varying, p_char_set_from character varying)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
begin
   -- Преобразование теста из одной в другую кодировку
   -- 'UTF8','WIN1251'	
      return convert_from(convert(p_text::bytea, p_char_set_from, p_char_set_to), 'UTF8'); 
  end;   
$function$
;

CREATE OR REPLACE FUNCTION p_convert.get_datetime(p_text text)
 RETURNS timestamp without time zone
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование текста в дату и время
    m_date timestamp;

BEGIN
     if p_text in ('null', 'nul') then return null; end if;

     if length(p_text) > 20
     then
         select max(cast(TO_TIMESTAMP(p_text, 'YYYY-MM-DD"T"hh24:mi:ss.FF9"Z"') AS timestamp)) into STRICT m_date;
        
     elsif length(p_text) = 20
     then
         select max(cast(TO_TIMESTAMP(p_text, 'YYYY-MM-DD"T"hh24:mi:ss"Z"') AS timestamp)) into STRICT m_date;
        
     elsif length(p_text) = 17
     then
         select max(cast(TO_TIMESTAMP(p_text, 'YYYY-MM-DD"T"hh24:mi"Z"') AS timestamp)) into STRICT m_date;
        
     end if;

     return m_date;
  exception
     when others then
        return null;
  end;

$function$
;

create or replace function p_convert.num_spelled_int (
  n numeric,
  g char,
  d text[]
) returns text
language plpgsql as $BODY$
declare
  r text;
  s text[];
begin
  r := ltrim(to_char(n, '9,9,,9,,,,,,9,9,,9,,,,,9,9,,9,,,,9,9,,9,,,.')) || '.';

  if array_upper(d,1) = 1 and d[1] is not null then
    s := array[ d[1], d[1], d[1] ];
  else
    s := array[ coalesce(d[1],''), coalesce(d[2],''), coalesce(d[3],'') ];
  end if;

  --t - тысячи; m - милионы; M - миллиарды;
  r := replace( r, ',,,,,,', 'eM');
  r := replace( r, ',,,,,', 'em');
  r := replace( r, ',,,,', 'et');
  --e - единицы; d - десятки; c - сотни;
  r := replace( r, ',,,', 'e');
  r := replace( r, ',,', 'd');
  r := replace( r, ',', 'c');
  --удаление незначащих нулей
  r := replace( r, '0c0d0et', '');
  r := replace( r, '0c0d0em', '');
  r := replace( r, '0c0d0eM', '');

  --сотни
  r := replace( r, '0c', '');
  r := replace( r, '1c', 'сто ');
  r := replace( r, '2c', 'двести ');
  r := replace( r, '3c', 'триста ');
  r := replace( r, '4c', 'четыреста ');
  r := replace( r, '5c', 'пятьсот ');
  r := replace( r, '6c', 'шестьсот ');
  r := replace( r, '7c', 'семьсот ');
  r := replace( r, '8c', 'восемьсот ');
  r := replace( r, '9c', 'девятьсот ');

  --десятки
  r := replace( r, '1d0e', 'десять ');
  r := replace( r, '1d1e', 'одиннадцать ');
  r := replace( r, '1d2e', 'двенадцать ');
  r := replace( r, '1d3e', 'тринадцать ');
  r := replace( r, '1d4e', 'четырнадцать ');
  r := replace( r, '1d5e', 'пятнадцать ');
  r := replace( r, '1d6e', 'шестнадцать ');
  r := replace( r, '1d7e', 'семнадцать ');
  r := replace( r, '1d8e', 'восемнадцать ');
  r := replace( r, '1d9e', 'девятнадцать ');
  r := replace( r, '0d', '');
  r := replace( r, '2d', 'двадцать ');
  r := replace( r, '3d', 'тридцать ');
  r := replace( r, '4d', 'сорок ');
  r := replace( r, '5d', 'пятьдесят ');
  r := replace( r, '6d', 'шестьдесят ');
  r := replace( r, '7d', 'семьдесят ');
  r := replace( r, '8d', 'восемьдесят ');
  r := replace( r, '9d', 'девяносто ');

  --единицы
  r := replace( r, '0e', '');
  r := replace( r, '5e', 'пять ');
  r := replace( r, '6e', 'шесть ');
  r := replace( r, '7e', 'семь ');
  r := replace( r, '8e', 'восемь ');
  r := replace( r, '9e', 'девять ');

  if g = 'M' then
    r := replace( r, '1e.', 'один !'||s[1]||' '); --один рубль
    r := replace( r, '2e.', 'два !'||s[2]||' '); --два рубля
  elsif g = 'F' then
    r := replace( r, '1e.', 'одна !'||s[1]||' '); --одна тонна
    r := replace( r, '2e.', 'две !'||s[2]||' '); --две тонны
  elsif g = 'N' then
    r := replace( r, '1e.', 'одно !'||s[1]||' '); --одно место
    r := replace( r, '2e.', 'два !'||s[2]||' '); --два места
  end if;
  r := replace( r, '3e.', 'три !'||s[2]||' ');
  r := replace( r, '4e.', 'четыре !'||s[2]||' ');

  r := replace( r, '1et', 'одна тысяча ');
  r := replace( r, '2et', 'две тысячи ');
  r := replace( r, '3et', 'три тысячи ');
  r := replace( r, '4et', 'четыре тысячи ');
  r := replace( r, '1em', 'один миллион ');
  r := replace( r, '2em', 'два миллиона ');
  r := replace( r, '3em', 'три миллиона ');
  r := replace( r, '4em', 'четыре миллиона ');
  r := replace( r, '1eM', 'один милиард ');
  r := replace( r, '2eM', 'два милиарда ');
  r := replace( r, '3eM', 'три милиарда ');
  r := replace( r, '4eM', 'четыре милиарда ');

  r := replace( r, 't', 'тысяч ');
  r := replace( r, 'm', 'миллионов ');
  r := replace( r, 'M', 'милиардов ');

  r := replace( r, '.', ' !'||s[3]||' ');

  if n = 0 then
    r := 'ноль ' || r;
  end if;

  return r;
end;
$BODY$;

/*
select
  n,
  _num_spelled(n, 'M', '{рубль,рубля,рублей}'),
  _num_spelled(n, 'F', '{копейка,копейки,копеек}'),
  _num_spelled(n, 'N', '{евро}')
from (values(0),(1),(2),(3),(5),(10),(11),(20),(21),(22),(23),(25),(45678),(1234567),(78473298395)) t(n);
*/

create or replace function p_convert.num_spelled (
  source_number    numeric,
  int_unit_gender  char,
  int_units        text[],
  frac_unit_gender char,
  frac_units       text[],
  frac_format      text
) returns text
language plpgsql as $BODY$
declare
  i numeric;
  f numeric;
  fmt text;
  fs  text;
  s int := 0;
  result text;
begin
  i := trunc(abs(source_number));
  fmt := regexp_replace(frac_format, '[^09]', '', 'g');
  s := char_length(fmt);
  f := round((abs(source_number) - i) * pow(10, s));
  
  result := num_spelled_int(i, int_unit_gender, int_units);
  fs := num_spelled_int(f, frac_unit_gender, frac_units);

  if coalesce(s,0) > 0 then --дробная часть
    if frac_format like '%d%' then --цифрами
      fs := to_char(f, fmt) || ' ' || substring(fs, '!.*');
    end if;
    if frac_format like '%m%' then --между целой частью и ед.изм.
      result := replace(result, '!', ', '||fs||' ');
    else --в конце
      result := result || ' ' || fs;
    end if;
  end if;
  result := replace(result, '!', '');
  result := regexp_replace(result, ' +', ' ', 'g'); --лишние пробелы
  result := replace(result, ' ,', ',');

  if source_number < 0 then
    result := 'минус ' || result;
  end if;
  
  return trim(result);
end;
$BODY$;

comment on function p_convert.num_spelled (
  source_number    numeric,
  int_unit_gender  char,
  int_units        text[],
  frac_unit_gender char,
  frac_units       text[],
  frac_format      text
) is
$$Число прописью.
source_number    numeric   исходное число
int_unit_gender  char      род целой единицы измерения (F/M/N)
int_units        text[]    названия целых единиц (3 элемента):
                           [1] - 1 рубль/1 тонна/1 место
                           [2] - 2 рубля/2 тонны/2 места
                           [3] - 0 рублей/0 тонн/0 мест
frac_unit_gender char      род дробной единицы измерения (F/M/N)
frac_units       text      названия дробных единиц (3 элемента):
                           [1] - 1 грамм/1 копейка
                           [2] - 2 грамма/2 копейки
                           [3] - 0 граммов/0 копеек
frac_format      text      каким образом выводить дроби:
                           '0' - число разрядов, с ведущими нулями
                           '9' - число разрядов, без ведущих нулей
                           't' - текстом ('00t' -> четыре рубля двадцать копеек)
                           'd' - цифрами ('00d' -> четыре рубля 20 копеек)
                           'm' - выводить дробную часть перед единицей измерения целой части
                             ('00dm' -> четыре, 20 рубля)
/*
select
  n,
  num_spelled(n, 'M', '{рубль,рубля,рублей}', 'F', '{копейка,копейки,копеек}', '00t'),
  num_spelled(n, 'M', '{рубль,рубля,рублей}', 'F', '{копейка,копейки,копеек}', '00d'),
  num_spelled(n, 'M', '{рубль,рубля,рублей}', 'F', NULL, '00dm'),
  num_spelled(n, 'N', '{евро}', 'M', '{цент,цента,центов}', '00t'),
  num_spelled(n, 'F', '{тонна,тонны,тонн}', NULL, NULL, NULL),
  num_spelled(n, 'F', '{"тн,"}', 'M', '{кг}', '999d')
from (values(0),(1),(1.23),(45.678),(12345.67),(-1),(-123.45)) t(n);
*/                             
$$;

CREATE OR REPLACE FUNCTION p_convert.num_to_str(p_amount numeric)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
     -- Преобразование числа в текст
     m_result   varchar(60);
     m_len      integer;

BEGIN
     if p_amount is null then return ''; end if;

     m_result := trim(both to_char(p_amount, '999999999999999999999999999999.99999999999999999999999999999'));
     m_len    := length(m_result);

     for i in 0..m_len
     loop
       if substr(m_result, m_len - i, 1) != '0'
       then
         exit;
       else
         m_result := substr(m_result, 1, m_len - (i + 1));
       end if;
     end loop;

     m_result := trim(both m_result);
     m_len    := length(m_result);

     if substr(m_result, m_len, 1) in ('.', ',')
     then
       m_result := substr(m_result, 1, m_len - 1);
     end if;

     m_result := trim(both m_result);

     if substr(m_result, 1, 1) in ('.', ',')
     then
       m_result := '0'||m_result;
     end if;

     return m_result;
  end;
  
$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_amount(p_amount numeric, p_is_default character DEFAULT 'T'::bpchar)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование суммы в текст    
    dig       varchar(255)[];
    dig_a     varchar(255)[];
    ten       varchar(255)[];
    hun       varchar(255)[];
    tis       varchar(255)[];
    mln       varchar(255)[];
    mlrd      varchar(255)[];
    i         numeric := 0;
    CurrValue numeric;
    S         numeric;
    p_result  varchar(255) := '';
    DIGIT     varchar(255) := '';
    RADIX     varchar(255) := '';

begin	
    CurrValue := trunc(p_amount);
    -- тысячи
    tis[0] := 'тисяч ';
    tis[1] := 'тисяча ';
    tis[2] := 'тисячi ';
    tis[3] := 'тисячi ';
    tis[4] := 'тисячi ';
    tis[5] := 'тисяч ';
    tis[6] := 'тисяч ';
    tis[7] := 'тисяч ';
    tis[8] := 'тисяч ';
    tis[9] := 'тисяч ';
    tis[10] := 'тисяч ';
    tis[11] := 'тисяч ';
    tis[12] := 'тисяч ';
    tis[13] := 'тисяч ';
    tis[14] := 'тисяч ';
    tis[15] := 'тисяч ';
    tis[16] := 'тисяч ';
    tis[17] := 'тисяч ';
    tis[18] := 'тисяч ';
    tis[19] := 'тисяч ';   
    -- мiльйон
    mln[0] := 'мiльйонiв ';
    mln[1] := 'мiльйон ';
    mln[2] := 'мiльйона ';
    mln[3] := 'мiльйона ';
    mln[4] := 'мiльйона ';
    mln[5] := 'мiльйонiв ';
    mln[6] := 'мiльйонiв ';
    mln[7] := 'мiльйонiв ';
    mln[8] := 'мiльйонiв ';
    mln[9] := 'мiльйонiв ';
    mln[10] := 'мiльйонiв ';
    mln[11] := 'мiльйонiв ';
    mln[12] := 'мiльйонiв ';
    mln[13] := 'мiльйонiв ';
    mln[14] := 'мiльйонiв ';
    mln[15] := 'мiльйонiв ';
    mln[16] := 'мiльйонiв ';
    mln[17] := 'мiльйонiв ';
    mln[18] := 'мiльйонiв ';
    mln[19] := 'мiльйонiв ';
    -- мiльярдiв
    mlrd[0] := ' ';
    mlrd[1] := 'мiльярд ';
    mlrd[2] := 'мiльярда ';
    mlrd[3] := 'мiльярда ';
    mlrd[4] := 'мiльярда ';
    mlrd[5] := 'мiльярдiв ';
    mlrd[6] := 'мiльярдiв ';
    mlrd[7] := 'мiльярдiв ';
    mlrd[8] := 'мiльярдiв ';
    mlrd[9] := 'мiльярдiв ';
    mlrd[10] := 'мiльярдiв ';
    mlrd[11] := 'мiльярдiв ';
    mlrd[12] := 'мiльярдiв ';
    mlrd[13] := 'мiльярдiв ';
    mlrd[14] := 'мiльярдiв ';
    mlrd[15] := 'мiльярдiв ';
    mlrd[16] := 'мiльярдiв ';
    mlrd[17] := 'мiльярдiв ';
    mlrd[18] := 'мiльярдiв ';
    mlrd[19] := 'мiльярдiв ';

    Dig[0] := '';
    dig[1] := 'один ';
    dig[2] := 'два ';
    dig[3] := 'три ';
    dig[4] := 'чотири ';
    dig[5] := 'п''ять ';
    dig[6] := 'шiсть ';
    dig[7] := 'сiм ';
    dig[8] := 'вiсiм ';
    dig[9] := 'дев''ять ';
    dig[10] := 'десять ';
    dig[11] := 'одинадцять ';
    dig[12] := 'дванадцять ';
    dig[13] := 'тринадцять ';
    dig[14] := 'чотирнадцять ';
    dig[15] := 'п''ятнадцять ';
    dig[16] := 'шiстнадцять ';
    dig[17] := 'сiмнадцять ';
    dig[18] := 'вiсiмнадцять ';
    dig[19] := 'дев''ятнадцять ';

    Dig_a[0] := '';
    dig_a[1] := 'одна ';
    dig_a[2] := 'двi ';
    dig_a[3] := 'три ';
    dig_a[4] := 'чотири ';
    dig_a[5] := 'п''ять ';
    dig_a[6] := 'шiсть ';
    dig_a[7] := 'сiм ';
    dig_a[8] := 'вiсiм ';
    dig_a[9] := 'дев''ять ';
    dig_a[10] := 'десять ';
    dig_a[11] := 'одинадцять ';
    dig_a[12] := 'дванадцять ';
    dig_a[13] := 'тринадцять ';
    dig_a[14] := 'чотирнадцять ';
    dig_a[15] := 'п''ятнадцять ';
    dig_a[16] := 'шiстнадцять ';
    dig_a[17] := 'сiмнадцять ';
    dig_a[18] := 'вiсiмнадцять ';
    dig_a[19] := 'дев''ятнадцять ';

    ten[0] := '';
    ten[1] := '';
    ten[2] := 'двадцять ';
    ten[3] := 'тридцять ';
    ten[4] := 'сорок ';
    ten[5] := 'п''ятдесят ';
    ten[6] := 'шiстдесят ';
    ten[7] := 'сiмдесят ';
    ten[8] := 'вiсiмдесят ';
    ten[9] := 'дев''яносто ';

    Hun[0] := '';
    Hun[1] := 'сто ';
    Hun[2] := 'двiстi ';
    Hun[3] := 'триста ';
    Hun[4] := 'чотириста ';
    Hun[5] := 'п''ятсот ';
    Hun[6] := 'шiстсот ';
    Hun[7] := 'сiмсот ';
    Hun[8] := 'вiсiмсот ';
    Hun[9] := 'дев''ятсот ';

    if Currvalue = 0
    then
      p_result := 'Нуль ';
    else
      while CurrValue > 0
      loop
        if (CurrValue % 1000) <> 0 
        then 
          S := CurrValue % 100;
          if S < 20 then

            if i <= 1 then
              if p_is_default = 'T' 
              then
                DIGIT := dig_a[s];
              else
                if i = 1 then
                  DIGIT := dig_a[s];
                else
                  DIGIT := dig[s];
                end if;
              end if;
            else
              DIGIT := dig[s];
            end if;

            if i = 0 then
              RADIX := '';
            elsif i = 1 then
              RADIX := tis[s];
            elsif i = 2 then
              RADIX := mln[s];
            elsif i = 3 then
              RADIX := mlrd[s];
            end if;

            p_result := DIGIT||RADIX|| p_result;
          else

            if i <= 1 then
              if p_is_default = 'T' then
                DIGIT := dig_a[mod(s, 10)];
              else
                DIGIT := dig[mod(s, 10)];
              end if;
            else
              DIGIT := dig[mod(s, 10)];
            end if;

            if i = 0 then
              RADIX := '';
            elsif i = 1 then
              RADIX := tis[mod(s, 10)];
            elsif i = 2 then
              begin
              if mod(s, 10) = 0 then
                 RADIX := mln[5];
              else
                 RADIX := mln[mod(s, 10)];
              end if;
              end;
            elsif i = 3 then
              begin
              if mod(s, 10) = 0 then
                 RADIX := mlrd[5];
              else
                 RADIX := mlrd[mod(s, 10)];
              end if;
              end;
            end if;

            p_result := Ten[trunc(S/10)]||DIGIT||RADIX||p_result;

          end if;
          CurrValue := trunc(CurrValue/100);
          S := CurrValue % 10;
          p_result := Hun[S] ||p_result;
          CurrValue := trunc(CurrValue/10);
          i := i + 1;
        else
          CurrValue := trunc(CurrValue/1000);
          i := i + 1;
        end if;
      end loop;
    end if;

    p_result := upper(substr(p_result, 1, 1))||substr(p_result, 2, 254);
    return(trim(both substr(p_result, 1, 255)));

  exception when others
  then 
    return null;
  end;

$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_amount_curr(p_amount numeric, p_curr_code character varying DEFAULT 'UAH'::character varying, p_is_decimal character DEFAULT 'F'::bpchar)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование суммы в текст (с валютой)
    dig       varchar(255)[];
    dig_a     varchar(255)[];
    ten       varchar(255)[];
    hun       varchar(255)[];
    tis       varchar(255)[];
    mln       varchar(255)[];
    mlrd      varchar(255)[];
	i         numeric := 0;
    CurrValue numeric;
    OriginVal numeric;
    Fraction  numeric;
    l         integer;
    S         numeric;
    DIGIT     varchar(255) := '';
    RADIX     varchar(255) := '';
    CResult   varchar(255);
    p_result  varchar(255) := '';

begin	
    CurrValue := trunc(p_amount);
    OriginVal := CurrValue;
    Fraction  := trunc((p_amount - CurrValue) * 100);

    -- тысячи
    tis[0] := 'тисяч ';
    tis[1] := 'тисяча ';
    tis[2] := 'тисячi ';
    tis[3] := 'тисячi ';
    tis[4] := 'тисячi ';
    tis[5] := 'тисяч ';
    tis[6] := 'тисяч ';
    tis[7] := 'тисяч ';
    tis[8] := 'тисяч ';
    tis[9] := 'тисяч ';
    tis[10] := 'тисяч ';
    tis[11] := 'тисяч ';
    tis[12] := 'тисяч ';
    tis[13] := 'тисяч ';
    tis[14] := 'тисяч ';
    tis[15] := 'тисяч ';
    tis[16] := 'тисяч ';
    tis[17] := 'тисяч ';
    tis[18] := 'тисяч ';
    tis[19] := 'тисяч ';

    -- мiльйон
    mln[0] := 'мiльйонiв ';
    mln[1] := 'мiльйон ';
    mln[2] := 'мiльйона ';
    mln[3] := 'мiльйона ';
    mln[4] := 'мiльйона ';
    mln[5] := 'мiльйонiв ';
    mln[6] := 'мiльйонiв ';
    mln[7] := 'мiльйонiв ';
    mln[8] := 'мiльйонiв ';
    mln[9] := 'мiльйонiв ';
    mln[10] := 'мiльйонiв ';
    mln[11] := 'мiльйонiв ';
    mln[12] := 'мiльйонiв ';
    mln[13] := 'мiльйонiв ';
    mln[14] := 'мiльйонiв ';
    mln[15] := 'мiльйонiв ';
    mln[16] := 'мiльйонiв ';
    mln[17] := 'мiльйонiв ';
    mln[18] := 'мiльйонiв ';
    mln[19] := 'мiльйонiв ';

    -- мiльярдiв
    mlrd[0] := ' ';
    mlrd[1] := 'мiльярд ';
    mlrd[2] := 'мiльярда ';
    mlrd[3] := 'мiльярда ';
    mlrd[4] := 'мiльярда ';
    mlrd[5] := 'мiльярдiв ';
    mlrd[6] := 'мiльярдiв ';
    mlrd[7] := 'мiльярдiв ';
    mlrd[8] := 'мiльярдiв ';
    mlrd[9] := 'мiльярдiв ';
    mlrd[10] := 'мiльярдiв ';
    mlrd[11] := 'мiльярдiв ';
    mlrd[12] := 'мiльярдiв ';
    mlrd[13] := 'мiльярдiв ';
    mlrd[14] := 'мiльярдiв ';
    mlrd[15] := 'мiльярдiв ';
    mlrd[16] := 'мiльярдiв ';
    mlrd[17] := 'мiльярдiв ';
    mlrd[18] := 'мiльярдiв ';
    mlrd[19] := 'мiльярдiв ';

    Dig[0] := '';
    dig[1] := 'один ';
    dig[2] := 'два ';
    dig[3] := 'три ';
    dig[4] := 'чотири ';
    dig[5] := 'п''ять ';
    dig[6] := 'шiсть ';
    dig[7] := 'сiм ';
    dig[8] := 'вiсiм ';
    dig[9] := 'дев''ять ';
    dig[10] := 'десять ';
    dig[11] := 'одинадцять ';
    dig[12] := 'дванадцять ';
    dig[13] := 'тринадцять ';
    dig[14] := 'чотирнадцять ';
    dig[15] := 'п''ятнадцять ';
    dig[16] := 'шiстнадцять ';
    dig[17] := 'сiмнадцять ';
    dig[18] := 'вiсiмнадцять ';
    dig[19] := 'дев''ятнадцять ';

    Dig_a[0] := '';
    dig_a[1] := 'один ';
    dig_a[2] := 'два ';
    dig_a[3] := 'три ';
    dig_a[4] := 'чотири ';
    dig_a[5] := 'п''ять ';
    dig_a[6] := 'шiсть ';
    dig_a[7] := 'сiм ';
    dig_a[8] := 'вiсiм ';
    dig_a[9] := 'дев''ять ';
    dig_a[10] := 'десять ';
    dig_a[11] := 'одинадцять ';
    dig_a[12] := 'дванадцять ';
    dig_a[13] := 'тринадцять ';
    dig_a[14] := 'чотирнадцять ';
    dig_a[15] := 'п''ятнадцять ';
    dig_a[16] := 'шiстнадцять ';
    dig_a[17] := 'сiмнадцять ';
    dig_a[18] := 'вiсiмнадцять ';
    dig_a[19] := 'дев''ятнадцять ';

    ten[0] := '';
    ten[1] := '';
    ten[2] := 'двадцять ';
    ten[3] := 'тридцять ';
    ten[4] := 'сорок ';
    ten[5] := 'п''ятдесят ';
    ten[6] := 'шiстдесят ';
    ten[7] := 'сiмдесят ';
    ten[8] := 'вiсiмдесят ';
    ten[9] := 'дев''яносто ';

    Hun[0] := '';
    Hun[1] := 'сто ';
    Hun[2] := 'двiстi ';
    Hun[3] := 'триста ';
    Hun[4] := 'чотириста ';
    Hun[5] := 'п''ятсот ';
    Hun[6] := 'шiстсот ';
    Hun[7] := 'сiмсот ';
    Hun[8] := 'вiсiмсот ';
    Hun[9] := 'дев''ятсот ';

    if Currvalue = 0
    then
      p_result := 'Нуль ';
    else
      while CurrValue > 0
      loop
        if (CurrValue % 1000) <> 0 
        then
          S := CurrValue % 100;
          if S < 20
          then
            if i <= 1 
            then
              if p_curr_code = 'UAH' 
              then
                DIGIT := dig_a[s];
              else
                DIGIT := dig[s];
              end if;
            else
              DIGIT := dig[s];
            end if;

            if i = 0 then
              RADIX := '';
            elsif i = 1 then
              RADIX := tis[s];
            elsif i = 2 then
              RADIX := mln[s];
            elsif i = 3 then
              RADIX := mlrd[s];
            end if;

            p_result := DIGIT || RADIX || p_result;
          else

            if i <= 1 then
              DIGIT := dig_a[mod(s, 10)];
            else
              DIGIT := dig[mod(s, 10)];
            end if;

            if i = 0 then
              RADIX := '';
            elsif i = 1 then
              RADIX := tis[mod(s, 10)];
            elsif i = 2 then
              begin
                if mod(s, 10) = 0 then
                  RADIX := mln[5];
                else
                  RADIX := mln[mod(s, 10)];
                end if;
              end;
            elsif i = 3 then
              begin
                if mod(s, 10) = 0 then
                  RADIX := mlrd[5];
                else
                  RADIX := mlrd[mod(s, 10)];
                end if;
              end;
            end if;

            p_result := Ten[trunc(S / 10)] || DIGIT || RADIX || p_result;

          end if;
          CurrValue := trunc(CurrValue / 100);
          S         := CurrValue % 10;
          p_result    := Hun[S] || p_result;
          CurrValue := trunc(CurrValue / 10);
          i         := i + 1;
        else
          CurrValue := trunc(CurrValue / 1000);
          i         := i + 1;
        end if;
      end loop;
    end if;

    if p_is_decimal = 'T' then
      p_result := p_result || ' цiлих ' || to_char(fraction, '00') || ' сотих';
    else
      if (upper(p_curr_code) = 'UAH') or (trim(both p_curr_code) is null) then
        CResult := OriginVal::varchar;
        l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || ' гривень';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || ' гривень';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || ' гривня';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || ' гривні';
        else
          p_result := p_result || ' гривень';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' копійка';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' копійки';
        else
          p_result := p_result || to_char(fraction, '00') || ' копійок';
        end if;
  ------------------------------------------------------------------
      elsif (upper(p_curr_code) = 'USD') then
        CResult := OriginVal::varchar;
        l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || ' доларiв США';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || ' доларiв США';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || ' долар США';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || ' долари США';
        else
          p_result := p_result || ' доларiв США';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' цент';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' центи';
        else
          p_result := p_result || to_char(fraction, '00') || ' центiв';
        end if;
  ------------------------------------------------------------------
        elsif (upper(p_curr_code) = 'EUR') then
          p_result := p_result || ' євро ';
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' євроцент';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' євроценти';
        else
          p_result := p_result || to_char(fraction, '00') || ' євроцентiв';
        end if;
  ------------------------------------------------------------------
        elsif (upper(p_curr_code) = 'GBP') then
          CResult := OriginVal::varchar;
          l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || ' англійських Фунтів стерлінгів';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || ' англійських Фунтів стерлінгів';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || ' англійських Фунт стерлінгів';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || ' англійських Фунти стерлінгів';
        else
          p_result := p_result || ' англійських Фунтів стерлінгів';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' пенс';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' пенси';
        else
          p_result := p_result || to_char(fraction, '00') || ' пенсiв';
        end if;
  ------------------------------------------------------------------
        elsif (upper(p_curr_code) = 'CHF') then
          CResult := OriginVal::varchar;
          l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || ' швейцарських франків';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || ' швейцарських франків';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || ' швейцарський франк';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || ' швейцарських франки';
        else
          p_result := p_result || ' швейцарських франків';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' сантим';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' сантими';
        else
          p_result := p_result || to_char(fraction, '00') || ' сантимiв';
        end if;
  ------------------------------------------------------------------
        elsif (upper(p_curr_code) = 'RUR') then
          CResult := OriginVal::varchar;
          l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || 'російських рублів';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || 'російських рублів';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || 'російський рубель';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || 'російських рубля';
        else
          p_result := p_result || 'російських рублів';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' копійка';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' копійки';
        else
          p_result := p_result || to_char(fraction, '00') || ' копійок';
        end if;
  ------------------------------------------------------------------
        elsif (upper(p_curr_code) = 'RUB') then
          CResult := OriginVal::varchar;
          l       := length(CResult);
        if ((l > 1) and ((substr(CResult, l - 1, 2))::numeric  > 10) and ((substr(CResult, l - 1, 2))::numeric  < 20)) then
          p_result := p_result || 'російських рублів';
        elsif (substr(CResult, l, 1))::numeric  = 0 then
          p_result := p_result || 'російських рублів';
        elsif (substr(CResult, l, 1))::numeric  = 1 then
          p_result := p_result || 'російський рубель';
        elsif ((substr(CResult, l, 1))::numeric  = 2) or ((substr(CResult, l, 1))::numeric  = 3) or ((substr(CResult, l, 1))::numeric  = 4) then
          p_result := p_result || 'російських рубля';
        else
          p_result := p_result || 'російських рублів';
        end if;
  ------------------------------------------------------------------
        if substr(fraction::varchar,1,2) in ('01','21','31','41','51','61','71','81','91') then
          p_result := p_result || to_char(fraction, '00') || ' копійка';
        elsif substr(fraction::varchar,1,2) in ('02','03','04','22','23','24','32','33','34',
                                                '42','43','44','52','53','54','62','63','64',
                                                '72','73','74','82','83','84','92','93','94') then
          p_result := p_result || to_char(fraction, '00') || ' копійки';
        else
          p_result := p_result || to_char(fraction, '00') || ' копійок';
        end if;
  ------------------------------------------------------------------
        else
          p_result := p_result || ' ' || to_char(fraction, '00') || ' ' ||
                  p_curr_code;
        end if;
    end if;

    p_result := upper(substr(p_result, 1, 1)) || substr(p_result, 2, 254);
    p_result := replace(p_result, '  ', ' ');

    return(trim(both substr(p_result, 1, 255)));

  exception when others
  then
      return null;
  end;
  
$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_amount_format(p_number numeric, p_count_comma integer DEFAULT 2)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование суммы в текстовый формат числа
    p_n varchar(255);
    pos integer;
    p_num numeric;

BEGIN
    if p_number is null then return p_number; end if;
    p_num := p_number;
    if p_num > 999999999999 then p_num := 999999999999; end if;

    if p_count_comma = 0 then p_n := to_char(p_num,'999G999G999G990'); end if;
    if p_count_comma = 1 then p_n := to_char(p_num,'999G999G999G990D0'); end if;
    if p_count_comma = 2 then p_n := to_char(p_num,'999G999G999G990D00'); end if;
    if p_count_comma = 3 then p_n := to_char(p_num,'999G999G999G990D000'); end if;
    if p_count_comma = 4 then p_n := to_char(p_num,'999G999G999G990D0000'); end if;
    if p_count_comma = 5 then p_n := to_char(p_num,'999G999G999G990D00000'); end if;
    if p_count_comma > 5 or p_count_comma is null
    then
       RAISE EXCEPTION '%', 'Количество знаков после запятой не может быль больше 5 или NULL !!!' USING ERRCODE = '45000';
    end if;

    p_n := replace(p_n,'.',chr(44));
    p_n := replace(p_n,chr(44),' ');
    p_n := trim(both p_n);

    -- восстанавливаем последнюю запятую
    pos := instr(p_n,' ',-1,1);
    if p_count_comma = 0 then p_n := p_n; end if;
    if p_count_comma <> 0 then p_n := substr(p_n,1,pos-1) || chr(44) || substr(p_n,pos+1,length(p_n)-pos); end if;

    return p_n;
  end;

$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_interest(p_amount numeric)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование процента с тест (0,5678999% (нуль цiлих i п'ять мiльйонiв шiстсот сiмдесят вiсiм тисяч дев'ятсот дев'яносто дев'ять десятимільйонних процента))
    p_result      varchar(255) := '';
    Fraction      numeric;
    FractionType  varchar(255);
    FractionT     varchar(255);
    FractionFM    varchar(255);
    p_last_amount numeric;

BEGIN
    Fraction := p_amount - Trunc(p_amount);
    FractionT := substr(p_convert.num_to_str(Fraction),3);
    FractionFM := 'FM999,999,999,990.00';
    if    length(FractionT) = 1 then
             FractionType := 'десятих';
             Fraction := Fraction * 10;
    elsif length(FractionT) = 2 then 
             FractionType := 'сотих';
             Fraction := Fraction * 100;
    elsif length(FractionT) = 3 then
             FractionType := 'тисячних';
             Fraction := Fraction * 1000;
             FractionFM := 'FM999,999,999,990.000';
    elsif length(FractionT) = 4 then 
             FractionType := 'десятитисячних';
             Fraction := Fraction * 10000;
             FractionFM := 'FM999,999,999,990.0000';
    elsif length(FractionT) = 5 then 
             FractionType := 'стотисячних';
             Fraction := Fraction * 100000;
             FractionFM := 'FM999,999,999,990.00000';
    elsif length(FractionT) = 6 then 
             FractionType := 'мільйонних';
             Fraction := Fraction * 1000000;
             FractionFM := 'FM999,999,999,990.000000';
    elsif length(FractionT) = 7 then 
             FractionType := 'десятимільйонних';
             Fraction := Fraction * 10000000;
             FractionFM := 'FM999,999,999,990.0000000';
    elsif length(FractionT) = 8 then 
             FractionType := 'стомільйонних';
             Fraction := Fraction * 100000000;
             FractionFM := 'FM999,999,999,990.00000000';
    elsif length(FractionT) > 8 
      then 
         return null;
    end if;

    if Fraction = 0
    then
      p_result := trim(both to_char(p_amount, FractionFM))||'% ('||p_convert.str_amount(p_amount, 'F');

      -- добавляем
      p_last_amount := (substr(p_amount::varchar, -1, 1))::numeric;
      if (p_last_amount in (0,5,6,7,8,9) or p_amount in (11,12,13,14,15,16,17,18,19)) then p_result := p_result||' процентiв)';
      elsif p_last_amount = 1 then p_result := p_result||' процент)';
      elsif p_last_amount in (2,3,4) then p_result := p_result||' процента)';
      else
         p_result := p_result||' процента)';
      end if;

    else
      p_result := trim(both to_char(p_amount, FractionFM))||'% ('||p_convert.str_amount(p_amount);

      if trunc(p_amount) = 1
      then
         p_result := p_result||' цiла i '||lower(p_convert.str_amount(Fraction))||' '||FractionType;
      else
         p_result := p_result||' цiлих i '||lower(p_convert.str_amount(Fraction))||' '||FractionType;
      end if;

      p_result := p_result||' процента)';
    end if;

    p_result := lower(p_result);

    -- замена
    if FractionType is not null and substr(p_convert.num_to_str(p_amount),-1) = '1'
        and substr(p_convert.num_to_str(p_amount),-2) != '11'
    then
        if    length(FractionT) = 1 then p_result := replace(p_result, 'десятих', 'десята');
        elsif length(FractionT) = 2 then p_result := replace(p_result, 'сотих', 'сота');
        elsif length(FractionT) = 3 then p_result := replace(p_result, 'тисячних', 'тисячна');
        elsif length(FractionT) = 4 then p_result := replace(p_result, 'десятитисячних', 'десятитисячна');
        elsif length(FractionT) = 5 then p_result := replace(p_result, 'стотисячних', 'стотисячна');
        elsif length(FractionT) = 6 then p_result := replace(p_result, 'мільйонних', 'мільйонна');
        elsif length(FractionT) = 7 then p_result := replace(p_result, 'десятимільйонних', 'десятимільйонна');
        elsif length(FractionT) = 8 then p_result := replace(p_result, 'стомільйонних', 'стомільйонна');
        end if;
    end if;

    return replace((trim(both substr(p_result, 1, 255))), '.', ',');

  exception when others
  then      
    return null;
  end;

$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_to_date(p_text character varying, p_format character varying DEFAULT 'dd.mm.yyyy'::character varying)
 RETURNS timestamp without time zone
 LANGUAGE plpgsql
 STABLE
AS $function$
begin
	-- Преобразование теста в дату
    return(to_date(trim(both p_text), p_format));
  exception when others
  then
     RAISE EXCEPTION '%', 'Невозможно преобразовать в дату ='||p_text USING ERRCODE = '45000';
  end;

$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_to_num(p_text character varying)
 RETURNS numeric
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Преобразование теста с число
    m_text varchar(32000);

begin
	if (p_text is null or p_text = '') then return null; end if;
    m_text := replace(p_text,',','.');
    m_text := replace(p_text,' ','');
    m_text := replace(p_text,chr(13),'');
    m_text := replace(p_text,chr(10),'');   
    return(to_number(trim(both m_text), '999999999999999999999999999999.99999999999999999999999999999'));
  exception when others
  then
     RAISE EXCEPTION '%', 'Невозможно преобразовать в число ="'||p_text||'"' USING ERRCODE = '45000';
  end;
 
$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_days(p_value integer)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Описание (дні)
    result     varchar(255);
    p_name_day varchar(255);
    DayValue   integer;
    CResult    varchar(20);
    l          integer;
begin	
    DayValue := Trunc(p_value);
    CResult := to_char(DayValue);
    l := length(CResult);

    if ((l>1) and (to_number(substr(CResult,l-1,2))>10) and (to_number(substr(CResult,l-1,2))<20))
     then
       p_name_day := ' днів ';
    elsif to_number(substr(CResult,l,1))=0
     then
       p_name_day := ' днів ';
    elsif to_number(substr(CResult,l,1))=1
     then
       p_name_day := ' день ';
    elsif (to_number(substr(CResult,l,1))=2) or (to_number(substr(CResult,l,1))=3) or (to_number(substr(CResult,l,1))=4)
     then
       p_name_day:= ' дні ';
    else
       p_name_day := ' днів ';
    end if;

    Result := p_name_day;

    return (trim(substr(Result, 1, 255)));
  exception when others
  then
    return(Result);
  end;              
  
$function$
;

CREATE OR REPLACE FUNCTION p_convert.str_month(p_value integer)
 RETURNS character varying
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    -- Описание (місяці)
    result       varchar(255);
    p_name_month varchar(255);
    MonthValue   integer;
    CResult      varchar(20);
    l            integer;
  begin
    MonthValue := Trunc(p_value);
    CResult := to_char(MonthValue);
    l := length(CResult);

    if ((l>1) and (to_number(substr(CResult,l-1,2))>10) and (to_number(substr(CResult,l-1,2))<20))
     then
       p_name_month := ' місяців ';
    elsif to_number(substr(CResult,l,1))=0
     then
       p_name_month := ' місяців ';
    elsif to_number(substr(CResult,l,1))=1
     then
       p_name_month := ' місяць ';
    elsif (to_number(substr(CResult,l,1))=2) or (to_number(substr(CResult,l,1))=3) or (to_number(substr(CResult,l,1))=4)
     then
       p_name_month:= ' місяці ';
    else
       p_name_month := ' місяців ';
    end if;

    Result := p_name_month;

    return (trim(substr(Result, 1, 255)));
  exception when others 
  then 
    return(Result);
  end;           
 
$function$
;

-----------------------------------------------------
-- DROP SCHEMA p_interface;

CREATE SCHEMA p_interface AUTHORIZATION testdb;

-- DROP TYPE p_interface.t_erb_minfin;

CREATE TYPE p_interface.t_erb_minfin AS (
	issuccess text,
	num_rows numeric,
	requestdate timestamp,
	isoverflow text,
	num_id numeric,
	root_id numeric,
	lastname text,
	firstname text,
	middlename text,
	birthdate timestamp,
	publisher text,
	departmentcode text,
	departmentname text,
	departmentphone text,
	executor text,
	executorphone text,
	executoremail text,
	deductiontype text,
	vpnum text,
	okpo text,
	full_name text);

-- DROP TYPE p_interface.t_fair_value;

CREATE TYPE p_interface.t_fair_value AS (
	calc_date timestamp,
	cpcode varchar(255),
	ccy varchar(3),
	fair_value numeric,
	ytm numeric,
	clean_rate numeric,
	cor_coef numeric,
	maturity timestamp,
	cor_coef_cash numeric,
	notional numeric,
	avr_rate numeric,
	option_value numeric,
	intrinsic_value numeric,
	time_value numeric,
	delta_per numeric,
	delta_equ numeric,
	dop varchar(255));

-- DROP TYPE p_interface.t_isin_secur;

CREATE TYPE p_interface.t_isin_secur AS (
	cpcode varchar(255),
	nominal numeric,
	auk_proc numeric,
	pgs_date timestamp,
	razm_date timestamp,
	cptype varchar(255),
	cpdescr varchar(255),
	pay_period numeric,
	val_code varchar(3),
	emit_okpo varchar(255),
	emit_name varchar(255),
	cptype_nkcpfr varchar(255),
	cpcode_cfi varchar(255),
	total_bonds numeric,
	pay_date timestamp,
	pay_type numeric,
	pay_val numeric,
	pay_array varchar(5));

-- Table: p_interface.import_data_type
-- DROP TABLE IF EXISTS p_interface.import_data_type;

CREATE TABLE IF NOT EXISTS p_interface.import_data_type
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    type_oper character varying(255) COLLATE pg_catalog."default" NOT NULL,
    data_type character varying(4) COLLATE pg_catalog."default" NOT NULL,
    data_text text COLLATE pg_catalog."default",
    data_xml xml,
    data_json json,
    CONSTRAINT pk_import_data_type PRIMARY KEY (id),
    CONSTRAINT import_data_type_chk CHECK (data_type::text = ANY (ARRAY['xml'::character varying, 'json'::character varying, 'csv'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS p_interface.import_data_type
    OWNER to testdb;

COMMENT ON TABLE p_interface.import_data_type
    IS 'Таблица с принятыми данными';

COMMENT ON COLUMN p_interface.import_data_type.id
    IS 'ID';

COMMENT ON COLUMN p_interface.import_data_type.type_oper
    IS 'Тип операции';

COMMENT ON COLUMN p_interface.import_data_type.data_type
    IS 'Тип данных';

COMMENT ON COLUMN p_interface.import_data_type.data_text
    IS 'Данные Text';

COMMENT ON COLUMN p_interface.import_data_type.data_xml
    IS 'Данные XML';

COMMENT ON COLUMN p_interface.import_data_type.data_json
    IS 'Данные JSON';

-- FUNCTION: p_interface.add_import_data_type(character varying, character varying, text)
-- DROP FUNCTION IF EXISTS p_interface.add_import_data_type(character varying, character varying, text);

CREATE OR REPLACE FUNCTION p_interface.add_import_data_type(
	p_type_oper character varying,
	p_data_type character varying,
	p_data_value text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

	BEGIN
      -- добавить историю данных
      if p_data_type = 'csv'
      then
         insert into p_interface.import_data_type(type_oper, data_type, data_text)
           values (p_type_oper, p_data_type, p_data_value);
      elsif p_data_type = 'xml'    
      then
         insert into p_interface.import_data_type(type_oper, data_type, data_xml)
           values (p_type_oper, p_data_type, p_data_value::xml);
           
      elsif p_data_type = 'json'
      then
         insert into p_interface.import_data_type(type_oper, data_type, data_json)
           values (p_type_oper, p_data_type, to_json(p_data_value));
           
      end if;
      
      return 1;
	END;
$BODY$;

ALTER FUNCTION p_interface.add_import_data_type(character varying, character varying, text)
    OWNER TO testdb;
   
-- FUNCTION: p_interface.read_erb_minfin(text, text, text, text, text, timestamp without time zone, text)
-- DROP FUNCTION IF EXISTS p_interface.read_erb_minfin(text, text, text, text, text, timestamp without time zone, text);

CREATE OR REPLACE FUNCTION p_interface.read_erb_minfin(
	p_categorycode text DEFAULT NULL::text,
	p_identcode text DEFAULT NULL::text,
	p_lastname text DEFAULT NULL::text,
	p_firstname text DEFAULT NULL::text,
	p_middlename text DEFAULT NULL::text,
	p_birthdate timestamp without time zone DEFAULT NULL::timestamp without time zone,
	p_type_cust_code text DEFAULT NULL::text)
    RETURNS SETOF p_interface.t_erb_minfin 
    LANGUAGE 'plpgsql'
    COST 100
    STABLE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
      -- НАИС - поиск контрагента в ЕРД (едином реестре должников)
      -- Получить данные
      -- select * from p_interface.read_erb_minfin(p_identcode => '33270581', p_type_cust_code => '2')    
      -- select * from p_interface.read_erb_minfin(p_identCode => '2985108376', p_type_cust_code => '1')
	  -- select * from p_interface.read_erb_minfin(p_lastName       => 'Бондарчук',
	  --	                                       p_firstName      => 'Ігор',
	  --                                           p_middleName     => 'Володимирович',
	  --                                           p_birthDate      => to_date('23.09.1981','dd.mm.yyyy'),
	  --                                           p_type_cust_code => '1')
      p_url                  varchar(255);
      p_response_body        text;
      p_request_body         text;
      p_num                  numeric := 1;
      p_erb_minfin_row       p_interface.t_erb_minfin;   
      p_rezult			     int;     
      k 					 RECORD;
      j 					 RECORD;
BEGIN
      p_url := 'https://erb.minjust.gov.ua/listDebtorsEndpoint';

      -- физ. лица
      if p_type_cust_code = '1'
      then  
          select json_build_object('searchType','1', 'paging','1',
                                   'filter', json_build_object('LastName', p_lastName,
                                                               'FirstName', p_firstName,
                                                               'MiddleName', p_middleName,
                                                               'BirthDate', case when p_birthDate is null then null
                                                                                 else to_char(p_birthDate,'YYYY-MM-DD')||'T00:00:00.000Z'
                                                                                 end,       
                                                               'IdentCode', p_identCode,
                                                               'categoryCode',  p_categoryCode
                                                            -- если будет пустая переменная, тег не подставляется (используем json_strip_nulls(json_build_object())
                                                            -- по умолчанию, если пустая передается null
                                                            )                   
                            )
                        into STRICT p_request_body;
      else
      -- юр. лица        
          select json_build_object('searchType','2',
                                   'filter', json_build_object('FirmName', p_lastName,
                                                               'FirmEdrpou', p_identCode,
                                                               'categoryCode', p_categoryCode
                                                               )                   
                                  )
                        into STRICT p_request_body;
      end if;
      
      -- запрашиваем данные
      p_response_body := p_service.post(p_uri => p_url, p_request_body => p_request_body::json, p_paramenters => '[]', p_decode => 'utf-8'); 
      
      --RAISE EXCEPTION 'p_response_body %.', p_response_body;    
      
      -- добавить историю
      p_rezult := p_interface.add_import_data_type(p_type_oper => 'erb_minfin', p_data_type => 'json', p_data_value => p_response_body);                              
       
      if p_check.is_valid_json(p_response_body) = 'T'
      then  
          for j in select (e.item ->> 'isSuccess') as isSuccess,
  			              (e.item ->> 'rows') as num_rows,
			              (e.item ->> 'requestDate') as requestDate,  			                     
			              (e.item ->> 'isOverflow') as isOverflow,
			              (e.item ->> 'errMsg') as errMsg
			         from jsonb_path_query(p_response_body::jsonb, '$[*]') as e(item)
		  loop   
   	          if j.errMsg is not null
		      then  
		          RAISE EXCEPTION '%', p_request_body||chr(13)||chr(10)||j.errMsg USING ERRCODE = '45000';
		      end if;
		  
	          p_erb_minfin_row.isSuccess := j.isSuccess;
	          p_erb_minfin_row.num_rows := j.num_rows;
	          p_erb_minfin_row.requestDate := p_convert.get_datetime(j.requestDate);
	          p_erb_minfin_row.isOverflow := j.isOverflow;

	          if p_erb_minfin_row.num_rows > 0
	          then  
	                for k in select (e.item ->> 'ID') as num_id,
	  			                     (e.item ->> 'rootID') as root_id,
	  			                     (e.item ->> 'lastName') as lastname,  			                     
	  			                     (e.item ->> 'firstName') as firstName,
	  			                     (e.item ->> 'middleName') as middleName,
	  			                     (e.item ->> 'birthDate') as birthDate,
	  			                     (e.item ->> 'publisher') as publisher,
	  			                     (e.item ->> 'departmentCode') as departmentCode,
	  			                     (e.item ->> 'departmentName') as departmentName,
	  			                     (e.item ->> 'departmentPhone') as departmentPhone,
	  			                     (e.item ->> 'executor') as executor,
	  			                     (e.item ->> 'executorPhone') as executorPhone,
	  			                     (e.item ->> 'executorEmail') as executorEmail,
	  			                     (e.item ->> 'deductionType') as deductionType,
	  			                     (e.item ->> 'vpNum') as vpNum,
	  			                     (e.item ->> 'code') as okpo,
	  			                     (e.item ->> 'name') as full_name
	  			                     from jsonb_path_query(p_response_body::jsonb, '$.results[*]') as e(item)                     
	                 loop
	                    p_erb_minfin_row.num_id          := k.num_id;
	                    p_erb_minfin_row.root_id         := k.root_id;
	                    p_erb_minfin_row.lastname        := k.lastname;
	                    p_erb_minfin_row.firstname       := k.firstname;
	                    p_erb_minfin_row.middlename      := k.middlename;
	                    p_erb_minfin_row.birthdate       := p_convert.get_datetime(k.birthdate);
	                    p_erb_minfin_row.publisher       := k.publisher;
	                    p_erb_minfin_row.departmentcode  := k.departmentcode;
	                    p_erb_minfin_row.departmentname  := k.departmentname;
	                    p_erb_minfin_row.departmentphone := k.departmentphone;
	                    p_erb_minfin_row.executor        := k.executor;
	                    p_erb_minfin_row.executorphone   := k.executorphone;
	                    p_erb_minfin_row.executoremail   := k.executoremail;
	                    p_erb_minfin_row.deductiontype   := k.deductiontype;
	                    p_erb_minfin_row.vpnum           := k.vpnum;
	                    p_erb_minfin_row.okpo            := k.okpo;
	                    p_erb_minfin_row.full_name       := k.full_name;
	                    return next p_erb_minfin_row; 
	                 end loop;
	           end if;
	       end loop;   
       end if;

       return;
    end;

$BODY$;

ALTER FUNCTION p_interface.read_erb_minfin(text, text, text, text, text, timestamp without time zone, text)
    OWNER TO testdb;

-- FUNCTION: p_interface.read_fair_value(timestamp without time zone)
-- DROP FUNCTION IF EXISTS p_interface.read_fair_value(timestamp without time zone);

CREATE OR REPLACE FUNCTION p_interface.read_fair_value(
	p_date timestamp without time zone)
    RETURNS SETOF p_interface.t_fair_value 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
      -- Справедливая стоимость ЦБ (котировки НБУ)
      -- Получить данные
      -- select t.* from p_interface.read_fair_value(p_convert.str_to_date('06.05.2021')) t
      -- или
      -- SELECT p_interface.read_fair_value(p_date => '2022-10-14 00:00+10'::timestamp without time zone);
      --
      p_url                  varchar(255) := '';
      p_response_body        text;
      p_fair_value_row       p_interface.t_fair_value;
      p_num					 numeric := 1;
      p_rezult			     int;
      j 					 RECORD;
  	  k 					 RECORD;
begin	
      p_url := 'https://bank.gov.ua/files/Fair_value/'||to_char(p_date,'yyyymm/yyyymmdd')||'_fv.txt';

      -- запрашиваем данные
      p_response_body := p_service.get(p_uri => p_url, p_decode => 'cp1251'); 
      
      --RAISE EXCEPTION 'p_response_body %.', p_response_body;
     
      -- добавить историю
      p_rezult := p_interface.add_import_data_type(p_type_oper => 'fair_value', p_data_type => 'csv', p_data_value => p_response_body);              
     
      for j in with a as (select p_response_body as source_text)
               select regexp_split_to_table(a.source_text, '\n+') as string_row 
               from a
      loop    
          -- заголовок пропускаем          
          if p_num > 1
          then                            
	          for k in with b as (select j.string_row as source_text_row)
	                   select  p_convert.str_to_date(split_part(b.source_text_row, ';', 1)) as calc_date,
	                           split_part(b.source_text_row, ';', 2) as cpcode,
	                           split_part(b.source_text_row, ';', 3) as ccy,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 4)) as fair_value,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 5)) as ytm,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 6)) as clean_rate,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 7)) as cor_coef,
	                           p_convert.str_to_date(split_part(b.source_text_row, ';', 8)) as maturity,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 9)) as cor_coef_cash,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 10)) as notional,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 11)) as avr_rate,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 12)) as option_value,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 13)) as intrinsic_value,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 14)) as time_value,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 15)) as delta_per,
	                           p_convert.str_to_num(split_part(b.source_text_row, ';', 16)) as delta_equ,
	                           split_part(b.source_text_row, ';', 16) as dop
	                   from b        
	           loop
	              p_fair_value_row.calc_date := k.calc_date;
	              p_fair_value_row.cpcode := k.cpcode;
	              p_fair_value_row.ccy := k.ccy;
	              p_fair_value_row.fair_value := k.fair_value;
	              p_fair_value_row.ytm := k.ytm;
	              p_fair_value_row.clean_rate := k.clean_rate;
	              p_fair_value_row.cor_coef := k.cor_coef;
	              p_fair_value_row.maturity := k.maturity;
	              p_fair_value_row.cor_coef_cash := k.cor_coef_cash;
	              p_fair_value_row.notional := k.notional;
	              p_fair_value_row.avr_rate := k.avr_rate;
	              p_fair_value_row.option_value := k.option_value;
	              p_fair_value_row.intrinsic_value := k.intrinsic_value;
	              p_fair_value_row.time_value := k.time_value;
	              p_fair_value_row.delta_per := k.delta_per;
	              p_fair_value_row.delta_equ := k.delta_equ;
	              p_fair_value_row.dop := k.dop;
	              return next p_fair_value_row;
	           end loop;
		   end if;       
           p_num := p_num + 1;          
       end loop;
      
       return;
    end;
   
$BODY$;

ALTER FUNCTION p_interface.read_fair_value(timestamp without time zone)
    OWNER TO testdb;

-- FUNCTION: p_interface.read_isin_secur(character varying)
-- DROP FUNCTION IF EXISTS p_interface.read_isin_secur(character varying);

CREATE OR REPLACE FUNCTION p_interface.read_isin_secur(
	p_format character varying)
    RETURNS SETOF p_interface.t_isin_secur 
    LANGUAGE 'plpgsql'
    COST 100
    STABLE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

declare
      -- Перечень ISIN ЦБ с купонными периодами
      -- Получить данные
      -- select * from p_interface.read_isin_secur('xml')
      p_url                  varchar(255) := '';
      p_response_body        text;
      p_dop_param            varchar(5) := '';
      p_isin_secur_row       p_interface.t_isin_secur;
      p_rezult			     int;     
      k  					 RECORD;
      kk 					 RECORD;     
BEGIN
      if p_format = 'json' then p_dop_param := '?json'; end if;
      p_url := 'https://bank.gov.ua/depo_securities'||p_dop_param;

      -- запрашиваем данные
      p_response_body := p_service.get(p_uri => p_url, p_decode => 'utf-8'); 
     
      --RAISE EXCEPTION 'p_response_body %.', p_response_body;
                          
      -- добавить историю
      p_rezult := p_interface.add_import_data_type(p_type_oper => 'isin_secur', p_data_type => p_format, p_data_value => p_response_body);                   
       
       if p_format = 'json'            
       then
          if p_check.is_valid_json(p_response_body) = 'T'
          then  		
              for k in    select (e.item ->> 'cpcode') as cpcode,
  			                     (e.item ->> 'nominal') as nominal,
  			                     p_convert.str_to_num((e.item ->> 'auk_proc')) as auk_proc,
  			                     p_convert.str_to_date((e.item ->> 'pgs_date'),'yyyy-mm-dd') as pgs_date,
  			                     p_convert.str_to_date((e.item ->> 'razm_date'),'yyyy-mm-dd') as razm_date,
  			                     (e.item ->> 'cptype') as cptype,
  			                     (e.item ->> 'cpdescr') as cpdescr,
  			                     (e.item ->> 'pay_period') as pay_period,
  			                     (e.item ->> 'val_code') as val_code,
  			                     (e.item ->> 'emit_okpo') as emit_okpo,
  			                     (e.item ->> 'emit_name') as emit_name,
  			                     (e.item ->> 'cptype_nkcpfr') as cptype_nkcpfr,
  			                     (e.item ->> 'cpcode_cfi') as cpcode_cfi,
  			                     (e.item ->> 'pay_period') as total_bonds,
  			                     (e.item ->> 'payments') as payments  			                     
                            from jsonb_path_query(p_response_body::jsonb, '$[*]') as e(item)                         
               loop             
                  if k.payments is null
                  then  
                      p_isin_secur_row.cpcode := k.cpcode;
                      p_isin_secur_row.nominal := k.nominal;
                      p_isin_secur_row.auk_proc := k.auk_proc;
                      p_isin_secur_row.pgs_date := k.pgs_date;
                      p_isin_secur_row.razm_date := k.razm_date;
                      p_isin_secur_row.cptype := k.cptype;
                      p_isin_secur_row.cpdescr := k.cpdescr;
                      p_isin_secur_row.pay_period := k.pay_period;
                      p_isin_secur_row.val_code := k.val_code;
                      p_isin_secur_row.emit_okpo := k.emit_okpo;
                      p_isin_secur_row.emit_name := k.emit_name;
                      p_isin_secur_row.cptype_nkcpfr := k.cptype_nkcpfr;
                      p_isin_secur_row.cpcode_cfi := k.cpcode_cfi;
                      p_isin_secur_row.total_bonds := k.total_bonds;
                      p_isin_secur_row.pay_date := null;
                      p_isin_secur_row.pay_type := null;
                      p_isin_secur_row.pay_val := null;
                      p_isin_secur_row.pay_array := null;
                      return next p_isin_secur_row;
                  else
                      -- периоды
                      for kk in select p_convert.str_to_date((e.item ->> 'pay_date'),'yyyy-mm-dd') as pay_date,
		  			                   (e.item ->> 'pay_type') as pay_type,
		  			                   (e.item ->> 'pay_val') as pay_val,
		  			                   (e.item ->> 'array') as pay_array 			                     
	                            from jsonb_path_query(k.payments::jsonb, '$[*]') as e(item)                          
                      loop          
                          p_isin_secur_row.cpcode := k.cpcode;
                          p_isin_secur_row.nominal := k.nominal;
                          p_isin_secur_row.auk_proc := k.auk_proc;
                          p_isin_secur_row.pgs_date := k.pgs_date;
                          p_isin_secur_row.razm_date := k.razm_date;
                          p_isin_secur_row.cptype := k.cptype;
                          p_isin_secur_row.cpdescr := k.cpdescr;
                          p_isin_secur_row.pay_period := k.pay_period;
                          p_isin_secur_row.val_code := k.val_code;
                          p_isin_secur_row.emit_okpo := k.emit_okpo;
                          p_isin_secur_row.emit_name := k.emit_name;
                          p_isin_secur_row.cptype_nkcpfr := k.cptype_nkcpfr;
                          p_isin_secur_row.cpcode_cfi := k.cpcode_cfi;
                          p_isin_secur_row.total_bonds := k.total_bonds;
                          p_isin_secur_row.pay_date := kk.pay_date;
                          p_isin_secur_row.pay_type := kk.pay_type;
                          p_isin_secur_row.pay_val := kk.pay_val;
                          p_isin_secur_row.pay_array := kk.pay_array;
                          return next p_isin_secur_row;
                      end loop;
                   end if;
               end loop;
           end if;
       else  
          if p_check.is_valid_xml(p_response_body) = 'T'
          then  
              for k in select t.cpcode,
                              t.nominal,                                      
                              p_convert.str_to_num(t.auk_proc) as auk_proc,
                              p_convert.str_to_date(t.pgs_date,'yyyy-mm-dd') as pgs_date,
                              p_convert.str_to_date(t.razm_date,'yyyy-mm-dd') as razm_date,
                              t.cptype,
                              t.cpdescr,
                              t.pay_period,                                      
                              t.val_code,                                      
                              t.emit_okpo,
                              t.emit_name,
                              t.cptype_nkcpfr,
                              t.cpcode_cfi,
                              t.total_bonds,
                              t.payments
                          from xmltable('//security' passing (p_response_body::xml)
                                           columns                 
                                              cpcode          varchar(255) path 'cpcode',
                                              nominal         numeric      path 'nominal',                                      
                                              auk_proc        varchar(255) path 'auk_proc',                                      
                                              pgs_date        varchar(255) path 'pgs_date',                                      
                                              razm_date       varchar(255) path 'razm_date',                                      
                                              cptype          varchar(255) path 'cptype',
                                              cpdescr         varchar(255) path 'cpdescr',
                                              pay_period      numeric      path 'pay_period',                                      
                                              val_code        varchar(3)   path 'val_code',                                      
                                              emit_okpo       varchar(255) path 'emit_okpo',
                                              emit_name       varchar(255) path 'emit_name',
                                              cptype_nkcpfr   varchar(255) path 'cptype_nkcpfr',
                                              cpcode_cfi      varchar(255) path 'cpcode_cfi',
                                              total_bonds     numeric      path 'pay_period',                                          
                                              payments        xml          path 'payments'
                                            ) t  
               loop             
                  if k.payments is null
                  then  
                      p_isin_secur_row.cpcode := k.cpcode;
                      p_isin_secur_row.nominal := k.nominal;
                      p_isin_secur_row.auk_proc := k.auk_proc;
                      p_isin_secur_row.pgs_date := k.pgs_date;
                      p_isin_secur_row.razm_date := k.razm_date;
                      p_isin_secur_row.cptype := k.cptype;
                      p_isin_secur_row.cpdescr := k.cpdescr;
                      p_isin_secur_row.pay_period := k.pay_period;
                      p_isin_secur_row.val_code := k.val_code;
                      p_isin_secur_row.emit_okpo := k.emit_okpo;
                      p_isin_secur_row.emit_name := k.emit_name;
                      p_isin_secur_row.cptype_nkcpfr := k.cptype_nkcpfr;
                      p_isin_secur_row.cpcode_cfi := k.cpcode_cfi;
                      p_isin_secur_row.total_bonds := k.total_bonds;
                      p_isin_secur_row.pay_date := null;
                      p_isin_secur_row.pay_type := null;
                      p_isin_secur_row.pay_val := null;
                      p_isin_secur_row.pay_array := null;
                      return next p_isin_secur_row;
                  else
                      -- периоды
                      for kk in select  p_convert.str_to_date(t.pay_date,'yyyy-mm-dd') as pay_date,
                                        t.pay_type,                                      
                                        p_convert.str_to_num(t.pay_val) as pay_val,
                                        t.pay_array
                                    from xmltable('//payment' passing k.payments
                                                     columns                 
                                                        pay_date        varchar(255) path 'pay_date',
                                                        pay_type        numeric      path 'pay_type',                                      
                                                        pay_val         varchar(255) path 'pay_val',                                      
                                                        pay_array       varchar(255) path 'array'
                                                      ) t  
                      loop          
                          p_isin_secur_row.cpcode := k.cpcode;
                          p_isin_secur_row.nominal := k.nominal;
                          p_isin_secur_row.auk_proc := k.auk_proc;
                          p_isin_secur_row.pgs_date := k.pgs_date;
                          p_isin_secur_row.razm_date := k.razm_date;
                          p_isin_secur_row.cptype := k.cptype;
                          p_isin_secur_row.cpdescr := k.cpdescr;
                          p_isin_secur_row.pay_period := k.pay_period;
                          p_isin_secur_row.val_code := k.val_code;
                          p_isin_secur_row.emit_okpo := k.emit_okpo;
                          p_isin_secur_row.emit_name := k.emit_name;
                          p_isin_secur_row.cptype_nkcpfr := k.cptype_nkcpfr;
                          p_isin_secur_row.cpcode_cfi := k.cpcode_cfi;
                          p_isin_secur_row.total_bonds := k.total_bonds;
                          p_isin_secur_row.pay_date := kk.pay_date;
                          p_isin_secur_row.pay_type := kk.pay_type;
                          p_isin_secur_row.pay_val := kk.pay_val;
                          p_isin_secur_row.pay_array := kk.pay_array;
                          return next p_isin_secur_row;
                      end loop;
                   end if;
               end loop;
           end if;
       end if;

       return;
    end;

$BODY$;

ALTER FUNCTION p_interface.read_isin_secur(character varying)
    OWNER TO testdb;

-- FUNCTION: p_interface.read_kurs_nbu(timestamp without time zone, text, text)
-- DROP FUNCTION IF EXISTS p_interface.read_kurs_nbu(timestamp without time zone, text, text);

CREATE OR REPLACE FUNCTION p_interface.read_kurs_nbu(
	p_date timestamp without time zone,
	p_format character varying,
	p_currency text DEFAULT NULL::text)
    RETURNS TABLE(r030 character varying, txt character varying, rate numeric, cc character varying, exchangedate timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    STABLE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
     -- Курсы валют НБУ
     -- Получить данные
     -- select t.* from p_interface.read_kurs_nbu(p_convert.str_to_date('05.05.2021'), 'json', 'USD') t            
      p_url                  varchar(255) := '';
      p_response_body        text;
      p_dop_param            varchar(5) := '';
      p_rezult			     int;     
BEGIN
      if p_format = 'json' then p_dop_param := '&json'; end if;

      if p_currency is null
      then  
         p_url := 'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date='||to_char(p_date,'yyyymmdd')||p_dop_param;
      else
         p_url := 'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?valcode='||p_currency||'&date='||to_char(p_date,'yyyymmdd')||p_dop_param;
      end if;

       -- запрашиваем данные
       p_response_body := p_service.get(p_uri => p_url, p_decode => 'utf-8'); 
      
      --RAISE EXCEPTION 'p_response_body %.', p_response_body;

      -- добавить историю
      p_rezult := p_interface.add_import_data_type(p_type_oper => 'kurs_nbu', p_data_type => p_format, p_data_value => p_response_body);                         
       
       if p_format = 'json'            
       then
          if p_check.is_valid_json(p_response_body) = 'T'
          then  
  			 return query select lpad(e.item ->> 'r030',3,'0')::varchar(3) as r030,
						         (e.item ->> 'txt')::varchar(255) as txt,
						         p_convert.str_to_num((e.item ->> 'rate')) as rate,
						         (e.item ->> 'cc')::varchar(3) as cc,
						         p_convert.str_to_date((e.item ->> 'exchangedate')) as exchangedate      
                            from jsonb_path_query(p_response_body::jsonb, '$[*]') as e(item);
			
			  -- Так как выполнение ещё не закончено, можно проверить, были ли возвращены строки, и выдать исключение, если нет.
			  --if not found 
			  --then
			  --   RAISE EXCEPTION 'Нет курсов на дату: %.', p_date;
			  --end if;			
           end if;
       else
          if p_check.is_valid_xml(p_response_body) = 'T'
          then
              return query select lpad(j.r030,3,'0')::varchar(3) as r030,
	                               j.txt::varchar(255) as txt,
	                               p_convert.str_to_num(j.rate) as rate,
	                               j.cc::varchar(3) as cc,
	                               p_convert.str_to_date(j.exchangedate) as exchangedate
	                          from xmltable('//exchange/currency' passing (p_response_body::xml)
	                                 columns 
	                                         r030 varchar(3)   path 'r030',
	                                         txt  varchar(255) path 'txt',
	                                         rate varchar(255) path 'rate',                       
	                                         cc   varchar(255) path 'cc',                       
	                                         exchangedate varchar(255) path 'exchangedate'                       
	                                         ) j;     
           null;          
           end if;
       end if;

       return;
    end;

$BODY$;

ALTER FUNCTION p_interface.read_kurs_nbu(timestamp without time zone, character varying, text)
    OWNER TO testdb;

   
CREATE OR REPLACE FUNCTION public.instr(str text, sub text, startpos integer DEFAULT 1, occurrence integer DEFAULT 1)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare 
    tail text;
    shift int;
    pos int;
    i int;
begin
    shift:= 0;
    if startpos = 0 or occurrence <= 0 then
        return 0;
    end if;
    if startpos < 0 then
        str:= reverse(str);
        sub:= reverse(sub);
        pos:= -startpos;
    else
        pos:= startpos;
    end if;
    for i in 1..occurrence loop
        shift:= shift+ pos;
        tail:= substr(str, shift);
        pos:= strpos(tail, sub);
        if pos = 0 then
            return 0;
        end if;
    end loop;
    if startpos > 0 then
        return pos+ shift- 1;
    else
        return length(str)- length(sub)- pos- shift+ 3;
    end if;
end $function$
;

-----------------------------------------------------
-- DROP SCHEMA p_service;

CREATE SCHEMA p_service AUTHORIZATION testdb;

CREATE OR REPLACE FUNCTION p_service.get(p_uri character varying, p_decode character varying DEFAULT ''::character varying)
 RETURNS text
 LANGUAGE plpython3u
AS $function$
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

req = Request(p_uri)
try:
    response = urlopen(req)
except HTTPError as e:
     print('Oops. HTTP Error occured')
     print('Response is: {content}'.format(content = e.response.content))
     print('Error code: ', e.code)    
except URLError as e:
    print('We failed to reach a server.')
    print('Reason: ', e.reason)
else:    
    if p_decode == '':
        data = response.read()
    else:    
        data = response.read().decode(p_decode)
     
return data  
     
$function$
;

CREATE OR REPLACE FUNCTION p_service.post(p_uri character varying, p_request_body json, p_paramenters json DEFAULT '[]'::json, p_decode character varying DEFAULT ''::character varying)
 RETURNS json
 LANGUAGE plpython3u
AS $function$
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

clen = len(p_paramenters)
req = Request(p_uri, p_paramenters, {'Content-Type': 'application/json', 'Content-Length': clen})
try:
    response = urlopen(req, p_request_body.encode('utf-8'))
except HTTPError as e:
     print('Oops. HTTP Error occured')
     print('Response is: {content}'.format(content = e.response.content))
     print('Error code: ', e.code)    
except URLError as e:
    print('We failed to reach a server.')
    print('Reason: ', e.reason)
else:    
    if p_decode == '':
        data = response.read()
    else:    
        data = response.read().decode(p_decode)
     
return data  
     
$function$
;

CREATE OR REPLACE FUNCTION p_service.send_email(_from text, _password text, smtp text, port integer, bcc text, receiver text, subject text, send_message text)
 RETURNS text
 LANGUAGE plpython3u
AS $function$
# -------------------------------------------------------
# Отправка сообщений через функцию в базе данных
# _from - логин и e-mail пользователя
# _password - пароль пользователя
# smtp - адрес почтового сервера smtp
# port - порт почтового сервера smtp
# bcc - e-mail получателя (скрытая копия)
# receiver - e-mail получателя
# subject - тема письма
# send_message - текст письма
# -------------------------------------------------------
import smtplib
from smtplib import SMTPException
message = ("From: %snTo: %snBcc: %snMIME-Version: 1.0nContent-type: text/htmlnSubject: %snn %s" % (_from,receiver,bcc,subject,send_message))
try:
  smtpObj = smtplib.SMTP(smtp,port)
  smtpObj.starttls()
  smtpObj.login(_from, _password)
  smtpObj.sendmail(_from,receiver,message.encode('utf-8'))
  print ('Successfully sent email')
except SMTPException:
  print ('Error: unable to send email')
return message
$function$
;
