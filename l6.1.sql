use lw;


select * from book_catalog;

update book_catalog
set name = 'Idiot'
where name = 'Идиот';

select *
from book_catalog;

commit;