--Реализация ограничения внешнего ключа.

create or replace trigger foreign_key_content
    before INSERT or UPDATE
    on CONTENT
    for each row
declare
    any_rows_found number;
    for_key exception;
begin
    select count(*)
    into any_rows_found
    from BOOK_CATALOG
    where EDITION_CODE = :NEW.BOOK;

    if any_rows_found = 0 then
        raise for_key;
    end if;


exception
    when for_key then
        raise_application_error(-20101, 'Запись с таким Edition Code отсутствует в родительской таблице');
    --DBMS_OUTPUT.PUT_LINE('Запись с таким ' || err_msg || ' отсутствует в оригинальной таблице');
end;


create or replace trigger foreign_key_book_catalog
    before delete
    on book_catalog
    for each row
declare
    any_rows_found number;
begin
    select count(*)
    into any_rows_found
    from CONTENT
    where BOOK = :OLD.EDITION_CODE;

    if any_rows_found != 0 then
        raise_application_error(-20105, 'Запись с таким Edition Code присутсвует в подчинённой таблице');
    end if;
end;
--Автоматизация переноса удаляемой книги в архив.
--код по большей части скопирован из процедуры из предыдущей лабы

create
    or
    replace trigger add_to_archive
    after
        DELETE
    on BOOK_CATALOG
    for each row
declare
    cursor c2(ed_code CONTENT.book%TYPE) is select *
                                            from CONTENT
                                            where BOOK = ed_code;
    cursor book_for_deletion(id_to_del PRODUCT_ARCHIVE.ID%TYPE) is select *
                                                                   from PRODUCTS
                                                                   where ID = id_to_del;
    any_rows_found number;

begin
    insert into BOOK_ARCHIVE(edition_code, name, publisher, publishment_year, pages, commentary)
    values (:OLD.EDITION_CODE, :OLD.NAME, :OLD.PUBLISHER, :OLD.PUBLISHMENT_YEAR, :OLD.PAGES, :OLD.COMMENTARY);
    for prod in c2(:OLD.EDITION_CODE)
        loop
            select count(*)
            into any_rows_found
            from CONTENT
            where PRODUCT = prod.PRODUCT
              and BOOK != :OLD.EDITION_CODE;
            if any_rows_found = 0 then
                for k in book_for_deletion(prod.PRODUCT)
                    loop
                        insert into PRODUCT_ARCHIVE
                        values (k.ID, k.TITLE, k.TYPE);
                        delete from PRODUCTS where ID = k.ID;
                    end loop;
            end if;
        end loop;
exception
    when DUP_VAL_ON_INDEX then
        DBMS_OUTPUT.PUT_LINE('Книга с кодом издания ' || :OLD.EDITION_CODE || ' уже есть в архиве');
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Таблица пуста');
end;

--Проверка значений всех полей отношения "Каталог книг",
--для которых могут быть определены домены

create or replace trigger sanity_check
    before insert or update
    on BOOK_CATALOG
    for each row
declare
    cur_year varchar(4);
begin
    select to_char(sysdate, 'YYYY') into cur_year from dual;
    if cur_year < :NEW.PUBLISHMENT_YEAR then
        raise_application_error(-20102, 'Год издания указан не правильно');
    elsif :NEW.PUBLISHMENT_YEAR < 1534 then --год основания издательства Кембриджского университета, первого издательства в мире
        raise_application_error(-20102, 'Год издания указан не правильно');
    end if;
    if :NEW.PAGES > 5000 then
        raise_application_error(-20103, 'Количество страниц указано неверно');
    elsif :NEW.PAGES < 1 then
        raise_application_error(-20103, 'Количество страниц указано неверно');
    end if;
end;


create table book_catalog_logs
(
    edition_code     varchar(10) not null
        primary key,
    name             varchar(80) not null,
    publisher        varchar(25) not null,
    publishment_year decimal(4)  not null,
    pages            decimal(4)  null,
    commentary       varchar(40),
    user_changer     varchar(40),
    date_of_update   date

);

--При изменении данных о книгах – копирование старых значений в специальную таблицу.
--Сохранять в этой таблице дату изменения и имя пользователя.

create or replace trigger audit_tab
    after update or delete
    on BOOK_CATALOG
    for each row
begin
    insert into book_catalog_logs
    values (:OLD.edition_code, :OLD.name, :OLD.publisher,
            :OLD.publishment_year, :OLD.pages, :OLD.commentary, user, sysdate);
end;
