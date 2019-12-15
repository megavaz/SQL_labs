use lw;

select * from book_catalog;

update book_catalog
set publisher = 'Rusman'
where edition_code = 'edition003';

select * from book_catalog;

rollback;
-- -------------------
update book_catalog
set publisher = 'Rusman'
where edition_code = 'edition003';

select * from book_catalog;

savepoint s1;

insert into book_catalog (edition_code, name, publisher, publishment_year, pages)
values ('edition014', 'How we sleep', 'NYC books', 2019, 673);

select * from book_catalog;

savepoint s2;

delete from book_catalog where pages > 600;

select * from book_catalog;

rollback to s2;

select * from book_catalog;

release savepoint s1;

commit;