/* Дмитрий Нечаев
   Вариант 5, Лабораторная 1
*/
create table book_catalog
(
    edition_code     varchar(10),
    PRIMARY KEY (edition_code),
    name             varchar(80) NOT NULL,
    publisher        varchar(25) not null,
    publishment_year numeric(4)  not null,
    pages            numeric(4),
    comment          varchar(40) default 'Сборник'
);

create table authors
(
    id         mediumint   not null auto_increment,
    PRIMARY KEY (id),
    surname    varchar(20) not null,
    name       varchar(20) not null,
    patronymic varchar(20)
);

create table product
(
    id    mediumint   not null auto_increment,
    PRIMARY KEY (id),
    title varchar(30) not null,
    type  varchar(20) not null
);

create table product_authors
(
    id     mediumint not null auto_increment,
    PRIMARY KEY (id),
    book   mediumint not null references products (id),
    author mediumint not null references authors (id)
);

create table content
(
    id      mediumint   not null auto_increment,
    PRIMARY KEY (id),
    product    mediumint   not null references products (id),
    book varchar(10) not null references book_catalog (edition_code)
);

insert into book_catalog (edition_code, name, publisher, publishment_year, pages)
VALUES ('edition001', 'Война и мир', 'Росмен', '1999', '2438'),
       ('edition002', 'Преступление и наказание', 'Росмен', '2003', '812'),
       ('edition003', 'Идиот', 'Росмен', '2005', '786'),
       ('edition004', 'Рассказы для детей', 'Детские книги', '2012', '132');

insert into authors (surname, name, patronymic)
values ('Толстой', 'Лев', 'Николаевич'),
       ('Достоевский', 'Федор', 'Михайлович'),
       ('Пушкин', 'Александр', 'Сергеевич');

insert into products (title, type)
values ('Война и мир', 'Роман'),
       ('Преступление и наказание', 'Роман'),
       ('Идиот', 'Роман'),
       ('Рассказы для детей', 'Сборник рассказов');

insert into product_authors (product, author)
values (1, 1),
       (2, 2),
       (3, 2),
       (4, 3);

insert into content (product, book)
values ('1', 'edition001'),
       ('2', 'edition002'),
       ('3', 'edition003'),
       ('4', 'edition004');




