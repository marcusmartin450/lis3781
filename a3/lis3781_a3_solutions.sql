-- Create Customer Table
CREATE TABLE customer (
    cus_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(2),
    zip NUMBER(5),
    phone NUMBER(10),
    email VARCHAR2(100),
    balance NUMBER(10,2),
    notes VARCHAR2(255)
);

-- Create Commodity Table
CREATE TABLE commodity (
    com_id NUMBER PRIMARY KEY,
    com_name VARCHAR2(50),
    com_price NUMBER(10,2),
    com_description VARCHAR2(255)
);

-- Create Order Table
CREATE TABLE "order" (
    ord_id NUMBER(4,0) NOT NULL,
    cus_id NUMBER,
    com_id NUMBER,
    ord_num_units NUMBER(5,0) NOT NULL,
    ord_total_cost NUMBER(8,2) NOT NULL,
    ord_notes VARCHAR(255),
    CONSTRAINT pk_order PRIMARY KEY (ord_id),
    CONSTRAINT fk_order_customer FOREIGN KEY (cus_id) REFERENCES customer(cus_id),
    CONSTRAINT fk_order_commodity FOREIGN KEY (com_id) REFERENCES commodity(com_id),
    CONSTRAINT check_unit CHECK (ord_num_units > 0),
    CONSTRAINT check_total CHECK (ord_total_cost > 0)
);

-- Insert Data into Customer Table
INSERT INTO customer VALUES (seq_cus_id.NEXTVAL, 'Beverly', 'Davis', '123 Main St.', 'Detroit', 'MI', 48252, 3135551212, 'bdavis@aol.com', 11500.99, 'recently moved');
INSERT INTO customer VALUES (seq_cus_id.NEXTVAL, 'Stephen', 'Taylor', '456 Elm St.', 'St. Louis', 'MO', 57252, 8155551212, 'taylor@comcast.net', 25.01, NULL);
INSERT INTO customer VALUES (seq_cus_id.NEXTVAL, 'Donna', 'Carter', '789 Beach Ave.', 'Los Angeles', 'CA', 48522, 3135551212, 'dcarter@wow.com', 300.99, 'returning customer');
INSERT INTO customer VALUES (seq_cus_id.NEXTVAL, 'Robert', 'Silverman', '857 Wilbur Rd.', 'Phoenix', 'AZ', 25278, 4805551212, 'rsilverman@aol.com', NULL, NULL);
INSERT INTO customer VALUES (seq_cus_id.NEXTVAL, 'Sally', 'Victors', '534 Holler Way', 'Charleston', 'WV', 78345, 9045551212, 'svictors@wow.com', 500.76, 'new customer');

-- Insert Data into Commodity Table
INSERT INTO commodity VALUES (seq_com_id.NEXTVAL, 'DVD & Player', 109.00, NULL);
INSERT INTO commodity VALUES (seq_com_id.NEXTVAL, 'Cereal', 3.00, 'sugar free');
INSERT INTO commodity VALUES (seq_com_id.NEXTVAL, 'Scrabble', 29.00, 'original');
INSERT INTO commodity VALUES (seq_com_id.NEXTVAL, 'Licorice', 1.89, NULL);
INSERT INTO commodity VALUES (seq_com_id.NEXTVAL, 'Tums', 2.45, 'antacid');

-- Insert Data into Order Table
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 1, 2, 50, 200, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 2, 3, 10, 300, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 3, 4, 8, 64, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 1, 5, 24, 972, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 3, 2, 3, 45, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 2, 4, 7, 770, NULL);
INSERT INTO "order" VALUES (seq_ord_id.NEXTVAL, 5, 3, 15, 883, NULL);

-- Verify Data
SELECT * FROM customer;
SELECT * FROM commodity;
SELECT * FROM order;

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









