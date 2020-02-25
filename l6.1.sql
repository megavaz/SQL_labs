use lw;


select * from book_catalog;

update book_catalog
set name = 'Idiot'
where name = 'Идиот';

create view fff as select * from tab;

select *
from book_catalog;

commit;