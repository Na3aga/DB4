BEGIN
    DBMS_OUTPUT.enable;
END;
SET SERVEROUTPUT ON;
DECLARE
    s_name STARTUP.STARTUP_NAME%TYPE;
    seed_v INVESTMENT.SEED%TYPE;
    venture_v INVESTMENT.VENTURE%TYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('STARTING THE PROCEDURE TESTING:');
  DBMS_OUTPUT.PUT_LINE(' ');

  s_name := 'Grammarly';
  seed_v := 1000;
  venture_v := 3000;
  add_investment_to_startup(
    start_name => s_name,
    seed_val => seed_v,
    venture_val => venture_v
  );
  DBMS_OUTPUT.PUT_LINE(' ');

  s_name := 'Onion';
  seed_v := 44000;
  venture_v := 0;
  add_investment_to_startup(
    start_name => s_name,
    seed_val => seed_v,
    venture_val => venture_v
  );
  DBMS_OUTPUT.PUT_LINE(' ');

  s_name := 'Grandpa';
  seed_v := 10000000;
  venture_v := 10000000;
  add_investment_to_startup(
    start_name => s_name,
    seed_val => seed_v,
    venture_val => venture_v
  );
   DBMS_OUTPUT.PUT_LINE(' ');
END;

DECLARE
    v1 INVESTMENT.invstid%TYPE ;
    v2 STARTUP.STARTUP_NAME%TYPE ;
    v3 STARTUP.CITY%TYPE ;
    v4 INVESTMENT.SEED%TYPE;
    v5 INVESTMENT.VENTURE%TYPE;
    CURSOR test_f IS SELECT * FROM TABLE(investments_by_Country('UA'));
BEGIN
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('STARTING THE FUNCTION TESTING:');
  DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('| inv_id | start_name | start_city | inv_seed | inv_venture |');
    FOR record IN test_f LOOP
        v1 := record.inv_id;
        v2 := record.start_name;
        v3 := record.start_city;
        v4 := record.inv_seed;
        v5 := record.inv_venture;
        DBMS_OUTPUT.PUT_LINE('| '||v1||' | '||v2||' | '||v3||' | '||v4||' | '||v5||'|');
    END LOOP;

END;
