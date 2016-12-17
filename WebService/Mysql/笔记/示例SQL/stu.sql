drop database if exists student;

create database student character set gbk;

use student;

create table stuinfo
(
   snum varchar(6) primary key,
   sname varchar(10) not null,
   sex varchar(2) default '男',
   age tinyint check(age>=0 and age<=127)
);

insert into stuinfo(snum,sname,age) values('0001','张三',18);
insert into stuinfo values('0002','李四','女',18);
insert into stuinfo values('0003','王五','男',20);
insert into stuinfo(snum,sname,age) values('0004','赵六',19);
insert into stuinfo(snum,sname,age) values('0005','田七',17);

select * from stuinfo;

create table couinfo
(
   cid tinyint auto_increment primary key,
   cname varchar(10) not null unique
);

insert into couinfo(cname) values('数学');
insert into couinfo(cname) values('英语');
insert into couinfo(cname) values('计算机');
insert into couinfo(cname) values('体育');
insert into couinfo(cname) values('历史');

select * from couinfo;

/*MySql中check约束不能用*/
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

/*创建视图*/
create view vstu
as
select stuinfo.snum,stuinfo.sname,couinfo.cname,scoinfo.score
from stuinfo,couinfo,scoinfo
where stuinfo.snum=scoinfo.snum and couinfo.cid=scoinfo.cid;

select * from vstu;

/*创建一个查询信息的存储过程，无参*/
delimiter //
create procedure pallstu()
begin
   select * from vstu;
end
//

/*调用*/
delimiter ;
call pallstu();

/*创建添加学生的存储过程，输入参数*/
delimiter //
create procedure paddstu(in num varchar(6),in nam varchar(10))
begin
    insert into stuinfo(snum,sname) values(num,nam);
end
//

/*执行存储过程*/
delimiter ;
call paddstu('010','王强');
select * from stuinfo;

/*创建一个统计数量的存储过程，输出参数*/
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

/*创建insert触发器*/
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
insert into stuinfo(snum,sname) values('008','张扬');

select * from scoinfo;

/*创建delete触发器*/
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








