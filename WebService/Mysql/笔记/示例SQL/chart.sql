drop database if exists chart;

create database chart default character set gbk;

use chart;

create table chart
(
   lang varchar(5) primary key,
   count int default 0
);

insert into chart values('Java',20);
insert into chart values('C',19);
insert into chart values('C++',18);
insert into chart values('PHP',9);
insert into chart values('C#',7);
