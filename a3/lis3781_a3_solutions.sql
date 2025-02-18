--1
SELECT * FROM v$version;

--2
SELECT version FROM PRODUCT_COMPONENT_VERSION
 WHERE product LIKE 'Oracle Database%';

 --3

 select user from dual;
 --4

SELECT TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI:SS AM') AS CurrentDateTime
FROM dual;

--5

SELECT privilege
FROM user_sys_privs;

SELECT table_name, privilege
FROM user_tab_privs;

--6
SELECT table_name
FROM user_tables;

--7

SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'COMMODITY';

SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'order';

SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'CUSTOMER';

--8

SELECT cus_id, cus_lname, cus_fname, cus_email
FROM customer;

--9 

SELECT cus_id, cus_lname, cus_fname, cus_email, cus_street, cus_city, cus_state
FROM customer
ORDER BY cus_state DESC, cus_lname ASC;

--10

SELECT cus_lname, cus_fname
from customer
where  cus_id =3; 

--11

SELECT cus_id, cus_lname, cus_fname, cus_balance
FROM customer
WHERE cus_balance > 1000
ORDER BY cus_balance DESC;

--12

SELECT com_name, TO_CHAR(com_price, '$9999999990.99') AS formatted_price
FROM commodity
ORDER BY com_price;

--13 

SELECT cus_lname || ', ' || cus_fname AS NAME,
       cus_street || ', ' || cus_city || ', ' || cus_state || ' ' || cus_zip AS ADDRESS
FROM customer
ORDER BY cus_zip DESC;


--14

SELECT *
FROM "order"
WHERE com_id NOT IN (SELECT com_id FROM commodity WHERE com_name = 'cereal');


--15

SELECT cus_id, cus_lname, cus_fname, TO_CHAR(cus_balance, '$9999999990.99') AS formatted_balance
FROM customer
WHERE cus_balance BETWEEN 500 AND 1000;

--16 

SELECT cus_id, cus_lname, cus_fname, TO_CHAR(cus_balance, '$99,999.99') AS formatted_balance
FROM customer
WHERE cus_balance > (SELECT AVG(cus_balance) FROM customer);


--17

SELECT cus_id, cus_lname, cus_fname, TO_CHAR(sum(ord_total_cost), '$99,999.99') AS "total orders"
FROM customer
natural join "order"
GROUP BY cus_id, cus_lname, cus_fname
order by sum(ord_total_cost) desc;

--18

SELECT cus_id, cus_lname, cus_fname, cus_street, cus_zip, cus_city, cus_state
FROM customer
WHERE cus_street LIKE '%Peach%';

--19

SELECT cus_id, cus_lname, cus_fname, TO_CHAR(sum(ord_total_cost), '$99,999.99') AS "total orders"
from customer
natural join "order"
group by cus_id, cus_lname, cus_fname
having sum(ord_total_cost) > 1500
order by sum(ord_total_cost) desc;

--20

select cus_id, cus_fname, cus_lname, ord_num_units
from customer
natural join "order"
where ord_num_units in (30,40,50);


--21

select
cus_id, cus_lname, cus_fname
count(*) as "number of orders"
to_char(min(ord_total_cost), 'L99,999.99') as "minimium order cost "
to_char(max(ord_total_cost), 'L99,999.99') as "maximum order cost "
to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
where exists 
(select count(*)from customer having count(*) >= 5)
group by cus_id, cus_lname, cus_fname;

--22
select
count(*),
count(cus_balance),
sum(cus_balance),
avg(cus_balance),
max(cus_balance),
min(cus_balance),
from customer;

--23

select cus_id from "order"
select distinct cus_id from "order"
select count( distinct cus_id) from "order"

--24

SELECT cu.cus_id, cus_lname, cus_fname, com_name, ord_id,to_char(ord_total_cost, 'L99999.99') AS "order amount"
FROM customer cu
JOIN "order" o ON o.cus_id=cu.cus_id
JOIN commodity co ON co.com_id=o.com_id
ORDER BY ord_total_cost DESC;


--25

SET DEFINE OFF 
select * from COMMODITY;

update commodity
set com_price = 99
where com_name = 'DVD & Player';

select * from commodity;




-









