----------------------------------------
--- Sample solution for Question #4  ---
----------------------------------------
INSERT INTO DIRECTORY values(4121231231, 'Michael', 'Johnson'  , '320 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4121232131, 'Michael', 'Johnson'  , '320 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4124564564, 'Kate'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4127897897, 'Bill'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4123121231, 'Bill'   , 'Stevenson', '310 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4127417417, 'Richard', 'Hurson'   , '340 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4127417612, 'Richard', 'Hurson'   , '340 Fifth Avenue'  , 'Pittsburgh'   ,15213, 'PA');
INSERT INTO DIRECTORY values(4122582582, 'Mary'   , 'Davis'    , '350 Fifth Avenue'  , 'Pittsburgh'   ,15217, 'PA');
INSERT INTO DIRECTORY values(4122581324, 'Mary'   , 'Davis'    , '350 Fifth Avenue'  , 'Pittsburgh'   ,15217, 'PA');
INSERT INTO DIRECTORY values(7247779797, 'Julia'  , 'Hurson'   , '3350 Fifth Avenue' , 'Philadelphia' ,22221, 'PA');
INSERT INTO DIRECTORY values(7247778787, 'Chris'  , 'Lyn'      , '62 Sixth St'       , 'Philadelphia' ,22222, 'PA');
INSERT INTO DIRECTORY values(7243413412, 'Chris'  , 'Lyn'      , '62 Sixth St'       , 'Philadelphia' ,22222, 'PA');
INSERT INTO DIRECTORY values(7248889898, 'Jones'  , 'Steward'  , '350 Fifth Avenue'  , 'Philadelphia' ,22222, 'PA');
INSERT INTO DIRECTORY values(7249879879, 'James'  , 'Sam'      , '1210 Forbes Avenue', 'Philadelphia' ,22132, 'PA');
INSERT INTO DIRECTORY values(7249871253, 'James'  , 'Sam'      , '1210 Forbes Avenue', 'Philadelphia' ,22132, 'PA');
INSERT INTO DIRECTORY values(6243780132, 'Harry'  , 'Lee'      , '3721 Craig Street' , 'Tridelphia'   ,16161, 'WV');
INSERT INTO DIRECTORY values(6241121342, 'Kate'   , 'Lee'      , '3721 Craig Street' , 'Tridelphia'   ,16161, 'WV');
INSERT INTO DIRECTORY values(6242311322, 'Jack'   , 'Barry'    , '3521 Craig Street' , 'Tridelphia'   ,16161, 'WV');
INSERT INTO DIRECTORY values(6241456123, 'Neil'   , 'Jackson'  , '2134 Seventh St'   , 'Tridelphia'   ,16161, 'WV');
INSERT INTO DIRECTORY values(4843504021, 'Frank'  , 'Shaw'     , '23 Fifth Avenue'   , 'Allentown'    ,14213, 'PA');
INSERT INTO DIRECTORY values(4843504245, 'Frank'  , 'Shaw'     , '23 Fifth Avenue'   , 'Allentown'    ,14213, 'PA');
INSERT INTO DIRECTORY values(4846235161, 'Liam'   , 'Allen'    , '345 Craig Street'  , 'Allentown'    ,14213, 'PA');
INSERT INTO DIRECTORY values(4846452231, 'Justin' , 'Blosser'  , '231 Tenth Street'  , 'Allentown'    ,14213, 'PA');
INSERT INTO DIRECTORY values(4846452124, 'Justin' , 'Blosser'  , '231 Tenth Street'  , 'Allentown'    ,14213, 'PA');

INSERT INTO CUSTOMERS values(123456789, 'Michael', 'Johnson',  4121231231, 4121232131,'320 Fifth Avenue', 'Pittsburgh', 15213,'PA',300,'01-JAN-91',100);
INSERT INTO CUSTOMERS values(123232343, 'Kate'   , 'Stevenson',4124564564, 4123121231,'310 Fifth Avenue', 'Pittsburgh', 15213,'PA',300,'05-FEB-90',100);
INSERT INTO CUSTOMERS values(445526754, 'Bill'   , 'Stevenson',4127897897, 4123121231,'310 Fifth Avenue', 'Pittsburgh', 15213,'PA',600,'11-DEC-92',500);
INSERT INTO CUSTOMERS values(254678898, 'Richard', 'Hurson'   ,4127417417, 4127417612,'340 Fifth Avenue', 'Pittsburgh', 15213,'PA',600,'03-OCT-89',500);
INSERT INTO CUSTOMERS values(256796533, 'Mary'   , 'Davis'    ,4122582582, 4122581324,'350 Fifth Avenue', 'Pittsburgh', 15217,'PA',100,'04-MAR-93',500);
INSERT INTO CUSTOMERS values(245312567, 'Frank'  , 'Shaw'     ,4843504021, 4843504245,'23 Fifth Avenue' , 'Allentown' , 14213,'PA',0,'05-JUN-87',0);
INSERT INTO CUSTOMERS values(251347682, 'Jones'  , 'Steward'  ,7248889898, null, '350 Fifth Avenue' , 'Philadelphia' ,  22222,'PA',150,'04-JAN-90',0);
INSERT INTO CUSTOMERS values(312567834, 'James'  , 'Sam'      ,7249879879, 7249871253,'1210ForbesAvenue','Philadelphia',22132,'PA',100,'15-AUG-88',500);
INSERT INTO CUSTOMERS values(421356312, 'Liam'   , 'Allen'    ,4846235161, null, '345 Craig Street' , 'Allentown'    ,  14213,'PA',0  ,'16-SEP-92',0);
INSERT INTO CUSTOMERS values(452167351, 'Justin' , 'Blosser'  ,4846452231, 4846452124,'231 Tenth Street' , 'Allentown', 14213,'PA',300,'01-MAY-90',100);

INSERT INTO RECORDS values(4121231231, 4124564564, TO_TIMESTAMP('01-Jan-19:11:05','DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS values(4121231231, 7247779797, TO_TIMESTAMP('01-Jan-19:17:10','DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS values(4121231231, 7247779797, TO_TIMESTAMP('01-Jan-19:17:15','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:21:35','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:23:12','DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS values(4124564564, 7247778787, TO_TIMESTAMP('08-Aug-19:11:05','DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS values(4127417417, 7248889898, TO_TIMESTAMP('02-Aug-19:05:32','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(7248889898, 7247779797, TO_TIMESTAMP('15-Aug-19:14:17','DD-MON-RR:HH24:MI'), 60, 'call');
INSERT INTO RECORDS values(7248889898, 7247778787, TO_TIMESTAMP('01-Sep-19:11:03','DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS values(7249879879, 7248889898, TO_TIMESTAMP('03-Sep-19:17:24','DD-MON-RR:HH24:MI'), 100, 'call');
INSERT INTO RECORDS values(4127417417, 7249879879, TO_TIMESTAMP('05-Sep-19:18:24','DD-MON-RR:HH24:MI'), 123, 'call');
INSERT INTO RECORDS values(6243780132, 4846235161, TO_TIMESTAMP('06-Aug-19:20:15','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(4843504021, 4846235161, TO_TIMESTAMP('07-Sep-19:15:23','DD-MON-RR:HH24:MI'), 50, 'call');
INSERT INTO RECORDS values(4846235161, 4846452231, TO_TIMESTAMP('23-Sep-19:12:23','DD-MON-RR:HH24:MI'), 120, 'call');
INSERT INTO RECORDS values(4846452231, 4846235161, TO_TIMESTAMP('25-Sep-19:13:34','DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS values(4121231231, 6242311322, TO_TIMESTAMP('02-Aug-19:20:30','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(7247778787, 6242311322, TO_TIMESTAMP('02-Aug-19:20:31','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:20:32','DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS values(6243780132, 6242311322, TO_TIMESTAMP('26-Sep-19:23:12','DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS values(6241456123, 6241121342, TO_TIMESTAMP('29-Sep-19:23:11','DD-MON-RR:HH24:MI'), 100, 'call');
INSERT INTO RECORDS values(4121231231, 6241121342, TO_TIMESTAMP('30-Sep-19:23:11','DD-MON-RR:HH24:MI'), 200, 'call');

INSERT INTO STATEMENTS values(4121231231, '01-Sep-19','30-Sep-19', 250, 0, 0, 39.99);
INSERT INTO STATEMENTS values(4124564564, '01-Sep-19','30-Sep-19', 600, 30, 200.99, 299.99);
INSERT INTO STATEMENTS values(4127897897, '01-Sep-19','30-Sep-19', 650, 27, 0, 59.99);
INSERT INTO STATEMENTS values(4127417417, '01-Sep-19','30-Sep-19', 517, 96, 49.99,  49.99);
INSERT INTO STATEMENTS values(4122582582, '01-Sep-19','30-Sep-19', 500, 270, 39.99, 139.99);
INSERT INTO STATEMENTS values(4843504021, '01-Sep-19','30-Sep-19', 230, 403, 0, 59.99);
INSERT INTO STATEMENTS values(7248889898, '01-Sep-19','30-Sep-19', 50,  0, 25.99,  25.99);
INSERT INTO STATEMENTS values(7249879879, '01-Sep-19','30-Sep-19', 700, 7, 50, 159.99);
INSERT INTO STATEMENTS values(4846235161, '01-Sep-19','30-Sep-19', 200,	83, 100, 199.99);
INSERT INTO STATEMENTS values(4846452231, '01-Sep-19','30-Sep-19', 500, 12, 59.99, 179.99);

-- INSERT INTO PAYMENTS values(4121231231, '05-Aug-19', 39.99);
-- INSERT INTO PAYMENTS values(4121231231, '04-Sep-19', 39.99);
-- INSERT INTO PAYMENTS values(4124564564, '03-Aug-19', 100);
-- INSERT INTO PAYMENTS values(4127897897, '06-Aug-19', 39.99);
-- INSERT INTO PAYMENTS values(4127417417, '06-Aug-19', 10.00);

COMMIT;