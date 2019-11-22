# Создать упорядоченный список новых книг
# (за последние три года относительно текущей даты);
select *
from book_catalog
where publishment_year between extract(year from sysdate()) - 3 and extract(year from sysdate())
order by publishment_year desc;

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором
# это первый способ
select surname, name, patronymic, COUNT(*) cnt
from authors,
     product_authors
where product_authors.author = authors.id
group by surname, name, patronymic
order by cnt desc;

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором;
# это второй способ
SELECT surname, name, patronymic, COUNT(title) cnt
FROM products
         join product_authors
              on products.id = product_authors.product
         join authors
              on product_authors.author = authors.id
group by surname, name, patronymic
order by cnt desc;

# Создать упорядоченный список произведений, у которых нет авторов;
select title
from products
WHERE products.id
          NOT IN (select product
                  from product_authors);


# Создать упорядоченный список произведений, которые есть в двух и более книгах;
select products.id, title
from products,
     content
where products.id = content.product
group by products.id, title
having count(book) >= 2
order by title;


# Создать упорядоченный список книг, в числе авторов которых есть Чехов А.П.
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
