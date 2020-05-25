
-- завдання:
-- створити функцію, що по заданій країні повертає таблицю з інвестиціями у кожен стартап, з цієї країни
-- В таблиці буде міститись id інфестиції, назва стартапу, його місто, розмір двох видів інвестицій


CREATE OR REPLACE TYPE inv_data AS OBJECT (
        inv_id NUMBER(10)
    , start_name VARCHAR2(50)
    , start_city  VARCHAR2(40)
    , inv_seed NUMBER(10)
    , inv_venture NUMBER(10)
);

/
CREATE OR REPLACE TYPE inv_table IS TABLE OF inv_data;

/
CREATE OR REPLACE FUNCTION investments_by_Country
    (param_country COUNTRYCODE.COUNTRY_CODE%TYPE)
    RETURN inv_table
    PIPELINED
    IS
        CURSOR cursor_invest IS
                SELECT
                    INVESTMENT.INVSTID as inv_id
                    , strtp.STARTUP_NAME as start_name
                    , strtp.CITY_NAME as start_city
                    , INVESTMENT.SEED as inv_seed
                    , INVESTMENT.VENTURE as inv_venture
                FROM (
                        SELECT STARTUP_NAME, CITY_NAME FROM CITY
                        JOIN STARTUP ON CITY.CITY_NAME = STARTUP.CITY
                        WHERE COUNTRY_CODE = param_country
                    ) strtp JOIN INVESTMENT
                        ON INVESTMENT.NAME = strtp.STARTUP_NAME
                GROUP BY strtp.CITY_NAME, strtp.STARTUP_NAME, INVESTMENT.INVSTID, INVESTMENT.SEED,INVESTMENT.VENTURE
                ORDER BY INVESTMENT.SEED;
    BEGIN
        FOR invest_row IN cursor_invest
        LOOP
            PIPE ROW(inv_data(
                                invest_row.inv_id
                                , invest_row.start_name
                                , invest_row.start_city
                                , invest_row.inv_seed
                                , invest_row.inv_venture
            ));
        END LOOP;
    END;

