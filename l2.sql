# Создать упорядоченный список новых книг
# (за последние три года относительно текущей даты);
select *
from book_catalog
where publishment_year between extract(year from sysdate()) - 3 and extract(year from sysdate())
order by publishment_year desc;

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором;
select surname, name, patronymic, COUNT(title) cnt
from authors,
     book_authors,
     books
where books.id = book_authors.book
  and book_authors.author = authors.id
group by surname, name, patronymic
order by cnt desc;

# Создать упорядоченный список авторов с указанием
# количества произведений, написанных этим автором;
# это второй способ
SELECT surname, name, patronymic, COUNT(title) cnt
FROM books
         join book_authors
              on books.id = book_authors.book
         join authors
              on book_authors.author = authors.id
group by surname, name, patronymic
order by cnt desc;

# Создать упорядоченный список произведений, у которых нет авторов;
select title
from book_authors,
     books
where books.id = book_authors.book
  and book_authors.author is null
order by title;


# Создать упорядоченный список произведений, которые есть в двух и более книгах;
select title
from books,
     content
where books.id = content.book
group by title
having count(product) >= 2
order by title;


# Создать упорядоченный список книг, в числе авторов которых есть Чехов А.П.
select title
from book_catalog,
     content,
     books,
     book_authors,
     authors
where book_catalog.edition_code = content.product
  and content.book = books.id
  and books.id = book_authors.book
  and book_authors.author = authors.id
  and authors.surname = 'Чехов'
  and authors.name = 'Антон'
  and authors.patronymic = 'Павлович'
order by title;
