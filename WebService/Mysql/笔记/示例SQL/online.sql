drop database if exists online;

create database online default character set gbk;

use online;

create table userinfo
(
   id int primary key auto_increment,
   account varchar(8) not null unique,
   pwd varchar(41),
   realname varchar(10) not null,
   udate timestamp default now()
);

create table onlineinfo
(
   id int primary key auto_increment,
   account varchar(8) not null,
   ontime datetime,
   isdown bool default 1
);

insert into userinfo(account,pwd,realname) values('admin',password('123'),'����');
insert into userinfo(account,pwd,realname) values('ydp',password('123'),'����');
insert into userinfo(account,pwd,realname) values('eaccom',password('123'),'����');
insert into userinfo(account,pwd,realname) values('root',password('123'),'����');