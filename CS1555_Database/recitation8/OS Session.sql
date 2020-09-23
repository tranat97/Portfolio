-- 1)
create table NotDef (
    ssn number,
    constraint pk_ssn_1 primary key(ssn)
);

create table DefImm (
    ssn number,
    constraint pk_ssn_2 primary key(ssn) deferrable initially immediate
);

create table DefDef (
    ssn number,
    constraint pk_ssn_3 primary key(ssn) deferrable initially deferred
);

--2)
insert into NotDef values (1234);
insert into NotDef values (1234);
commit;

insert into DefImm values (1234);
insert into DefImm values (1234);
commit;

insert into DefDef values (1234);
insert into DefDef values (1234);
commit;

-- 3)
set constraint pk_ssn_2 deferred;
insert into DefImm values (1234);
insert into DefImm values (1234);
commit;

set constraints all deferred;
insert into NotDef values (1235);
insert into NotDef values (1235);
commit;



-- Part 2

-- 1)
CREATE OR REPLACE PROCEDURE
transfer_fund
(
    from_account IN varchar2,
    to_account IN varchar2,
    amount IN number
)
as
    from_account_balance number;
BEGIN
    select balance into from_account_balance from account where acc_no = from_account;
    if from_account_balance > amount then
        update account set balance = balance - amount where acc_no = from_account;
        update account set balance = balance + amount where acc_no = to_account;
    else
        dbms_output.put_line('balance is too low');
    end if;
END;

--2)
set transaction read write name 'transfer1';
set constraints all deferred;
call transfer_fund(124, 123, 100);
commit;
