-- Andrew Tran (ant111)

-- Q1
alter table payments add payer_ssn number(9);
alter table payments add CONSTRAINT payer_ssn_fk foreign key (payer_ssn) references CUSTOMERS(ssn);

-- Q2
INSERT INTO PAYMENTS values(4121231231, '05-Aug-19', 39.99, 123456789);
INSERT INTO PAYMENTS values(4121231231, '04-Sep-19', 39.99, 123456789);
INSERT INTO PAYMENTS values(4124564564, '03-Aug-19', 100, 123232343);
INSERT INTO PAYMENTS values(4127897897, '06-Aug-19', 39.99, 445526754);
INSERT INTO PAYMENTS values(4127417417, '06-Aug-19', 10.00, 254678898);
commit;

