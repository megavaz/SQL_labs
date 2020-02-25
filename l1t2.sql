
-- проверка старины издания

create or replace function isold(year number, commentary string) return string is
        cur_year varchar(4);
    begin
        select to_char(sysdate, 'YYYY') into cur_year from dual;

        if ((cur_year - year) >= 20 and (commentary = 'Учебник')) then
            return 'старое издание';
        elsif ((cur_year - year) >= 10 and (commentary = 'Справочник')) then
            return 'старое издание';
        elsif (cur_year - year) >= 30 then
            return 'старое издание';
        else return '';
        end if;
    end;


-- укорачивание места издания

create or replace function publishment_place_shorter(publishment_place string) return string is
    begin
        if publishment_place = 'Москва' then
            return 'М';
        elsif publishment_place = 'Ленинград' then
            return 'Л';
        elsif publishment_place = 'Минск' then
            return 'Мн';
        elsif publishment_place = 'Киев' then
            return 'К';
        elsif publishment_place = 'Санкт-Петербург' then
            return 'СПб';
        else
            return '';
        end if;
    end;

-- преобразование фио в фамилию с инициалами

create or replace function initials_shorter(initials string, flag number default (0)) return string is
        spaces number;
        surname string(50);
        name string(50);
        patronymic string(50);
    begin
        spaces := regexp_count(initials, ' ');
        -- проверка
        if spaces != 2 then
            if flag = 0 then
                return initials;
            else
                return '###########';
            end if;
        end if;
        -- получить нужные инициалы
        surname := REGEXP_SUBSTR(initials,'.*?\s');
        name := REGEXP_SUBSTR(initials,' .');
        patronymic := REGEXP_SUBSTR(initials,' .', 1, 2);
        -- убрать лишние пробелы
        name := trim(name);
        patronymic := trim(patronymic);
        -- добавить точки
        name := concat(name,'.');
        patronymic := concat(patronymic,'.');
        --объединить инициалы
        return concat(surname, concat(name, patronymic));
    end;

-- проверка работы функций

begin
    dbms_output.put_line(isold(1994, 'Учебник'));
    dbms_output.put_line(publishment_place_shorter('Санкт-Петербург'));
    DBMS_OUTPUT.PUT_LINE(initials_shorter('Тургенев Иван Сергеевич'));
    DBMS_OUTPUT.PUT_LINE(initials_shorter('Пушкин Александр', 1));
end;