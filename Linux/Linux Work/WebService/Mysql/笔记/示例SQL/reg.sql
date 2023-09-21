drop database if exists reg;

create database reg default character set gbk;

use reg;

create table userinfo
(
   id int primary key auto_increment,
   account varchar(8) not null unique,
   pwd varchar(41),
   udate timestamp default now()
);