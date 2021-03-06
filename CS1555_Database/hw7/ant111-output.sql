SQL: DROP TABLE RECORDS CASCADE CONSTRAINTS
Message: The command(s) successfully completed
SQL: DROP TABLE STATEMENTS CASCADE CONSTRAINTS
Message: The command(s) successfully completed
SQL: DROP TABLE PAYMENTS CASCADE CONSTRAINTS
Message: The command(s) successfully completed
SQL: DROP TABLE CUSTOMERS CASCADE CONSTRAINTS
Message: The command(s) successfully completed
SQL: DROP TABLE DIRECTORY CASCADE CONSTRAINTS
Message: The command(s) successfully completed
SQL: drop table company cascade constraints
Message: The command(s) successfully completed
SQL: drop table comp_bill cascade constraints
Message: The command(s) successfully completed

---------------------------------------
------------------Q1-------------------
---------------------------------------
SQL: CREATE TABLE DIRECTORY(
pn      number(10)      not null,
fname   varchar2(20)    not null,
lname   varchar2(20 )   not null,
street  varchar2(40),
city    varchar2(20),
zip     number(5),
state   varchar2(20),
CONSTRAINT DIRECTORY_PK PRIMARY KEY (pn) DEFERRABLE initially IMMEDIATE
)
Message: The command(s) successfully completed

SQL: CREATE TABLE CUSTOMERS(
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
dob         date,
CONSTRAINT CUSTOMERS_PK PRIMARY KEY (cell_pn) DEFERRABLE initially IMMEDIATE,
CONSTRAINT CUSTOMERS_FK1 FOREIGN KEY (cell_pn) REFERENCES DIRECTORY(pn) DEFERRABLE initially IMMEDIATE,
CONSTRAINT CUSTOMERS_FK2 FOREIGN KEY (home_pn) REFERENCES DIRECTORY(pn) DEFERRABLE initially IMMEDIATE,
CONSTRAINT CUSTOMERS_UN UNIQUE (SSN) DEFERRABLE initially IMMEDIATE
)
Message: The command(s) successfully completed

SQL: CREATE TABLE RECORDS(
from_pn             number(10)      not null,
to_pn               number(10)      not null,
start_timestamp     TIMESTAMP       not null,
duration            number(4),
type                varchar2(20)    not null,
CONSTRAINT RECORDS_PK PRIMARY KEY(from_pn, start_timestamp) DEFERRABLE initially IMMEDIATE,
CONSTRAINT RECORDS_FK1 FOREIGN KEY(from_pn) REFERENCES DIRECTORY(pn) DEFERRABLE initially IMMEDIATE,
CONSTRAINT RECORDS_FK2 FOREIGN KEY(to_pn) REFERENCES DIRECTORY(pn) DEFERRABLE initially IMMEDIATE
)
Message: The command(s) successfully completed

SQL: CREATE TABLE STATEMENTS(
cell_pn         number(10)      not null,
start_date      DATE    not null,
end_date        DATE    not null,
total_minutes   number,
total_SMS       number,
amount_due      number(6,2),
CONSTRAINT STATEMENTS_PK PRIMARY KEY (cell_pn, start_date) DEFERRABLE initially IMMEDIATE,
CONSTRAINT STATEMENTS_FK FOREIGN KEY (cell_pn) REFERENCES CUSTOMERS(cell_pn) DEFERRABLE initially IMMEDIATE,
CONSTRAINT STATEMENTS_UN UNIQUE(cell_pn, end_date) DEFERRABLE initially IMMEDIATE
)
Message: The command(s) successfully completed

SQL: CREATE TABLE PAYMENTS(
cell_pn	    number(10)	not null,
paid_on	    TIMESTAMP,
amount_paid	number(6,2),
CONSTRAINT PAYMENTS_PK PRIMARY KEY(cell_pn, paid_on) DEFERRABLE initially IMMEDIATE,
CONSTRAINT PAYMENTS_FK FOREIGN KEY(cell_pn) REFERENCES CUSTOMERS(cell_pn) DEFERRABLE initially IMMEDIATE
)
Message: The command(s) successfully completed

SQL: ALTER TABLE RECORDS add Constraint records_UQ_toPn UNIQUE(to_pn, start_timestamp) DEFERRABLE initially IMMEDIATE
Message: The command(s) successfully completed
SQL: ALTER TABLE STATEMENTS add Constraint statements_UQ_endDate UNIQUE(end_date, cell_pn) DEFERRABLE initially IMMEDIATE
Message: The command(s) successfully completed
SQL: ALTER TABLE CUSTOMERS add free_SMS number
Message: The command(s) successfully completed
SQL: ALTER TABLE STATEMENTS add previous_balance number(6,2)
Message: The command(s) successfully completed
SQL: ALTER TABLE CUSTOMERS modify free_min default 0
Message: The command(s) successfully completed
SQL: ALTER TABLE CUSTOMERS modify free_SMS default 0
Message: The command(s) successfully completed


---------------------------------------
------------------Q2-------------------
---------------------------------------
SQL: create table company(
comp_id     number,
comp_name   varchar2(20),
street      varchar2(40),
city        varchar2(20),
zip         number(5),
state       varchar2(2),
CONSTRAINT COMPANY_PK PRIMARY KEY (comp_id) DEFERRABLE initially DEFERRED
)
Message: The command(s) successfully completed

---------------------------------------
------------------Q3-------------------
---------------------------------------
SQL: create table comp_bill (
comp_id         number,
start_date      date,
end_date        date,
total_minutes   number(10,2) default 0,
amount_due      number(10,2) default 0,
CONSTRAINT COMP_BILL_PK PRIMARY KEY (comp_id, start_date) DEFERRABLE initially DEFERRED,
CONSTRAINT COMP_BILL_FK FOREIGN KEY (comp_id) references company(comp_id) DEFERRABLE initially DEFERRED
)
Message: The command(s) successfully completed

---------------------------------------
------------------Q4-------------------
---------------------------------------
SQL: alter table directory add comp_id number not null
Message: The command(s) successfully completed

SQL: alter table directory add constraint COMP_ID_FK FOREIGN KEY(comp_id) references company(comp_id)
Message: The command(s) successfully completed

---------------------------------------
------------------Q4-------------------
---------------------------------------
SQL: alter table company add charge_rate number (3,2) DEFAULT 0.20
Message: The command(s) successfully completed

---------------------------------------
------------------Q5-------------------
---------------------------------------
SQL: alter table company add constraint POSITIVE_RATE check (charge_rate >= 0)
Message: The command(s) successfully completed

---------------------------------------
------------------Q6-------------------
---------------------------------------
SQL: alter table statements add constraint DATE_CONT check (start_date < end_date)
Message: The command(s) successfully completed

SQL: alter table comp_bill add constraint COMP_DATE_CONT check (start_date < end_date)
Message: The command(s) successfully completed

SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(1,'P_Mobile','210 Sennott Square','Pittsburgh',15260,'PA',0)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(2,'K_tele','22 2nd Ave','Philadelphia',22222,'PA',0.15)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(3,'L_tele','33 3rd Ave','Tridelphia',16161,'WV',0.20)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(4,'M_tele','44 4th Ave','Butler',13421,'PA',0.15)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(5,'D_tele','55 5th Ave','Harrisburgh',33333,'PA',0.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(6,'D_Mobile','66 6th Ave','Harrisburgh',33333,'PA',0.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(7,'H_tele','67 Center Ave','Harrisburgh',33333,'PA',0.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(8,'M_Mobile','46 6th Ave','Butler',13421,'PA',0.15)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(2,'01-APR-19','31-MAY-19',16500,002475.00)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(3,'01-APR-19','31-MAY-19',26771,005354.20)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(4,'01-APR-19','31-MAY-19',16500,002475.00)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(5,'01-APR-19','31-MAY-19',26771,002677.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(6,'01-APR-19','31-MAY-19',26771,002677.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(7,'01-APR-19','31-MAY-19',26771,002677.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(8,'01-APR-19','31-MAY-19',16500,002475.00)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(2,'01-JUN-19','31-JUL-19',17394,002609.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(3,'01-JUN-19','31-JUL-19',28456,005691.20)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(4,'01-JUN-19','31-JUL-19',17394,002609.10)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(5,'01-JUN-19','31-JUL-19',28456,002845.60)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(6,'01-JUN-19','31-JUL-19',28456,002845.60)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(7,'01-JUN-19','31-JUL-19',28456,002845.60)
Message: 1 row(s) affected
SQL: INSERT INTO COMP_BILL(comp_ID,start_date,end_date,total_minutes,amount_due) values(8,'01-JUN-19','31-JUL-19',17394,002609.10)
Message: 1 row(s) affected
SQL: COMMIT
Message: The command(s) successfully completed

---------------------------------------
------------------Q7-------------------
---------------------------------------
SQL: begin 
    insert into company(comp_ID,comp_name,street,city,zip,state,charge_rate) values(9,'Q_Mobile','1111 Fifth Street','Pittsburgh',15213,'PA',0.10);
    insert into comp_bill(comp_ID,start_date,end_date,total_minutes,amount_due) values(9,'01-APR-19','31-MAY-19',0,0);
    insert into directory values(7248881212, 'James', 'Kennedy', '5550 Fifth Avenue', 'Pittsburgh', 15216, 'PA', 9);
    insert into directory values(7248884545, 'Robin', 'Gates', '6660 Sixth Street', 'Pittsburgh', 15666, 'PA', 9);
end;
Message: PL/SQL procedure successfully completed

SQL: commit
Message: The command(s) successfully completed

SQL: INSERT INTO DIRECTORY values(4121231231, 'Michael', 'Johnson'  , '320 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4121232131, 'Michael', 'Johnson'  , '320 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4124564564, 'Kate'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4127897897, 'Bill'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4123121231, 'Bill'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4127417417, 'Richard', 'Hurson'   , '340 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4127417612, 'Richard', 'Hurson'   , '340 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4122582582, 'Mary'   , 'Davis'    , '350 Fifth Avenue'  , 'Pittsburgh'   ,15217, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4122581324, 'Mary'   , 'Davis'    , '350 Fifth Avenue'  , 'Pittsburgh'   ,15217, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7247779797, 'Julia'  , 'Hurson'   , '3350 Fifth Avenue' , 'Philadelphia' ,22221, 'PA',2)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7247778787, 'Chris'  , 'Lyn'      , '62 Sixth St'       , 'Philadelphia' ,22222, 'PA',2)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7243413412, 'Chris'  , 'Lyn'      , '62 Sixth St'       , 'Philadelphia' ,22222, 'PA',2)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7248889898, 'Jones'  , 'Steward'  , '350 Fifth Avenue'  , 'Philadelphia' ,22222, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7249879879, 'James'  , 'Sam'      , '1210 Forbes Avenue', 'Philadelphia' ,22132, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7249871253, 'James'  , 'Sam'      , '1210 Forbes Avenue', 'Philadelphia' ,22132, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(6243780132, 'Harry'  , 'Lee'      , '3721 Craig Street' , 'Tridelphia'   ,16161, 'WV',3)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(6241121342, 'Kate'   , 'Lee'      , '3721 Craig Street' , 'Tridelphia'   ,16161, 'WV',3)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(6242311322, 'Jack'   , 'Barry'    , '3521 Craig Street' , 'Tridelphia'   ,16161, 'WV',3)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(6241456123, 'Neil'   , 'Jackson'  , '2134 Seventh St'   , 'Tridelphia'   ,16161, 'WV',3)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4843504021, 'Frank'  , 'Shaw'     , '23 Fifth Avenue'   , 'Allentown'    ,14213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4843504245, 'Frank'  , 'Shaw'     , '23 Fifth Avenue'   , 'Allentown'    ,14213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4846235161, 'Liam'   , 'Allen'    , '345 Craig Street'  , 'Allentown'    ,14213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4846452231, 'Justin' , 'Blosser'  , '231 Tenth Street'  , 'Allentown'    ,14213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(4846452124, 'Justin' , 'Blosser'  , '231 Tenth Street'  , 'Allentown'    ,14213, 'PA',1)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2133504021, 'Patrick', 'Araon'    , '44 4th Avenue'     , 'Butler'    ,13421, 'PA',4)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2133504245, 'Abby'   , 'Red'      , '444 Fifth Avenue'  , 'Butler'    ,13421, 'PA',4)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2136235161, 'Reed'   , 'Michaels' , '345 Liberty Street', 'Butler'    ,13421, 'PA',4)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2136452231, 'Kristy' , 'Ray'      , '231 Liberty Street', 'Butler'    ,13421, 'PA',4)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2136452124, 'Kristy' , 'Ray'      , '231 Liberty Street', 'Butler'    ,13421, 'PA',4)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7773504021, 'Reese'  , 'Carter'   , '55 Fifth Avenue'   , 'Harrisburgh',33333, 'PA',5)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7773504245, 'Rubben' , 'Carter'   , '55 Fifth Avenue'   , 'Harrisburgh',33333, 'PA',5)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7776235161, 'Chris'  , 'Wynn'     , '125 Liberty Street', 'Harrisburgh',33333, 'PA',5)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7776452231, 'Zack'   , 'Wilson'   , '231 May Street'    , 'Harrisburgh',33333, 'PA',5)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7776452124, 'Alex'   , 'Casper'   , '111 May Street'    , 'Harrisburgh',33333, 'PA',5)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7783504021, 'Sophie' , 'Harper'   , '556 Fifth Avenue'  , 'Harrisburgh',33333, 'PA',6)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7783504245, 'Rachel' , 'Hanna'    , '557 Fifth Avenue'  , 'Harrisburgh',33333, 'PA',6)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7786235161, 'Jack'   , 'Steven'   , '12 Liberty Street' , 'Harrisburgh',33333, 'PA',6)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7786452231, 'Britney', 'Cook'     , '231 June Street'   , 'Harrisburgh',33333, 'PA',6)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7686452124, 'Anna'   , 'Nilson'   , '111 June Street'   , 'Harrisburgh',33333, 'PA',7)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7686452231, 'Katie'  , 'Jackson'  , '89  June Street'   , 'Harrisburgh',33333, 'PA',7)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(7686452345, 'Clare'  , 'Green'    , '24  June Street'   , 'Harrisburgh',33333, 'PA',7)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2146452231, 'Bree'   , 'Julia'    , '11  Center Ave'   , 'Butler',13421, 'PA',8)
Message: 1 row(s) affected
SQL: INSERT INTO DIRECTORY values(2146452345, 'Ben'    , 'Cooper'   , '14  Center Ave'   , 'Butler',13421, 'PA',8)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(123456789, 'Michael', 'Johnson',  4121231231, 4121232131,'320 Fifth Avenue', 'Pittsburgh', 15213,'PA',300,'01-JAN-91',100)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(123232343, 'Kate'   , 'Stevenson',4124564564, 4123121231,'310 Fifth Avenue', 'Pittsburgh', 15213,'PA',300,'05-FEB-90',100)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(445526754, 'Bill'   , 'Stevenson',4127897897, 4123121231,'310 Fifth Avenue', 'Pittsburgh', 15213,'PA',600,'11-DEC-92',50)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(254678898, 'Richard', 'Hurson'   ,4127417417, 4127417612,'340 Fifth Avenue', 'Pittsburgh', 15213,'PA',600,'03-OCT-89',500)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(256796533, 'Mary'   , 'Davis'    ,4122582582, 4122581324,'350 Fifth Avenue', 'Pittsburgh', 15217,'PA',100,'04-MAR-93',1000)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(245312567, 'Frank'  , 'Shaw'     ,4843504021, 4843504245,'23 Fifth Avenue' , 'Allentown' , 14213,'PA',0,'05-JUN-87',50)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(251347682, 'Jones'  , 'Steward'  ,7248889898, null, '350 Fifth Avenue' , 'Philadelphia' ,  22222,'PA',150,'04-JAN-90',500)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(312567834, 'James'  , 'Sam'      ,7249879879, 7249871253,'1210ForbesAvenue','Philadelphia',22132,'PA',100,'15-AUG-88',100)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(421356312, 'Liam'   , 'Allen'    ,4846235161, null, '345 Craig Street' , 'Allentown'    ,  14213,'PA',0  ,'16-SEP-92',100)
Message: 1 row(s) affected
SQL: INSERT INTO CUSTOMERS values(452167351, 'Justin' , 'Blosser'  ,4846452231, 4846452124,'231 Tenth Street' , 'Allentown', 14213,'PA',300,'01-MAY-90',100)
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 4124564564, TO_TIMESTAMP('25-DEC-17:11:05','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 7247779797, TO_TIMESTAMP('25-DEC-17:17:10','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4124564564, 7247778787, TO_TIMESTAMP('08-AUG-19:11:05','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7248889898, 7247779797, TO_TIMESTAMP('15-AUG-19:14:17','DD-MON-RR:HH24:MI'), 60,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7248889898, 7247778787, TO_TIMESTAMP('01-SEP-19:11:03','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7249879879, 7248889898, TO_TIMESTAMP('03-SEP-19:17:24','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4127417417, 7249879879, TO_TIMESTAMP('05-SEP-19:18:24','DD-MON-RR:HH24:MI'), 123,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4843504021, 4846235161, TO_TIMESTAMP('07-SEP-19:15:23','DD-MON-RR:HH24:MI'), 50,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846235161, 4846452231, TO_TIMESTAMP('23-SEP-19:12:23','DD-MON-RR:HH24:MI'), 120,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 7248884545, TO_TIMESTAMP('25-SEP-19:13:34','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('26-SEP-19:23:12','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(6241456123, 6241121342, TO_TIMESTAMP('30-SEP-19:23:11','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 6241121342, TO_TIMESTAMP('02-OCT-19:11:22','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 7773504021, TO_TIMESTAMP('01-AUG-19:23:05','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 7773504245, TO_TIMESTAMP('02-AUG-19:13:10','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4124564564, 7776235161, TO_TIMESTAMP('08-AUG-19:14:05','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7776452231, 4121231231, TO_TIMESTAMP('15-AUG-19:21:17','DD-MON-RR:HH24:MI'), 60,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7248889898, 7776452231, TO_TIMESTAMP('01-SEP-19:13:03','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7776235161, 7248889898, TO_TIMESTAMP('03-SEP-19:15:24','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4127417417, 2133504021, TO_TIMESTAMP('05-SEP-19:16:24','DD-MON-RR:HH24:MI'), 123,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(2133504245, 4122582582, TO_TIMESTAMP('07-SEP-19:11:23','DD-MON-RR:HH24:MI'), 50,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(2136452231, 4122582582, TO_TIMESTAMP('23-SEP-19:14:23','DD-MON-RR:HH24:MI'), 120,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 2136452231, TO_TIMESTAMP('25-SEP-19:21:34','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 2136235161, TO_TIMESTAMP('26-SEP-19:22:12','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(2133504021, 4846452231, TO_TIMESTAMP('30-SEP-19:12:11','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 2133504021, TO_TIMESTAMP('02-OCT-19:18:22','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7686452231, 4122582582, TO_TIMESTAMP('23-SEP-19:16:23','DD-MON-RR:HH24:MI'), 230,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 7686452124, TO_TIMESTAMP('25-SEP-19:22:34','DD-MON-RR:HH24:MI'), 120,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 7686452231, TO_TIMESTAMP('26-SEP-19:23:12','DD-MON-RR:HH24:MI'), 300,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7686452231, 4846452231, TO_TIMESTAMP('01-OCT-19:12:11','DD-MON-RR:HH24:MI'), 160,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 7686452345, TO_TIMESTAMP('04-OCT-19:18:22','DD-MON-RR:HH24:MI'), 550,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 7783504245, TO_TIMESTAMP('04-AUG-19:18:22','DD-MON-RR:HH24:MI'), 400,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7783504021, 4122582582, TO_TIMESTAMP('25-SEP-19:22:23','DD-MON-RR:HH24:MI'), 250,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 7786235161, TO_TIMESTAMP('05-OCT-19:16:34','DD-MON-RR:HH24:MI'), 130,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4121231231, 2146452231, TO_TIMESTAMP('06-AUG-19:18:22','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(2146452231, 4122582582, TO_TIMESTAMP('27-SEP-19:19:23','DD-MON-RR:HH24:MI'), 550,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 2146452345, TO_TIMESTAMP('10-OCT-19:20:34','DD-MON-RR:HH24:MI'), 150,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4843504021, 4846235161, TO_TIMESTAMP('13-OCT-19:15:23','DD-MON-RR:HH24:MI'), 50,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846235161, 4846452231, TO_TIMESTAMP('13-OCT-19:12:23','DD-MON-RR:HH24:MI'), 120,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(4846452231, 4846235161, TO_TIMESTAMP('25-OCT-19:13:34','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('01-NOV-19:23:12','DD-MON-RR:HH24:MI'), 200,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(6241456123, 6241121342, TO_TIMESTAMP('05-NOV-19:23:11','DD-MON-RR:HH24:MI'), 100,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7248889898, 7247779797, TO_TIMESTAMP('25-DEC-19:10:17','DD-MON-RR:HH24:MI'), 60,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO RECORDS values(7248889898, 7247779797, TO_TIMESTAMP('25-DEC-19:15:17','DD-MON-RR:HH24:MI'), 120,'CALL')
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4121231231, '01-AUG-19','31-AUG-19', 250, 0, 39.99,  0)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4124564564, '01-AUG-19','31-AUG-19', 600, 0, 299.99, 200.99)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4127897897, '01-AUG-19','31-AUG-19', 650, 0, 59.99,  0)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4127417417, '01-AUG-19','31-AUG-19', 517, 0, 49.99,  49.99)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4122582582, '01-AUG-19','31-AUG-19', 500, 0, 139.99, 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4843504021, '01-AUG-19','31-AUG-19', 230, 0, 59.99,  0)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(7248889898, '01-AUG-19','31-AUG-19', 50,  0, 25.99,  25.99)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(7249879879, '01-AUG-19','31-AUG-19', 700, 0, 159.99, 50)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4846235161, '01-AUG-19','31-AUG-19', 200, 0, 199.99, 100)
Message: 1 row(s) affected
SQL: INSERT INTO STATEMENTS values(4846452231, '01-AUG-19','31-AUG-19', 500, 0, 179.99, 59.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4121231231, '05-AUG-19', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4121231231, '04-SEP-19', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4124564564, '03-AUG-19', 100)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4127897897, '06-AUG-19', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4127417417, '06-AUG-19', 10.00)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4121231231, '05-Aug-18', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4121231231, '04-Sep-18', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4124564564, '03-Aug-18', 100)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4127897897, '06-Aug-18', 39.99)
Message: 1 row(s) affected
SQL: INSERT INTO PAYMENTS values(4127417417, '06-Aug-18', 10.00)
Message: 1 row(s) affected
SQL: COMMIT
Message: The command(s) successfully completed

---------------------------------------
------------------Q8a-------------------
---------------------------------------
select cell_pn, fname, lname, case 
    when city = 'Philadelphia' then amount_due-15 
    when city = 'Pittsburgh' then amount_due-20 
    else amount_due 
    end as amount_due 
    from ( 
        select c.cell_pn, fname, lname, city, amount_due 
        from ( 
            customers c left outer join statements s on c.cell_pn=s.cell_pn 
            ) 
    );
--RESULTS:
CELL_PN,FNAME,LNAME,AMOUNT_DUE
"4121231231","Michael","Johnson","19.99"
"4124564564","Kate","Stevenson","279.99"
"4127897897","Bill","Stevenson","39.99"
"4127417417","Richard","Hurson","29.99"
"4122582582","Mary","Davis","119.99"
"4843504021","Frank","Shaw","59.99"
"7248889898","Jones","Steward","10.99"
"7249879879","James","Sam","144.99"
"4846235161","Liam","Allen","199.99"
"4846452231","Justin","Blosser","179.99"

---------------------------------------
------------------Q8b-------------------
---------------------------------------
select comp_name, state, (total_minutes*charge_rate) as total_due
from (
        (select comp_id as id, comp_name, state, case
        when comp_name = 'P_Mobile' then charge_rate
        when state = 'PA' then case 
            when charge_rate-0.05<0.01 then 0.01
            else charge_rate-0.05
            end
        else charge_rate+0.10
        end as charge_rate
        from company) c
        left outer join (
            select comp_id, sum(total_minutes) as total_minutes
            from comp_bill
            where start_date >= to_date('04/01/2019', 'MM/DD/YYYY') and end_date <= to_date('07/31/2019', 'MM/DD/YYYY')
            group by comp_id
        ) b on c.id = b.comp_id
);
--RESULTS:
COMP_NAME,STATE,TOTAL_DUE
"D_Mobile","PA","2761.35"
"K_tele","PA","3389.4"
"M_tele","PA","3389.4"
"D_tele","PA","2761.35"
"M_Mobile","PA","3389.4"
"L_tele","WV","16568.1"
"H_tele","PA","2761.35"
"Q_Mobile","PA","0"
"P_Mobile","PA","<NULL>"


---------------------------------------
------------------Q9a-------------------
---------------------------------------
SQL: create OR replace trigger DISPLAY_LATEST_DUES
    before update of charge_rate on company
    referencing old as oldRate
for each row
declare 
    amount number(6,2);
begin
    select amount_due
    into amount
    from comp_bill
    where comp_id = :oldRate.comp_id
    order by end_date desc
    fetch first row only;
    DBMS_OUTPUT.PUT_LINE('Latest dues: ' || amount);
end;
Message: The command(s) successfully completed

---------------------------------------
------------------Q9b-------------------
---------------------------------------
SQL: create or replace trigger BILLING 
    after insert on records
    referencing new as newCall
for each row
declare 
    duration number(4);
begin
    update statements set total_minutes=total_minutes+:newCall.duration 
    where cell_pn=:newCall.from_pn or cell_pn=:newCall.to_pn;
end;
Message: The command(s) successfully completed

---------------------------------------
------------------Q10a-------------------
---------------------------------------
SQL: create or replace procedure PROC_UPDATE_CHARGE_RATE (input_comp_id in number, rate_charge in number)
as
begin
    update company set charge_rate = rate_charge
    where comp_id = input_comp_id;
end;
Message: The command(s) successfully completed

---------------------------------------
------------------Q11a-------------------
---------------------------------------
select * from company;
COMP_ID,COMP_NAME,STREET,CITY,ZIP,STATE,CHARGE_RATE
"1","P_Mobile","210 Sennott Square","Pittsburgh","15260","PA","0"
"2","K_tele","22 2nd Ave","Philadelphia","22222","PA","0.15"
"3","L_tele","33 3rd Ave","Tridelphia","16161","WV","0.2"
"4","M_tele","44 4th Ave","Butler","13421","PA","0.15"
"5","D_tele","55 5th Ave","Harrisburgh","33333","PA","0.1"
"6","D_Mobile","66 6th Ave","Harrisburgh","33333","PA","0.1"
"7","H_tele","67 Center Ave","Harrisburgh","33333","PA","0.1"
"8","M_Mobile","46 6th Ave","Butler","13421","PA","0.15"
"9","Q_Mobile","1111 Fifth Street","Pittsburgh","15213","PA","0.1"

SQL: begin
    PROC_UPDATE_CHARGE_RATE(2, 0.10);
end;
Message: PL/SQL procedure successfully completed

Console Output Begins: 
Latest dues: 2609.1
Console Output Ends.

select * from company;
COMP_ID,COMP_NAME,STREET,CITY,ZIP,STATE,CHARGE_RATE
"1","P_Mobile","210 Sennott Square","Pittsburgh","15260","PA","0"
"2","K_tele","22 2nd Ave","Philadelphia","22222","PA","0.1"
"3","L_tele","33 3rd Ave","Tridelphia","16161","WV","0.2"
"4","M_tele","44 4th Ave","Butler","13421","PA","0.15"
"5","D_tele","55 5th Ave","Harrisburgh","33333","PA","0.1"
"6","D_Mobile","66 6th Ave","Harrisburgh","33333","PA","0.1"
"7","H_tele","67 Center Ave","Harrisburgh","33333","PA","0.1"
"8","M_Mobile","46 6th Ave","Butler","13421","PA","0.15"
"9","Q_Mobile","1111 Fifth Street","Pittsburgh","15213","PA","0.1"


---------------------------------------
------------------Q11b-------------------
---------------------------------------
select * from records;
FROM_PN,TO_PN,START_TIMESTAMP,DURATION,TYPE
"4121231231","4124564564","12/25/2017 11:05:00","300","CALL"
"4121231231","7247779797","12/25/2017 17:10:00","300","CALL"
"4124564564","7247778787","08/08/2019 11:05:00","300","CALL"
"7248889898","7247779797","08/15/2019 14:17:00","60","CALL"
"7248889898","7247778787","09/01/2019 11:03:00","300","CALL"
"7249879879","7248889898","09/03/2019 17:24:00","100","CALL"
"4127417417","7249879879","09/05/2019 18:24:00","123","CALL"
"4843504021","4846235161","09/07/2019 15:23:00","50","CALL"
"4846235161","4846452231","09/23/2019 12:23:00","120","CALL"
"4846452231","7248884545","09/25/2019 13:34:00","200","CALL"
"6243780132","6242311322","09/26/2019 23:12:00","200","CALL"
"6241456123","6241121342","09/30/2019 23:11:00","100","CALL"
"4121231231","6241121342","10/02/2019 11:22:00","200","CALL"
"4121231231","7773504021","08/01/2019 23:05:00","300","CALL"
"4121231231","7773504245","08/02/2019 13:10:00","300","CALL"
"4124564564","7776235161","08/08/2019 14:05:00","300","CALL"
"7776452231","4121231231","08/15/2019 21:17:00","60","CALL"
"7248889898","7776452231","09/01/2019 13:03:00","300","CALL"
"7776235161","7248889898","09/03/2019 15:24:00","100","CALL"
"4127417417","2133504021","09/05/2019 16:24:00","123","CALL"
"2133504245","4122582582","09/07/2019 11:23:00","50","CALL"
"2136452231","4122582582","09/23/2019 14:23:00","120","CALL"
"4846452231","2136452231","09/25/2019 21:34:00","200","CALL"
"4846452231","2136235161","09/26/2019 22:12:00","200","CALL"
"2133504021","4846452231","09/30/2019 12:11:00","100","CALL"
"4121231231","2133504021","10/02/2019 18:22:00","200","CALL"
"7686452231","4122582582","09/23/2019 16:23:00","230","CALL"
"4846452231","7686452124","09/25/2019 22:34:00","120","CALL"
"4846452231","7686452231","09/26/2019 23:12:00","300","CALL"
"7686452231","4846452231","10/01/2019 12:11:00","160","CALL"
"4121231231","7686452345","10/04/2019 18:22:00","550","CALL"
"4121231231","7783504245","08/04/2019 18:22:00","400","CALL"
"7783504021","4122582582","09/25/2019 22:23:00","250","CALL"
"4846452231","7786235161","10/05/2019 16:34:00","130","CALL"
"4121231231","2146452231","08/06/2019 18:22:00","100","CALL"
"2146452231","4122582582","09/27/2019 19:23:00","550","CALL"
"4846452231","2146452345","10/10/2019 20:34:00","150","CALL"
"4843504021","4846235161","10/13/2019 15:23:00","50","CALL"
"4846235161","4846452231","10/13/2019 12:23:00","120","CALL"
"4846452231","4846235161","10/25/2019 13:34:00","200","CALL"
"6243780132","6242311322","11/01/2019 23:12:00","200","CALL"
"6241456123","6241121342","11/05/2019 23:11:00","100","CALL"
"7248889898","7247779797","12/25/2019 10:17:00","60","CALL"
"7248889898","7247779797","12/25/2019 15:17:00","120","CALL"

select * from statements;
CELL_PN,START_DATE,END_DATE,TOTAL_MINUTES,TOTAL_SMS,AMOUNT_DUE,PREVIOUS_BALANCE
"4121231231","08/01/2019 00:00:00","08/31/2019 00:00:00","250","0","39.99","0"
"4124564564","08/01/2019 00:00:00","08/31/2019 00:00:00","600","0","299.99","200.99"
"4127897897","08/01/2019 00:00:00","08/31/2019 00:00:00","650","0","59.99","0"
"4127417417","08/01/2019 00:00:00","08/31/2019 00:00:00","517","0","49.99","49.99"
"4122582582","08/01/2019 00:00:00","08/31/2019 00:00:00","500","0","139.99","39.99"
"4843504021","08/01/2019 00:00:00","08/31/2019 00:00:00","230","0","59.99","0"
"7248889898","08/01/2019 00:00:00","08/31/2019 00:00:00","50","0","25.99","25.99"
"7249879879","08/01/2019 00:00:00","08/31/2019 00:00:00","700","0","159.99","50"
"4846235161","08/01/2019 00:00:00","08/31/2019 00:00:00","200","0","199.99","100"
"4846452231","08/01/2019 00:00:00","08/31/2019 00:00:00","500","0","179.99","59.99"

SQL: begin
    INSERT INTO RECORDS values(4121231231, 4124564564, TO_TIMESTAMP('24-Aug-19:11:05','DD-MON-RR:HH24:MI'), 1000, 'call');
end;
Message: PL/SQL procedure successfully completed

select * from records;
FROM_PN,TO_PN,START_TIMESTAMP,DURATION,TYPE
"4121231231","4124564564","12/25/2017 11:05:00","300","CALL"
"4121231231","7247779797","12/25/2017 17:10:00","300","CALL"
"4124564564","7247778787","08/08/2019 11:05:00","300","CALL"
"7248889898","7247779797","08/15/2019 14:17:00","60","CALL"
"7248889898","7247778787","09/01/2019 11:03:00","300","CALL"
"7249879879","7248889898","09/03/2019 17:24:00","100","CALL"
"4127417417","7249879879","09/05/2019 18:24:00","123","CALL"
"4843504021","4846235161","09/07/2019 15:23:00","50","CALL"
"4846235161","4846452231","09/23/2019 12:23:00","120","CALL"
"4846452231","7248884545","09/25/2019 13:34:00","200","CALL"
"6243780132","6242311322","09/26/2019 23:12:00","200","CALL"
"6241456123","6241121342","09/30/2019 23:11:00","100","CALL"
"4121231231","6241121342","10/02/2019 11:22:00","200","CALL"
"4121231231","7773504021","08/01/2019 23:05:00","300","CALL"
"4121231231","7773504245","08/02/2019 13:10:00","300","CALL"
"4124564564","7776235161","08/08/2019 14:05:00","300","CALL"
"7776452231","4121231231","08/15/2019 21:17:00","60","CALL"
"7248889898","7776452231","09/01/2019 13:03:00","300","CALL"
"7776235161","7248889898","09/03/2019 15:24:00","100","CALL"
"4127417417","2133504021","09/05/2019 16:24:00","123","CALL"
"2133504245","4122582582","09/07/2019 11:23:00","50","CALL"
"2136452231","4122582582","09/23/2019 14:23:00","120","CALL"
"4846452231","2136452231","09/25/2019 21:34:00","200","CALL"
"4846452231","2136235161","09/26/2019 22:12:00","200","CALL"
"2133504021","4846452231","09/30/2019 12:11:00","100","CALL"
"4121231231","2133504021","10/02/2019 18:22:00","200","CALL"
"7686452231","4122582582","09/23/2019 16:23:00","230","CALL"
"4846452231","7686452124","09/25/2019 22:34:00","120","CALL"
"4846452231","7686452231","09/26/2019 23:12:00","300","CALL"
"7686452231","4846452231","10/01/2019 12:11:00","160","CALL"
"4121231231","7686452345","10/04/2019 18:22:00","550","CALL"
"4121231231","7783504245","08/04/2019 18:22:00","400","CALL"
"7783504021","4122582582","09/25/2019 22:23:00","250","CALL"
"4846452231","7786235161","10/05/2019 16:34:00","130","CALL"
"4121231231","2146452231","08/06/2019 18:22:00","100","CALL"
"2146452231","4122582582","09/27/2019 19:23:00","550","CALL"
"4846452231","2146452345","10/10/2019 20:34:00","150","CALL"
"4843504021","4846235161","10/13/2019 15:23:00","50","CALL"
"4846235161","4846452231","10/13/2019 12:23:00","120","CALL"
"4846452231","4846235161","10/25/2019 13:34:00","200","CALL"
"6243780132","6242311322","11/01/2019 23:12:00","200","CALL"
"6241456123","6241121342","11/05/2019 23:11:00","100","CALL"
"7248889898","7247779797","12/25/2019 10:17:00","60","CALL"
"7248889898","7247779797","12/25/2019 15:17:00","120","CALL"
"4121231231","4124564564","08/24/2019 11:05:00","1000","call"

select * from statements;
CELL_PN,START_DATE,END_DATE,TOTAL_MINUTES,TOTAL_SMS,AMOUNT_DUE,PREVIOUS_BALANCE
"4121231231","08/01/2019 00:00:00","08/31/2019 00:00:00","1250","0","39.99","0"
"4124564564","08/01/2019 00:00:00","08/31/2019 00:00:00","1600","0","299.99","200.99"
"4127897897","08/01/2019 00:00:00","08/31/2019 00:00:00","650","0","59.99","0"
"4127417417","08/01/2019 00:00:00","08/31/2019 00:00:00","517","0","49.99","49.99"
"4122582582","08/01/2019 00:00:00","08/31/2019 00:00:00","500","0","139.99","39.99"
"4843504021","08/01/2019 00:00:00","08/31/2019 00:00:00","230","0","59.99","0"
"7248889898","08/01/2019 00:00:00","08/31/2019 00:00:00","50","0","25.99","25.99"
"7249879879","08/01/2019 00:00:00","08/31/2019 00:00:00","700","0","159.99","50"
"4846235161","08/01/2019 00:00:00","08/31/2019 00:00:00","200","0","199.99","100"
"4846452231","08/01/2019 00:00:00","08/31/2019 00:00:00","500","0","179.99","59.99"