CREATE OR REPLACE PACKAGE startup_pack IS
    TYPE Invest_data IS RECORD (
        inv_id INVESTMENT.INVSTID%TYPE
        , start_name STARTUP.STARTUP_NAME%TYPE
        , start_city CITY.CITY_NAME%TYPE
        , inv_seed INVESTMENT.SEED%TYPE
        , inv_venture INVESTMENT.VENTURE%TYPE
        );

    TYPE Inv_table IS TABLE OF Invest_data;

    FUNCTION investments_by_Country(param_country COUNTRYCODE.COUNTRY_CODE%TYPE)
        RETURN Inv_table
        PIPELINED;

    PROCEDURE add_investment_to_startup(start_name STARTUP.STARTUP_NAME%TYPE,
                                        seed_val INVESTMENT.SEED%TYPE,
                                        venture_val INVESTMENT.VENTURE%TYPE);
END startup_pack;

CREATE OR REPLACE PACKAGE BODY startup_pack IS
    FUNCTION investments_by_Country(param_country COUNTRYCODE.COUNTRY_CODE%TYPE)
        RETURN Inv_table
        PIPELINED
        IS
        CURSOR cursor_invest IS
            SELECT INVESTMENT.INVSTID as inv_id
                 , strtp.STARTUP_NAME as start_name
                 , strtp.CITY_NAME    as start_city
                 , INVESTMENT.SEED    as inv_seed
                 , INVESTMENT.VENTURE as inv_venture
            FROM (
                     SELECT STARTUP_NAME, CITY_NAME
                     FROM CITY
                              JOIN STARTUP ON CITY.CITY_NAME = STARTUP.CITY
                     WHERE COUNTRY_CODE = param_country
                 ) strtp
                     JOIN INVESTMENT
                          ON INVESTMENT.NAME = strtp.STARTUP_NAME
            GROUP BY strtp.CITY_NAME, strtp.STARTUP_NAME, INVESTMENT.INVSTID, INVESTMENT.SEED, INVESTMENT.VENTURE
            ORDER BY INVESTMENT.SEED;
    BEGIN
        FOR invest_row IN cursor_invest
            LOOP
                PIPE ROW (invest_row);
            END LOOP;
    END investments_by_Country;


    PROCEDURE add_investment_to_startup(start_name STARTUP.STARTUP_NAME%TYPE,
                                        seed_val INVESTMENT.SEED%TYPE,
                                        venture_val INVESTMENT.VENTURE%TYPE) IS
        found NUMBER;
        startup_exception EXCEPTION;
    BEGIN
        SELECT COUNT(*)
        INTO found
        FROM STARTUP
        WHERE STARTUP_NAME = start_name;
        IF found != 1 THEN
            RAISE startup_exception;
        ELSE
            INSERT INTO INVESTMENT(name, seed, venture)
            VALUES (start_name, seed_val, venture_val);
        END IF;
    EXCEPTION
        WHEN startup_exception THEN
            DBMS_OUTPUT.put_line('Error:');
            DBMS_OUTPUT.put_line('Startup does not exist');
    END add_investment_to_startup;
END startup_pack;
