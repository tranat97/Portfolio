--Andrew Tran (ant111)

drop table directory cascade constraints;
drop table customers cascade constraints;
drop table records;
drop table statements;
drop table payments;

create table directory (
    pn number(10),
    fname varchar2(20),
    lname varchar2(20),
    street varchar2(20),
    city varchar2(20),
    zip number(5),
    state varchar2(20),

    constraint directory_pk primary key (pn)
);

create table customers (
    SSN  number(9),
    fname varchar2(20),
    lname varchar2(20),
    cell_pn number(10) primary key,
    home_pn number(10),
    street varchar2(20),
    city varchar2(20),
    zip number(5),
    state varchar2(20),
    free_min number not null,
    dob date not null,

    --assume all possible customers are in the directory
    constraint customers_fk_directory foreign key (cell_pn, fname, lname, street, city, zip, state)
        references directory(pn, fname, lname, street, city, zip, state)
);

create table records (
    from_pn number(10),
    to_pn number(10),
    start_timestamp timestamp default current_timestamp,
    duration number(4) default 0,
    type varchar2(20),

    constraint records_pk primary key (from_pn, to_pn, start_timestamp),
    constraint records_type_domain check (type in ('CALL', 'SMS', 'call', 'sms')),
    constraint records_sms_duration check((type='sms' and duration=0) or (type='call' and duration>=0))
    --constraint records_pn_in_customers check ()
);

create table statements (
    cell_pn number(10) primary key,
    start_date date default current_date,
    end_date date,
    total_minutes number default 0,
    total_SMS number default 0,
    amount_due number(6,2) default 0,

    constraint statements_fk_cell_pn foreign key (cell_pn) references customers(cell_pn)
);

create table payments (
    cell_pn number(10),
    paid_on date default current_date not null,
    amount_paid number(6,2) default 0,

    constraint payments_pk primary key (cell_pn, paid_on),
    constraint payments_fk_cell_pn foreign key (cell_pn) references customers(cell_pn)
);

--PART 3
-- a
alter table customers add constraint unique_ssn unique(ssn);
-- b
alter table customers add free_sms number;
-- c
alter table statements add previous_balance number(6,2) default 0;
-- d
alter table customers modify free_min default 0;
alter table customers modify free_sms default 0;
