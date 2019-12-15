EXPLAIN
select *
from book_catalog
where publishment_year between extract(year from sysdate()) - 3 and extract(year from sysdate())
order by publishment_year desc;

create index recent_books1 on book_catalog (name);
create index recent_books2 on book_catalog (publisher);
create index recent_books3 on book_catalog (publishment_year);
create index recent_books4 on book_catalog (pages);
create index recent_books5 on book_catalog (comment);

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором
# это первый способ
explain
select surname, name, patronymic, COUNT(*) cnt
from product_authors,
     authors
where authors.id = product_authors.author
group by surname, name, patronymic
order by cnt desc;

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором;
# это второй способ

explain
SELECT surname, name, patronymic, COUNT(title) cnt
FROM products
         join product_authors
              on products.id = product_authors.product
         join authors
              on product_authors.author = authors.id
group by surname, name, patronymic
order by cnt desc;

create index index1 on authors (surname, name, patronymic);
# Создать упорядоченный список произведений, у которых нет авторов;

explain
select title
from products
WHERE products.id
          NOT IN (select product
                  from product_authors);

create index title_i on products (title);
create index product_i on product_authors (product);

# Создать упорядоченный список произведений, которые есть в двух и более книгах;
explain
select products.id, title
from products,
     content
where products.id = content.product
group by products.id, title
having count(book) >= 2
order by title;


# Создать упорядоченный список книг, в числе авторов которых есть Чехов А.П.
explain
select title
from book_catalog,
     content,
     products,
     product_authors,
     authors
where book_catalog.edition_code = content.book
  and content.product = products.id
  and products.id = product_authors.product
  and product_authors.author = authors.id
  and authors.surname = 'Чехов'
  and authors.name = 'Антон'
  and authors.patronymic = 'Павлович'
order by title;


EXPLAIN
select book_catalog.*, products.type
from book_catalog,
     content,
     products
where book_catalog.edition_code = content.book
  and content.product = products.id
  and products.type = 'Роман'
  and book_catalog.edition_code in
      (select content.book
       from content
       group by content.book
       having count(*) = 1)
group by edition_code;


# это представление я создал скорее для теста, чтоб посмотреть updatable view,
# по-сути это список книг (элементов book_catalog), которые содержат в себе хотя бы один роман

EXPLAIN
select book_catalog.*, products.type
from book_catalog,
     content,
     products
where book_catalog.edition_code = content.book
  and content.product = products.id
  and products.type = 'Роман';

# тут вроде всё понятно, просто набор авторов, количество их книг и количество их публикаций

EXPLAIN
select authors.surname,
       authors.name,
       authors.patronymic,
       COUNT(distinct products.id)               number_of_products,
       COUNT(distinct book_catalog.edition_code) number_of_publishments
from book_catalog,
     content,
     products,
     product_authors,
     authors
where book_catalog.edition_code = content.book
  and content.product = products.id
  and products.id = product_authors.product
  and product_authors.author = authors.id
group by authors.surname,
         authors.name,
         authors.patronymic;


# в этом задании я не включаю в view авторов, которые хоть раз имели соавтора

EXPLAIN
select distinct authors.*
from authors,
     product_authors
where authors.id = product_authors.author
  and authors.id not in
      (select product_authors.author
       from product_authors
       where product_authors.product in
             (select product_authors.product
              from product_authors
              group by product_authors.product
              having count(product_authors.author) > 1
             ));

create index author_i on product_authors (author);


show index from products;

explain
select *
from products
-- ignore index(type_i)
where type = 'Роман';

create index type_i on products (type);


