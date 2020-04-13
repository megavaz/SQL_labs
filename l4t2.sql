create or replace procedure transform_date(table_name varchar2, field1 varchar2, field2 varchar2) as
    day          string(10);
    month        string(10);
    year         string(10);
    str          string(250);
    cur          integer;
    result       integer;
    text         string(10);
    my_null      integer;
    command      string(250);
begin
    my_null := NULL;
    str := 'select ' || field1 || ' from ' || table_name;
    cur := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur, str, dbms_sql.v7);
    DBMS_SQL.DEFINE_COLUMN(cur, 1, text, 10);
    result := DBMS_SQL.EXECUTE(cur);

    loop
        exit when DBMS_SQL.FETCH_ROWS(cur) = 0;
        -- получим данные из очередной строки
        DBMS_SQL.COLUMN_VALUE(cur, 1, text);
        day := REGEXP_SUBSTR(text, '\d\d', 1, 1);
        month := REGEXP_SUBSTR(text, '\d\d', 1, 2);
        year := REGEXP_SUBSTR(text, '\d\d\d\d', 1, 1);

        if text != day || '.' || month || '.' || year then
            DBMS_OUTPUT.PUT_LINE(command);
            execute immediate 'UPDATE ' || table_name || ' SET ' || field2 || ' = :value  WHERE ' || field1 ||
                              ' = :value2' using my_null, text;
        elsif day > 31 or month > 12 then

            execute immediate 'UPDATE ' || table_name || ' SET ' || field2 || ' = :value  WHERE ' || field1 ||
                              ' = :value2' using my_null, text;
        else
            execute immediate 'UPDATE '|| table_name || ' SET ' || field2 || ' = :value  WHERE '|| field1 || ' = :value2' using year || '/' || month || '/' || day, text;

        end if;
    end loop;
    DBMS_SQL.CLOSE_CURSOR(cur);
end;

DECLARE
    field1     varchar2(10);
    field2     varchar2(10);
    table_name varchar2(10);
begin
    field1 := 'DATE1';
    field2 := 'DATE2';
    table_name := 'DATES';
    transform_date(table_name, field1, field2);
end;