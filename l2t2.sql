--Процедура списания книг, изданных более 50 лет назад (перенос в архив). При этом
--если какого-либо из опубликованных в книге произведений нет больше ни в одной
--книге, то данные об этом произведении удаляются в архив.

create or replace procedure archive is
    cursor c1 is select *
                 from BOOK_CATALOG;
    cursor c2(ed_code CONTENT.book%TYPE) is select *
                                            from CONTENT
                                            where BOOK = ed_code;
    cursor book_for_deletion(id_to_del PRODUCT_ARCHIVE.ID%TYPE) is select *
                                                                   from PRODUCTS
                                                                   where ID = id_to_del;
    cur_year       varchar(4);
    any_rows_found number;
    ed_code        book_catalog.edition_code%TYPE;

begin
    select to_char(sysdate, 'YYYY') into cur_year from dual; --получим текущий год
    for cc in c1 --пойдём по всем книгам в каталоге
        loop
            if (cur_year - cc.PUBLISHMENT_YEAR) > 50 then --если старше, то перенесём в архив
                ed_code := cc.EDITION_CODE;
                insert into BOOK_ARCHIVE(edition_code, name, publisher, publishment_year, pages, commentary)
                values (cc.EDITION_CODE, cc.NAME, cc.PUBLISHER, cc.PUBLISHMENT_YEAR, cc.PAGES, cc.COMMENTARY);
                delete from BOOK_CATALOG where EDITION_CODE = cc.EDITION_CODE;

                for prod in c2(cc.EDITION_CODE) --далее проверка что произведения нет больше ни в одной книге. Тк в одной книге может быть больше одного произведения, то обходим все
                    loop
                        select count(*)
                        into any_rows_found
                        from CONTENT
                        where PRODUCT = prod.PRODUCT
                          and BOOK != cc.EDITION_CODE;
                        if any_rows_found = 0 then --проверка, что произведения больше нет ни в одной книге
                            for k in book_for_deletion(prod.PRODUCT) --это несколько глупая часть, но я гарантированно в этом курсоре
                                loop
                                    --имею только одну запись, тк все ID уникальны, поэтому я хотел бы получить данные из
                                    insert into PRODUCT_ARCHIVE --этого курсора не увеличивая количество переменных, чтоб использовать данные в этом insert,
                                    values (k.ID, k.TITLE, k.TYPE); --поэтому тут возникает этот цикл
                                    delete from PRODUCTS where ID = k.ID;
                                end loop;
                        end if;
                    end loop;
            end if;
        end loop;
exception
    when DUP_VAL_ON_INDEX then
        DBMS_OUTPUT.PUT_LINE('Книга с кодом издания ' || ed_code || ' уже есть в архиве');
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Таблица пуста');
end;

--Процедура вывода содержания книги по её шифру
create or replace procedure show_content(ed_code book_catalog.edition_code%TYPE) is
    cursor c1(ed_code book_catalog.edition_code%TYPE ) is select edition_code,
                                                                 name,
                                                                 publisher,
                                                                 publishment_year,
                                                                 commentary,
                                                                 products.title,
                                                                 products.type,
                                                                 products.ID
                                                          from book_catalog,
                                                               content,
                                                               products
                                                          where book_catalog.edition_code = content.book
                                                            and content.product = products.id
                                                            and edition_code = ed_code;
    cursor c2(ident products.ID%TYPE) is select authors.surname, authors.name, authors.patronymic
                                         from product_authors
                                                  join authors
                                                       on product_authors.product = ident and product_authors.author = authors.id;
    any_rows_found   number;
    counter          int;
    internal_counter int;
    edition_code     book_catalog.edition_code%TYPE;
    name             book_catalog.name%TYPE;
    publisher        book_catalog.publisher%TYPE;
    publishment_year book_catalog.publishment_year%TYPE;
    commentary       book_catalog.commentary%TYPE;
    title            products.title%TYPE;
    type1            products.type%TYPE;
    filler           products.ID%TYPE;

    no_data exception;
begin

    open c1(ed_code);
    fetch c1 into edition_code, name, publisher, publishment_year, commentary, title, type1, filler;
    close c1;
    if edition_code is null then
        raise no_data;
    end if;
    DBMS_OUTPUT.PUT_LINE(edition_code || '. ' || concat(name, ' ') || concat(isold(publishment_year, commentary), ' ')
        || concat(publishment_year, ' ') || publisher);
    DBMS_OUTPUT.PUT_LINE('Содержание:');
    counter := 1;
    for cc in c1(ed_code)
        loop
            internal_counter := counter;
            select count(*) --проверка есть ли у произведения авторы
            into any_rows_found
            from product_authors
                     join authors
                          on product_authors.product = cc.ID and product_authors.author = authors.id;
            if any_rows_found != 0 then
                title := cc.TITLE;
                type1 := cc.TYPE;
                for cc2 in c2(cc.ID)
                    loop
                        DBMS_OUTPUT.PUT_LINE(concat(internal_counter, ' ') || INITIALS_SHORTER(
                                concat(concat(cc2.SURNAME, ' '), concat(concat(cc2.NAME, ' '), cc2.PATRONYMIC)))
                            || ' ' || concat(title, ' ') || type1);
                        internal_counter := null;
                        title := null;
                        type1 := null;
                    end loop;
            else
                DBMS_OUTPUT.PUT_LINE(counter || ' Без автора ' || concat(cc.TITLE, ' ') || cc.TYPE);
            end if;
            counter := counter + 1;
        end loop;
exception
    when no_data then
        DBMS_OUTPUT.PUT_LINE('Такой книги нет');
    when PROGRAM_ERROR then
        DBMS_OUTPUT.PUT_LINE('Что-то пошло не так');
end;


--Процедура, выдающая на экран библиографическое описание книги
create or replace procedure bibliography(ed_code book_catalog.edition_code%TYPE) is
    cursor c1(ident products.ID%TYPE) is select authors.surname, authors.name, authors.patronymic
                                         from product_authors
                                                  join authors
                                                       on product_authors.product = ident and product_authors.author = authors.id;
    any_rows_found   number;
    edition_code     book_catalog.edition_code%TYPE;
    name             book_catalog.name%TYPE;
    publisher        book_catalog.publisher%TYPE;
    publishment_year book_catalog.publishment_year%TYPE;
    commentary       book_catalog.commentary%TYPE;
    title            products.title%TYPE;
    type1            products.type%TYPE;
    ident            products.ID%TYPE;
    pages            book_catalog.pages%TYPE;

    no_data exception;
begin
    select count(*)
    into any_rows_found
    from book_catalog,
         content,
         products
    where book_catalog.edition_code = content.book
      and content.product = products.id
      and edition_code = ed_code;

    if any_rows_found = 1 then
        select edition_code,
               name,
               publisher,
               publishment_year,
               PAGES,
               products.title,
               products.type,
               products.ID
        into edition_code, name, publisher, publishment_year, pages, title, type1, ident
        from book_catalog,
             content,
             products
        where book_catalog.edition_code = content.book
          and content.product = products.id
          and edition_code = ed_code;

        select count(*) --проверка есть ли у произведения авторы
        into any_rows_found
        from product_authors
                 join authors
                      on product_authors.product = ident and product_authors.author = authors.id;

        if any_rows_found != 0 then
            for cc in c1(ident)
                loop
                    DBMS_OUTPUT.PUT(INITIALS_SHORTER(
                                            concat(concat(cc.SURNAME, ' '),
                                                   concat(concat(cc.NAME, ' '), cc.PATRONYMIC))) || ', ');
                end loop;
        end if;
        if name = title then
            title := null;
        end if;
        DBMS_OUTPUT.PUT_LINE(name || '. ' || title || ' (' || type1 || '). ' ||
                             publisher || ', ' || publishment_year || '. ' || pages || ' c.');
    elsif any_rows_found > 1 then
        select name,
               publisher,
               publishment_year,
               PAGES,
               COMMENTARY
        into name, publisher, publishment_year, pages, commentary
        from book_catalog
        where edition_code = ed_code;

        DBMS_OUTPUT.PUT_LINE(name || '. (' || commentary || ') ' || publisher || ', ' ||
                             publishment_year || '. ' || pages || ' c.');

    else
        raise no_data;
    end if;
exception
    when PROGRAM_ERROR then
        DBMS_OUTPUT.PUT_LINE('Что-то пошло не так');
    when no_data then
        DBMS_OUTPUT.PUT_LINE('Такой книги нет');
end;

begin
    --archive;
    --show_content('edition003');
    BIBLIOGRAPHY('edition004');
end;