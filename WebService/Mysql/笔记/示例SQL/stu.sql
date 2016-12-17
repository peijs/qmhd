drop database if exists student;

create database student character set gbk;

use student;

create table stuinfo
(
   snum varchar(6) primary key,
   sname varchar(10) not null,
   sex varchar(2) default '��',
   age tinyint check(age>=0 and age<=127)
);

insert into stuinfo(snum,sname,age) values('0001','����',18);
insert into stuinfo values('0002','����','Ů',18);
insert into stuinfo values('0003','����','��',20);
insert into stuinfo(snum,sname,age) values('0004','����',19);
insert into stuinfo(snum,sname,age) values('0005','����',17);

select * from stuinfo;

create table couinfo
(
   cid tinyint auto_increment primary key,
   cname varchar(10) not null unique
);

insert into couinfo(cname) values('��ѧ');
insert into couinfo(cname) values('Ӣ��');
insert into couinfo(cname) values('�����');
insert into couinfo(cname) values('����');
insert into couinfo(cname) values('��ʷ');

select * from couinfo;

/*MySql��checkԼ��������*/
create table scoinfo
( 
   snum varchar(6) not null,
   cid tinyint not null,
   score tinyint check(score>=0 and score<=100),
   index(snum),
   index(cid),
   constraint foreign key(snum) references stuinfo(snum) on delete cascade,
   constraint foreign key(cid) references couinfo(cid) on delete cascade
);

insert into scoinfo values('0001',2,101);
insert into scoinfo values('0001',3,101);
insert into scoinfo values('0001',4,101);
insert into scoinfo values('0001',5,101);
insert into scoinfo values('0001',1,101);

select * from scoinfo;

/*������ͼ*/
create view vstu
as
select stuinfo.snum,stuinfo.sname,couinfo.cname,scoinfo.score
from stuinfo,couinfo,scoinfo
where stuinfo.snum=scoinfo.snum and couinfo.cid=scoinfo.cid;

select * from vstu;

/*����һ����ѯ��Ϣ�Ĵ洢���̣��޲�*/
delimiter //
create procedure pallstu()
begin
   select * from vstu;
end
//

/*����*/
delimiter ;
call pallstu();

/*�������ѧ���Ĵ洢���̣��������*/
delimiter //
create procedure paddstu(in num varchar(6),in nam varchar(10))
begin
    insert into stuinfo(snum,sname) values(num,nam);
end
//

/*ִ�д洢����*/
delimiter ;
call paddstu('010','��ǿ');
select * from stuinfo;

/*����һ��ͳ�������Ĵ洢���̣��������*/
delimiter //
create procedure pcountstu(out c int)
begin
   /*set c=(select count(*) from stuinfo);*/
   select count(*) into c from stuinfo;
end
//

delimiter ;
call pcountstu(@c);
select @c;

/*����insert������*/
delimiter //
create trigger traddstu after insert
on stuinfo for each row
begin
    insert into scoinfo(snum,cid) values(NEW.snum,'1');
    insert into scoinfo(snum,cid) values(NEW.snum,'2');
    insert into scoinfo(snum,cid) values(NEW.snum,'3');
    insert into scoinfo(snum,cid) values(NEW.snum,'4');
    insert into scoinfo(snum,cid) values(NEW.snum,'5');
end
//

delimiter ;
insert into stuinfo(snum,sname) values('008','����');

select * from scoinfo;

/*����delete������*/
delimiter //
create trigger trdeletestu after delete
on stuinfo for each row
begin
    delete from scoinfo where snum=OLD.snum;
end
//

delimiter ;
delete from stuinfo where snum='008';
select * from scoinfo;








