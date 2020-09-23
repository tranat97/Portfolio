----------------------------------------------
--- Sample solution for Question #2 ---
----------------------------------------------

---DROP ALL TABLES TO MAKE SURE THE SCHEMA IS CLEAR
DROP TABLE RECORDS CASCADE CONSTRAINTS;
DROP TABLE STATEMENTS CASCADE CONSTRAINTS;
DROP TABLE PAYMENTS CASCADE CONSTRAINTS;
DROP TABLE CUSTOMERS CASCADE CONSTRAINTS;
DROP TABLE DIRECTORY CASCADE CONSTRAINTS;

---CREATING DIRECTORY TABLE FIRST, SINCE MANY TABLES REFERENCES IT
CREATE TABLE DIRECTORY(
pn      number(10)       not null,
fname   varchar2(20)    not null,
lname   varchar2(20 )    not null,
street          varchar2(40),
city            varchar2(20),
zip             number(5),
state           varchar2(20),
CONSTRAINT DIRECTORY_PK PRIMARY KEY (pn)
);

---CREATING CUSTOMERS TABLE
CREATE TABLE CUSTOMERS(
SSN         number(9) 	    not null,
fname       varchar2(20)    not null,
lname       varchar2(20)    not null,
cell_pn     number(10)      not null,
home_pn     number(10),
street      varchar2(40),
city        varchar2(20),
zip         number(5),
state       varchar2(20),
free_min    number,
dob       date,
CONSTRAINT CUSTOMERS_PK PRIMARY KEY (cell_pn),
CONSTRAINT CUSTOMERS_FK1 FOREIGN KEY (cell_pn) REFERENCES DIRECTORY(pn),
CONSTRAINT CUSTOMERS_FK2 FOREIGN KEY (home_pn) REFERENCES DIRECTORY(pn),
CONSTRAINT CUSTOMERS_UN UNIQUE (SSN)
);

---CREATING RECORDS TABLE
CREATE TABLE RECORDS(
from_pn         number(10)      not null,
to_pn           number(10)      not null,
start_timestamp  TIMESTAMP       not null,
duration number(4),
type       varchar2(20)     not null,
CONSTRAINT RECORDS_PK PRIMARY KEY(from_pn, start_timestamp),
CONSTRAINT RECORDS_FK1 FOREIGN KEY(from_pn) REFERENCES DIRECTORY(pn),
CONSTRAINT RECORDS_FK2 FOREIGN KEY(to_pn) REFERENCES DIRECTORY(pn)
);

---CREATING STATEMENTS TABLE
CREATE TABLE STATEMENTS(
cell_pn         number(10)      not null,
start_date      DATE    not null,
end_date        DATE    not null,
total_minutes   number,
total_SMS       number,
amount_due      number(6,2),
CONSTRAINT STATEMENTS_PK PRIMARY KEY (cell_pn, start_date),
CONSTRAINT STATEMENTS_FK FOREIGN KEY (cell_pn) REFERENCES CUSTOMERS(cell_pn),
CONSTRAINT STATEMENTS_UN UNIQUE(cell_pn, end_date)
);

---CREATING PAYMENTS TABLE
CREATE TABLE PAYMENTS(
cell_pn	number(10)	not null,
paid_on	TIMESTAMP,
amount_paid	number(6,2),
CONSTRAINT PAYMENTS_PK PRIMARY KEY(cell_pn, paid_on),
CONSTRAINT PAYMENTS_FK FOREIGN KEY(cell_pn) REFERENCES CUSTOMERS(cell_pn)
);





----------------------------------------
--- Sample solution for Question #3  ---
----------------------------------------

--a) In each table, add a Unique constraint for every of its alternate keys

ALTER TABLE RECORDS add Constraint records_UQ_toPn UNIQUE(to_pn, start_timestamp);

ALTER TABLE STATEMENTS add Constraint statements_UQ_endDate UNIQUE(end_date, cell_pn);

--b) Add a new attribute free_SMS to table CUSTOMERS,
--   which is the date of birth

ALTER TABLE CUSTOMERS add free_SMS number;

--c) Add a new attribute previous balance to table STATEMENTS,
--   which balance carried over from previous statement.

ALTER TABLE STATEMENTS add previous_balance number(6,2);

--d) In table CUSTOMERS, the free_min and free_SMS default value should be set to 0

ALTER TABLE CUSTOMERS modify free_min default 0;
ALTER TABLE CUSTOMERS modify free_SMS default 0;

Commit;
--Purge recyclebin;