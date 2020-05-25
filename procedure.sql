--Додає інвестора та стартап. Exception: інвестор чи стартап не існує

BEGIN
    DBMS_OUTPUT.enable;
END;
/

CREATE OR REPLACE PROCEDURE add_investment_to_startup(
    start_name STARTUP.STARTUP_NAME%TYPE,
    seed_val INVESTMENT.SEED%TYPE ,
    venture_val INVESTMENT.VENTURE%TYPE
    )
IS
    found NUMBER;
    startup_exception EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO found FROM STARTUP
    WHERE STARTUP_NAME = start_name;
    IF found != 1 THEN
        RAISE startup_exception;
    ELSE
        INSERT INTO INVESTMENT(name, seed, venture)
        VALUES (start_name, seed_val,venture_val);
    END IF;
EXCEPTION
  WHEN startup_exception THEN
    DBMS_OUTPUT.put_line('Error:');
    DBMS_OUTPUT.put_line('Startup does not exist');
END;
