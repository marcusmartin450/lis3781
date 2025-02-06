-- lis3781_a2_solutions.sql


CREATE TABLE company (
    cmp_id INT PRIMARY KEY,
    cmp_type ENUM('C-Corp','S-Corp','Non-Profit-Corp','LLC','Partnership'),
    cmp_street VARCHAR(255),
    cmp_city VARCHAR(100),
    cmp_state VARCHAR(50),
    cmp_zip VARCHAR(20),
    cmp_phone VARCHAR(20),
    cmp_ytd_sales DECIMAL(15, 2),
    cmp_url VARCHAR(255),
    cmp_notes TEXT
);

CREATE TABLE customer1 (
    cus_id INT PRIMARY KEY,
    cmp_id INT,
    cus_ssn BINARY(64),
    cus_salt BINARY(64),
    cus_type ENUM('Loyal','Discount','Impulse','Need-Based','Wandering'),
    cus_first VARCHAR(100),
    cus_last VARCHAR(100),
    cus_street VARCHAR(255),
    cus_city VARCHAR(100),
    cus_state VARCHAR(50),
    cus_zip VARCHAR(20),
    cus_phone VARCHAR(20),
    cus_email VARCHAR(100),
    cus_balance DECIMAL(10, 2),
    cus_tot_sales DECIMAL(15, 2),
    cus_notes TEXT,
    FOREIGN KEY (cmp_id) REFERENCES company(cmp_id)
);

-- Inserting data into company table
INSERT INTO company (cmp_id, cmp_type, cmp_street, cmp_city, cmp_state, cmp_zip, cmp_phone, cmp_ytd_sales, cmp_url, cmp_notes)
VALUES
(1, 'C-Corp', '123 Court St', 'New York', 'NY', '10001', '212-555-1234', 5000000.00, 'https://www.nysports.com', 'Major sports apparel retailer'),
(2, 'LLC', '456 Stadium Rd', 'Los Angeles', 'CA', '90001', '310-555-5678', 3500000.00, 'https://www.lasportsteams.com', 'Home of LA sports teams merchandise'),
(3, 'Non-Profit-Corp', '789 Fitness Blvd', 'Chicago', 'IL', '60007', '312-555-6789', 2000000.00, 'https://www.chisportsfoundation.org', 'Non-profit foundation supporting youth sports programs'),
(4, 'S-Corp', '101 Golf Dr', 'Miami', 'FL', '33101', '305-555-4321', 1500000.00, 'https://www.miamigolfclub.com', 'Luxury golf course and club'),
(5, 'Partnership', '202 Racer Ave', 'Indianapolis', 'IN', '46201', '317-555-8765', 4000000.00, 'https://www.indyracingteam.com', 'IndyCar racing team and sponsor');

-- Inserting data into customer1 table
INSERT INTO customer1 (cus_id, cmp_id, cus_ssn, cus_salt, cus_type, cus_first, cus_last, cus_street, cus_city, cus_state, cus_zip, cus_phone, cus_email, cus_balance, cus_tot_sales, cus_notes)
VALUES
(1, 1, 0x1234567890ABCDEF, 0x9876543210FEDCBA, 'Loyal', 'John', 'Doe', '123 Sports Ln', 'New York', 'NY', '10001', '212-555-9876', 'johndoe@example.com', 500.00, 10000.00, 'Loyal customer for 5 years'),
(2, 2, 0xABCDEF1234567890, 0xFEDCBA9876543210, 'Discount', 'Jane', 'Smith', '456 Stadium Rd', 'Los Angeles', 'CA', '90001', '310-555-8765', 'janesmith@example.com', 150.00, 5000.00, 'Purchased tickets to multiple games'),
(3, 3, 0x0011223344556677, 0x8899AABBCCDDEEFF, 'Impulse', 'Michael', 'Johnson', '789 Fitness Blvd', 'Chicago', 'IL', '60007', '312-555-1234', 'michaeljohnson@example.com', 200.00, 12000.00, 'Bought fitness equipment during a sale'),
(4, 4, 0xA1B2C3D4E5F60708, 0xF9E8D7C6B5A40302, 'Need-Based', 'Sarah', 'Taylor', '101 Golf Dr', 'Miami', 'FL', '33101', '305-555-4321', 'sarahtaylor@example.com', 300.00, 8000.00, 'Joined for golf lessons and membership'),
(5, 5, 0x1122334455667788, 0x8877665544332211, 'Wandering', 'James', 'Williams', '202 Racer Ave', 'Indianapolis', 'IN', '46201', '317-555-8765', 'jameswilliams@example.com', 50.00, 2500.00, 'Occasionally attends racing events');



CREATE USER 'user1'@'localhost' IDENTIFIED BY 'Password1!';


GRANT SELECT, UPDATE, DELETE ON mm20u.company TO 'user1'@'localhost';
GRANT SELECT, UPDATE, DELETE ON mm20u.customer1 TO 'user1'@'localhost';


CREATE USER 'user2'@'localhost' IDENTIFIED BY 'Password2!';


GRANT SELECT, INSERT ON mm20u.customer1 TO 'user2'@'localhost';

FLUSH PRIVILEGES;


