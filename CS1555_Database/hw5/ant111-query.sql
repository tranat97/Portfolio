-- Andrew Tran (ant111)

-- Q3
-- a) Full name of customers in Pittsburgh with more than 100 free SMSs
select fname, lname
from customers
where free_sms > 100;

-- b) Full name and phone number of all customers who owe more than $90 in ascending order of amount_due
select fname, lname, cell_pn
from customers natural join (
                            select cell_pn, amount_due 
                            from statements 
                            where amount_due > 90
                            ) s
order by s.amount_due asc;

-- c) For each customer, list all numbers of people who sent them SMSs in descending order of SMS timestamp
select cell_pn, from_pn
from (
        customers c left outer join (
                                    select to_pn, from_pn, start_timestamp
                                    from records
                                    where type = 'sms'
                                    ) r on c.cell_pn=r.to_pn
        )
order by r.start_timestamp desc;

-- d) Calculate the average length of a phone call in september 2019
select round(avg(duration), 2) as "average duration"
from records
where type = 'call' 
        and to_char(start_timestamp, 'mm-yyyy') = '09-2019' 

-- e) Calculate the total amount of payments due for the month of September 2019 for each zip code. List in asc order (of payments_due?)
select c.zip as "zip code", sum(s.amount_due) as "total due"
from customers c natural join (
                                select cell_pn, amount_due
                                from statements
                                where to_char(end_date, 'mm-yyyy') = '09-2019' 
                                ) s
group by c.zip
order by "total due" asc;

-- f) Find the full name of the customer who made the longest phone call on Jan 1st, 2019
select c.fname as "first name", c.lname as "last name"
from customers c join (
                        select from_pn, duration
                        from records
                        where to_char(start_timestamp, 'mm-dd-yyyy') = '01-01-2019'
                        order by duration desc
                        fetch first row only
                        ) r on c.cell_pn=r.from_pn

-- g) List the number of P_Mobile customers in each state
select state, count(cell_pn) 
from customers
group by state;

-- h) List the full names of P_Mobile customers who have not made any calls for the last 7 months
select c.fname as "first name", c.lname as "last name"
from customers c left outer join (
                                    select cell_pn 
                                    from customers 
                                            minus 
                                            select distinct from_pn as "cell_pn"
                                            from records
                                            where start_timestamp >= add_months(current_date, -7)
                                ) r on c.cell_pn=r.cell_pn;

-- i) List the top 2 cities with the highest local traffic (List ties as well)
select city
from (
        select fromCity as city, count(*) as "local calls"
        from (
                (select from_pn, to_pn, city as fromCity
                from (records r join directory d on r.from_pn=d.pn))
                natural join
                (select from_pn, to_pn, city as toCity
                from (records r join directory d on r.to_pn=d.pn))
        )
        where fromCity=toCity
        group by fromCity
    )
order by "local calls" desc
fetch first 2 rows with ties;
