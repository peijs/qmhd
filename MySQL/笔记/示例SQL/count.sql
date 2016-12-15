drop database if exists renshu;

create database renshu default character set gbk;

use renshu;

create table user
(
    id int primary key auto_increment,
    ip varchar(15) not null,
    udate timestamp default now()
)