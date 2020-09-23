--1
select address,phone 
from student_dir
where sid =123;

--2
select distinct course_no
from course_taken 
where term = 'Spring 11';

--3
select sid, course_no
from course_taken
where term = 'Fall 10' and grade is NULL;

--4
select sid, avg(grade) as gpa
from course_taken
group by sid
having avg(grade)>3.7
order by avg(grade) desc;

--5
select sid, count(distinct course_no) as classes_taken
from course_taken
group by sid
order by sid asc;

select sid, student.name, count(distinct course_taken.course_no) as classes_taken
from student natural join course_taken
group by sid, student.name
order by sid asc;

--6
insert into student
values (130, 'Peter', 1, 'CS', '????');
commit;

select s.sid as sid, s.name as name, count(distinct ct.course_no) as classes_taken
from student s left outer join course_taken ct on s.sid=ct.sid
group by s.sid, s.name
order by s.sid asc;

--7
select sid, course_no, count(*)
from course_taken
group by sid, course_no
having count(*)>1;

--8
create table student_outreach (
    sid varchar2(5) not null,
    name varchar2(15) not null, 
    class number(2),
    major varchar2(10),
    ssn varchar2(16) not null, 
    constraint pk_stud_bad primary key(sid)
);
insert into students_outreach values ('130', 'Zach', 1, 'CS', 'abcd');
commit;

(select *
from student)
union (
select *
from student_outreach);
