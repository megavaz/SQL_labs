# создаю дополнительную таблицу для реализации односхемных операций

create table products2
(
    id    mediumint   not null,
    PRIMARY KEY (id),
    title varchar(30) not null,
    type  varchar(20) not null
);

INSERT INTO products2 (id, title, type)
VALUES (6, 'Репка', 'Сказка'),
       (7, 'Вам меня не испугать', 'Роман'),
       (8, 'Скандинавские боги', 'Роман'),
       (9, 'Хроники', 'Биография'),
       (10, 'Сказка о царе Салтане', 'Сказка'),
       (11, 'У лукоморья дуб зелёный', 'Сказка'),
       (16, 'Двенадцать стульев', 'Роман'),
       (17, 'Остров мира', 'Пьесса'),
       (18, 'Анна Каренина', 'Роман'),
       (19, 'Стив Джобс', 'Биография'),
       (20, 'Американские боги', 'Роман'),
       (21, 'Конёк-Горбунок', 'Сказка'),
       (22, 'Ворона и Лисица', 'Басня'),
       (23, 'Краткая история времени', 'Энциклопедия');

# Операция проекции

select distinct name, publishment_year
from book_catalog;

# Операция селекция

select *
from products
where type = 'Роман';

# Операция Декартово произведение

select *
from authors,
     product_authors;

# Операция объединение

select *
from products
union
select *
from products2;

# Операция разность. В mysql отсутствует MINUS,
# так что разность я реализую при помощи not in при условии уникальности id и соответсвующих данных

select *
from products
where id not in (select id from products2);

# Операция пересечение. Делаю так же при помощи not in

select *
from products
where id not in (select id
                 from products
                 where id not in (select id from products2));

# Операция соединение

select *
from authors,
     product_authors,
     products
where authors.id = product_authors.author
  and product_authors.product = products.id