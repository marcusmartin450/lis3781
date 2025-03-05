USE mm20u;

-- --------------------------------------------------
-- Table person
-- --------------------------------------------------
DROP TABLE IF EXISTS person;
CREATE TABLE IF NOT EXISTS person (
    per_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_ssn BINARY(64) NULL,
    per_salt BINARY(64) NULL COMMENT '*only* demo purposes - do *NOT* use *salt* in the name!',
    per_fname VARCHAR(15) NOT NULL,
    per_lname VARCHAR(30) NOT NULL,
    per_street VARCHAR(30) NOT NULL,
    per_city VARCHAR(30) NOT NULL,
    per_state CHAR(2) NOT NULL,
    per_zip VARCHAR(9) NOT NULL,
    per_email VARCHAR(100) NOT NULL,
    per_dob DATE NOT NULL,
    per_type ENUM('a','c','j') NOT NULL COMMENT 'a=attorney, c=client, j=judge',
    per_notes VARCHAR(255) NULL,
    PRIMARY KEY (per_id),
    UNIQUE INDEX ux_per_ssn (per_ssn ASC)
) ENGINE = InnoDB
DEFAULT CHARACTER SET=utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- --------------------------------------------------
-- Table attorney
-- --------------------------------------------------
DROP TABLE IF EXISTS attorney;
CREATE TABLE IF NOT EXISTS attorney (
    per_id SMALLINT UNSIGNED NOT NULL,
    aty_start_date DATE NOT NULL,
    aty_end_date DATE NULL DEFAULT NULL,
    aty_hourly_rate DECIMAL(5,2) UNSIGNED NOT NULL,
    aty_years_in_practice TINYINT UNSIGNED NOT NULL,
    aty_notes VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (per_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_attorney_person
        FOREIGN KEY (per_id)
        REFERENCES person (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- Table client
DROP TABLE IF EXISTS client;
CREATE TABLE IF NOT EXISTS client (
    per_id SMALLINT UNSIGNED NOT NULL,
    cli_notes VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (per_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_client_person
        FOREIGN KEY (per_id)
        REFERENCES person (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- Table court
DROP TABLE IF EXISTS court;
CREATE TABLE IF NOT EXISTS court (
    crt_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    crt_name VARCHAR(100) NOT NULL,
    crt_street VARCHAR(30) NOT NULL,
    crt_city VARCHAR(30) NOT NULL,
    crt_state CHAR(2) NOT NULL,
    crt_zip VARCHAR(9) NOT NULL,
    crt_phone BIGINT NOT NULL,
    crt_email VARCHAR(100) NOT NULL,
    crt_url VARCHAR(100) NOT NULL,
    crt_notes VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (crt_id)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;


-- Table: judge
DROP TABLE IF EXISTS judge;
CREATE TABLE IF NOT EXISTS judge (
    per_id SMALLINT UNSIGNED NOT NULL,
    crt_id TINYINT UNSIGNED NULL DEFAULT NULL,
    jud_salary DECIMAL(8,2) NOT NULL,
    jud_years_in_practice TINYINT UNSIGNED NOT NULL,
    jud_notes VARCHAR(255) NULL DEFAULT NULL,
    PRIMARY KEY (per_id),
    INDEX idx_per_id (per_id ASC),
    INDEX idx_crt_id (crt_id ASC),
    CONSTRAINT fk_judge_person
        FOREIGN KEY (per_id)
        REFERENCES person (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT fk_judge_court
        FOREIGN KEY (crt_id)
        REFERENCES court (crt_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
SHOW WARNINGS;

-- Table: judge_hist
DROP TABLE IF EXISTS judge_hist;
CREATE TABLE IF NOT EXISTS judge_hist (
    jhs_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_id SMALLINT UNSIGNED NOT NULL,
    jhs_crt_id TINYINT NULL,
    jhs_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    jhs_type ENUM('i', 'u', 'd') NOT NULL DEFAULT 'i',
    jhs_salary DECIMAL(8,2) NOT NULL,
    jhs_notes VARCHAR(255) NULL,
    PRIMARY KEY (jhs_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_judge_hist_judge
        FOREIGN KEY (per_id)
        REFERENCES judge (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
SHOW WARNINGS;

-- Table: assignment
DROP TABLE IF EXISTS assignment;
CREATE TABLE IF NOT EXISTS assignment (
    asn_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_cid SMALLINT UNSIGNED NOT NULL,
    per_aid SMALLINT UNSIGNED NOT NULL,
    cse_id SMALLINT UNSIGNED NOT NULL,
    asn_notes VARCHAR(255) NULL,
    PRIMARY KEY (asn_id),
    INDEX idx_per_cid (per_cid ASC),
    INDEX idx_per_aid (per_aid ASC),
    INDEX idx_cse_id (cse_id ASC),
    UNIQUE INDEX ux_per_cid_per_aid_cse_id (per_cid ASC, per_aid ASC, cse_id ASC),
    CONSTRAINT fk_assign_case
        FOREIGN KEY (cse_id)
        REFERENCES `case` (cse_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT fk_assignment_client
        FOREIGN KEY (per_cid)
        REFERENCES client (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT fk_assignment_attorney
        FOREIGN KEY (per_aid)
        REFERENCES attorney (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;
SHOW WARNINGS;

-- Table `case`
DROP TABLE IF EXISTS `case`;
CREATE TABLE IF NOT EXISTS `case` (
    cse_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_id SMALLINT UNSIGNED NOT NULL,
    cse_type VARCHAR(45) NOT NULL,
    cse_description TEXT NOT NULL,
    cse_start_date DATE NOT NULL,
    cse_end_date DATE NULL,
    cse_notes VARCHAR(255) NULL,
    PRIMARY KEY (cse_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_court_case_judge
        FOREIGN KEY (per_id)
        REFERENCES judge (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

-- Table bar
DROP TABLE IF EXISTS bar;
CREATE TABLE IF NOT EXISTS bar (
    bar_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_id SMALLINT UNSIGNED NOT NULL,
    bar_name VARCHAR(45) NOT NULL,
    bar_notes VARCHAR(255) NULL,
    PRIMARY KEY (bar_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_bar_attorney
        FOREIGN KEY (per_id)
        REFERENCES attorney (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

-- Table specialty
DROP TABLE IF EXISTS specialty;
CREATE TABLE IF NOT EXISTS specialty (
    spc_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_id SMALLINT UNSIGNED NOT NULL,
    spc_type VARCHAR(45) NOT NULL,
    spc_notes VARCHAR(255) NULL,
    PRIMARY KEY (spc_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_specialty_attorney
        FOREIGN KEY (per_id)
        REFERENCES attorney (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

-- Table phone
DROP TABLE IF EXISTS phone;
CREATE TABLE IF NOT EXISTS phone (
    phn_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    per_id SMALLINT UNSIGNED NOT NULL,
    phn_num BIGINT UNSIGNED NOT NULL,
    phn_type ENUM('h','c','w','f') NOT NULL COMMENT 'home, cell, work, fax',
    phn_notes VARCHAR(255) NULL,
    PRIMARY KEY (phn_id),
    INDEX idx_per_id (per_id ASC),
    CONSTRAINT fk_phone_person
        FOREIGN KEY (per_id)
        REFERENCES person (per_id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;

SHOW WARNINGS;

-- Data for table person
----------------------------------------

START TRANSACTION;

INSERT INTO person
(per_id, per_ssn, per_salt, per_fname, per_lname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes)
VALUES
(NULL, NULL, NULL, 'Steve', 'Rogers', '437 Southern Drive', 'Rochester', 'NY', '324402222', 'srogers@comcast.net', '1923-10-03', 'c', NULL),
(NULL, NULL, NULL, 'Bruce', 'Wayne', '1007 Mountain Drive', 'Gotham', 'NY', '003208440', 'bwayne@knology.net', '1968-03-20', 'c', NULL),
(NULL, NULL, NULL, 'Peter', 'Parker', '20 Ingram Street', 'New York', 'NY', '102862341', 'pparker@msn.com', '1988-09-12', 'c', NULL),
(NULL, NULL, NULL, 'Jane', 'Thompson', '13563 Ocean View Drive', 'Seattle', 'WA', '032084409', 'jthompson@gmail.com', '1978-05-08', 'c', NULL),
(NULL, NULL, NULL, 'Debra', 'Steele', '543 Oak Ln', 'Milwaukee', 'WI', '286234178', 'dsteele@verizon.net', '1994-07-19', 'c', NULL),
(NULL, NULL, NULL, 'Tony', 'Stark', '332 Palm Avenue', 'Malibu', 'CA', '902638332', 'tstark@yahoo.com', '1972-05-04', 'a', NULL),
(NULL, NULL, NULL, 'Hank', 'Pymi', '2355 Brown Street', 'Cleveland', 'OH', '022348890', 'hpymi@aol.com', '1980-08-28', 'a', NULL),
(NULL, NULL, NULL, 'Bob', 'Best', '4902 Avendale Avenue', 'Scottsdale', 'AZ', '872638332', 'bbest@yahoo.com', '1992-02-10', 'a', NULL),
(NULL, NULL, NULL, 'Sandra', 'Dole', '87912 Lawrence Ave', 'Atlanta', 'GA', '002348890', 'sdole@gmail.com', '1990-01-26', 'a', NULL),
(NULL, NULL, NULL, 'Ben', 'Avery', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', '562638332', 'bavery@hotmail.com', '1983-12-24', 'a', NULL),
(NULL, NULL, NULL, 'Arthur', 'Curry', '3304 Euclid Avenue', 'Miami', 'FL', '000219932', 'acurry@gmail.com', '1975-12-15', 'j', NULL),
(NULL, NULL, NULL, 'Diana', 'Price', '944 Green Street', 'Las Vegas', 'NV', '332048823', 'dprice@sympatico.com', '1980-08-22', 'j', NULL),
(NULL, NULL, NULL, 'Adam', 'Jurris', '98435 Valencia Dr.', 'Gulf Shores', 'AL', '870219932', 'ajurris@gmx.com', '1995-01-31', 'j', NULL),
(NULL, NULL, NULL, 'Judy', 'Sleen', '56343 Rover Ct.', 'Billings', 'MT', '672048823', 'jsleen@sympatico.com', '1970-03-22', 'j', NULL),
(NULL, NULL, NULL, 'Bill', 'Neiderheim', '43567 Netherland Blvd', 'South Bend', 'IN', '320219932', 'bneiderheim@comcast.net', '1982-03-13', 'j', NULL);

COMMIT;

-- Data for table phone
START TRANSACTION;

INSERT INTO phone (phn_id, per_id, phn_num, phn_type, phn_notes)
VALUES
(NULL, 1, 8032288827, 'c', NULL),
(NULL, 2, 8503238924, 'h', NULL),
(NULL, 3, 1043432598, 'w', 'has two office numbers'),
(NULL, 5, 6403248932, 'w', NULL),
(NULL, 6, 5508328494, 'f', 'fax number not currently working'),
(NULL, 7, 8202032524, 'c', 'prefers home calls'),
(NULL, 8, 4000832894, 'h', NULL),
(NULL, 9, 7654321984, 'c', NULL),
(NULL, 10, 5463721984, 'f', 'work fax number'),
(NULL, 11, 4537821902, 'c', 'prefers cell phone calls'),
(NULL, 12, 7627821902, 'w', 'best number to reach'),
(NULL, 13, 4537821654, 'w', 'call during lunch'),
(NULL, 14, 3721821902, 'c', 'prefers cell phone calls'),
(NULL, 15, 9217821945, 'f', 'use for faxing legal docs');

COMMIT;

-- Data for table client
START TRANSACTION;

INSERT INTO client (per_id, cli_notes)
VALUES
(1, NULL),
(2, NULL),
(3, NULL),
(4, NULL),
(5, NULL);

COMMIT;

-- Data for table attorney
START TRANSACTION;

INSERT INTO attorney
(per_id, aty_start_date, aty_end_date, aty_hourly_rate, aty_years_in_practice, aty_notes)
VALUES
(6, '2006-06-12', NULL, 85, 5, NULL),
(7, '2003-08-20', NULL, 130, 28, NULL),
(8, '2009-12-12', NULL, 70, 17, NULL),
(9, '2008-06-08', NULL, 78, 13, NULL),
(10, '2011-09-12', NULL, 60, 24, NULL);

COMMIT;

-- Data for table bar
START TRANSACTION;

INSERT INTO bar
(bar_id, per_id, bar_name, bar_notes)
VALUES
(NULL, 6, 'Florida bar', NULL),
(NULL, 7, 'Alabama bar', NULL),
(NULL, 8, 'Georgia bar', NULL),
(NULL, 9, 'Michigan bar', NULL),
(NULL, 10, 'South Carolina bar', NULL),
(NULL, 6, 'Montana bar', NULL),
(NULL, 7, 'Arizona bar', NULL),
(NULL, 8, 'Nevada bar', NULL),
(NULL, 9, 'New York bar', NULL),
(NULL, 10, 'Mississippi bar', NULL),
(NULL, 6, 'California bar', NULL),
(NULL, 7, 'Illinois bar', NULL),
(NULL, 8, 'Illinois bar', NULL),
(NULL, 9, 'Tallahassee Bar', NULL),
(NULL, 10, 'Ocala Bar', NULL),
(NULL, 7, 'Bay County Bar', NULL),
(NULL, 8, 'Cincinnati Bar', NULL);

COMMIT;

START TRANSACTION;

INSERT INTO specialty
(spc_id, per_id, spc_type, spc_notes)
VALUES
(NULL, 6, 'business', NULL),
(NULL, 7, 'traffic', NULL),
(NULL, 8, 'bankruptcy', NULL),
(NULL, 9, 'insurance', NULL),
(NULL, 10, 'judicial', NULL),
(NULL, 6, 'environmental', NULL),
(NULL, 7, 'criminal', NULL),
(NULL, 8, 'real estate', NULL),
(NULL, 9, 'malpractice', NULL);

COMMIT;

START TRANSACTION;

INSERT INTO court
(crt_id, crt_name, crt_street, crt_city, crt_state, crt_zip, crt_phone, crt_email, crt_url, crt_notes)
VALUES
(NULL, 'Leon County Circuit Court', '301 South Monroe Street', 'Tallahassee', 'FL', '323035292', '8506065504', 'lccc@us.fl.gov', 'http://www.leoncountycircuitcourt.gov/', NULL),
(NULL, 'Leon County Traffic Court', '1921 Thomasville Road', 'Tallahassee', 'FL', '323035292', '8505774100', 'lctc@us.fl.gov', 'http://www.leoncountytrafficcourt.gov/', NULL),
(NULL, 'Florida Supreme Court', '500 South Duval Street', 'Tallahassee', 'FL', '323035292', '8504870125', 'fsc@us.fl.gov', 'http://www.floridasupremecourt.org/', NULL),
(NULL, 'Orange County Courthouse', '424 North Orange Avenue', 'Orlando', 'FL', '328012248', '4078362000', 'occ@us.fl.gov', 'http://www.ninthcircuit.org/', NULL),
(NULL, 'Fifth District Court of Appeal', '300 South Beach Street', 'Daytona Beach', 'FL', '321158763', '3862258600', '5dca@us.fl.gov', 'http://www.5dca.org/', NULL);

COMMIT;

START TRANSACTION;

INSERT INTO judge (per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
VALUES
(11, 3, 150000, 10, NULL),
(12, 4, 185000, 3, NULL),
(13, 4, 135000, 2, NULL),
(14, 3, 170000, 6, NULL),
(15, 1, 120000, 1, NULL);

COMMIT;

START TRANSACTION;

INSERT INTO judge_hist (jhs_id, per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
VALUES
(NULL, 11, 3, '2009-01-16', 'i', 130000, NULL),
(NULL, 12, 2, '2010-05-27', 'i', 140000, NULL),
(NULL, 12, 5, '2012-07-05', 'i', 150000, NULL),
(NULL, 14, 4, '2003-07-05', 'i', 135000, NULL),
(NULL, 14, 2, '2011-03-17', 'i', NULL, 'freshman justice'),
(NULL, 15, 1, '2010-07-05', 'i', NULL, 'assigned to another court'),
(NULL, 12, 4, '2012-10-08', 'i', 165000, 'became chief justice'),
(NULL, 14, 3, '2009-04-19', 'i', 170000, 'reassigned to court based upon local area population growth');

COMMIT;


START TRANSACTION;

INSERT INTO `case` (cse_id, per_id, cse_type, cse_description, cse_start_date, cse_end_date, cse_notes)
VALUES
(NULL, 13, 'civil', 'client says that his logo is being used without his consent to promote a rival business', '2010-09-09', NULL, 'copyright infringement'),
(NULL, 12, 'criminal', 'client is charged with assaulting her husband during an argument', '2009-11-18', '2010-12-23', 'assault'),
(NULL, 14, 'civil', 'client broke an ankle while shopping at a local grocery store. no wet floor sign was posted although the floor had just been mopped', '2008-05-06', '2008-07-23', 'slip and fall'),
(NULL, 11, 'criminal', 'client was charged with stealing several televisions from his former place of employment. client has a solid alibi', '2011-05-20', NULL, 'grand theft'),
(NULL, 13, 'criminal', 'client charged with possession of 10 grams of cocaine, allegedly found in his glove box by state police', '2011-06-05', NULL, 'possession of narcotics'),
(NULL, 11, 'civil', 'client alleges newspaper printed false information about his personal activities while he ran a large laundry business in a small nearby town.', '2007-01-19', '2007-05-20', 'defamation'),
(NULL, 12, 'criminal', 'client was charged with the death of his co-worker over a lovers feud. client has no alibi', '2010-03-20', NULL, 'murder'),
(NULL, 14, 'civil', 'client made the horrible mistake of selecting a degree other than IT and had to declare bankruptcy.', '2012-01-26', '2013-02-28', 'bankruptcy');

COMMIT;


START TRANSACTION;

INSERT INTO assignment (asn_id, per_cid, per_aid, cse_id, asn_notes)
VALUES
(NULL, 6, 7, NULL),
(NULL, 2, 6, NULL),
(NULL, 3, 7, NULL),
(NULL, 4, 8, NULL),
(NULL, 5, 9, NULL),
(NULL, 1, 10, NULL),
(NULL, 3, 7, NULL),
(NULL, 7, 8, NULL),
(NULL, 8, 9, NULL),
(NULL, 5, 9, NULL),
(NULL, 4, 10, NULL);

COMMIT;


-- Populate person table with hashed and salted SSN numbers. *MUST* include salted value in DB!
DROP PROCEDURE IF EXISTS CreatePersonSSN;
DELIMITER $$
CREATE PROCEDURE CreatePersonSSN()
BEGIN
    -- MySQL Variables: https://stackoverflow.com/questions/11754781/how-to-declare-a-variable-in-mysql
    DECLARE x, y INT;
    SET x = 1;

    -- dynamically set loop ending value (total number of persons)
    SELECT COUNT(*) INTO y FROM person;
    -- SELECT y; -- display number of persons (only for testing)

    WHILE x <= y DO
        -- give each person a unique randomized salt, and hashed and salted randomized SSN.
        -- Note: this demo is *only* for showing how to include salted and hashed randomized values for testing purposes!
        SET @salt=RANDOM_BYTES(64); -- salt includes unique random bytes for each user when looping
        SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111; -- random 9-digit SSN from 111111111 - 999999999, inclusive
        SET @ssn=UNHEX(SHA2(CONCAT(@salt, @ran_num), 512)); -- each user's SSN value is uniquely randomized and uniquely salted!

        -- RAND([N]): Returns random floating-point value v in the range 0 <= v < 1.0
        -- Documentation: https://dev.mysql.com/doc/refman/5.7/en/mathematical-functions.html#function_rand
        -- randomize ssn between 111111111 - 999999999 (note: using value 000000000 for ex. 4 below)
        UPDATE person
        SET per_ssn=@ssn, per_salt=@salt
        WHERE per_id=x;

        SET x = x + 1;
    END WHILE;

END$$
DELIMITER ;
CALL CreatePersonSSN();


-- show populated per_ssn fields (must use hex() function to convert binary data into readable format)
select 'show populated per_ssn fields after calling stored proc' as '';
select per_id, length(per_ssn) from person order by per_id;
DO SLEEP(7);

DROP PROCEDURE IF EXISTS CreatePersonSSN;

-- #################### DISPLAY TABLE DATA ####################
/*
-- verify table data: pause 5 seconds for each query result set
select 'person table (auto_increment): per_id 1-15' as '';
select * from person;
DO SLEEP(5);
-- or...
select sleep(5); -- though, returns 0
*/
select 'phone table: per_id not all persons have phones (e.g., per_id 3)' as '';
select * from phone;
DO SLEEP(5);

select 'client table: per_id 1-5' as '';
select * from client;
DO SLEEP(5);

select 'attorney table: per_id 6-10' as '';
select * from attorney;
DO SLEEP(5);


DROP VIEW IF EXISTS v_attorney_info;
CREATE VIEW v_attorney_info AS
SELECT 
    CONCAT(per_lname, ', ', per_fname) AS name,
    CONCAT(per_street, ', ', per_city, ', ', per_state, ' ', per_zip) AS address,
    TIMESTAMPDIFF(YEAR, per_dob, NOW()) AS age,
    CONCAT('$', FORMAT(aty_hourly_rate, 2)) AS hourly_rate,
    bar_name, spc_type
FROM person
NATURAL JOIN attorney
NATURAL JOIN bar
NATURAL JOIN specialty
ORDER BY per_lname;

SELECT 'display view v_attorney_info' AS '';
SELECT * FROM v_attorney_info;
DROP VIEW IF EXISTS v_attorney_info;
DO SLEEP(5);


DELIMITER $$

DROP PROCEDURE IF EXISTS GetJudgesByBirthMonth$$
CREATE PROCEDURE GetJudgesByBirthMonth()
BEGIN
    SELECT 
        MONTHNAME(per_dob) AS birth_month, 
        COUNT(*) AS judge_count
    FROM judge
    JOIN person ON judge.per_id = person.per_id
    GROUP BY birth_month
    ORDER BY MONTH(per_dob);
END$$

DELIMITER ;

CALL GetJudgesByBirthMonth();


DELIMITER $$

DROP PROCEDURE IF EXISTS GetCasesWithJudges$$
CREATE PROCEDURE GetCasesWithJudges()
BEGIN
    SELECT 
        c.cse_type, 
        c.cse_description, 
        CONCAT(p.per_lname, ', ', p.per_fname) AS judge_name, 
        CONCAT(p.per_street, ', ', p.per_city, ', ', p.per_state, ' ', p.per_zip) AS address,
        ph.phn_num AS phone_number,
        j.jud_years_in_practice,
        c.cse_start_date, 
        c.cse_end_date
    FROM `case` c
    JOIN judge j ON c.per_id = j.per_id
    JOIN person p ON j.per_id = p.per_id
    LEFT JOIN phone ph ON p.per_id = ph.per_id
    ORDER BY p.per_lname;
END$$

DELIMITER ;

CALL GetCasesWithJudges();


DELIMITER $$

DROP TRIGGER IF EXISTS AfterJudgeInsert$$
CREATE TRIGGER AfterJudgeInsert
AFTER INSERT ON judge
FOR EACH ROW
BEGIN
    INSERT INTO judge_hist (per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
    VALUES (NEW.per_id, NEW.crt_id, NOW(), 'i', NEW.jud_salary, 'New judge added');
END$$

DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS AfterJudgeUpdate$$
CREATE TRIGGER AfterJudgeUpdate
AFTER UPDATE ON judge
FOR EACH ROW
BEGIN
    INSERT INTO judge_hist (per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
    VALUES (NEW.per_id, NEW.crt_id, NOW(), 'u', NEW.jud_salary, 'Judge record updated');
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS one_time_add_judge$$
CREATE PROCEDURE one_time_add_judge()
BEGIN
    INSERT INTO judge (per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
    VALUES ((SELECT MAX(per_id) + 1 FROM judge), 1, 120000, 5, 'One-time event judge');
END$$

DELIMITER ;

DELIMITER $$

DROP EVENT IF EXISTS add_judge_event$$
CREATE EVENT add_judge_event
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO CALL one_time_add_judge();$$

DELIMITER ;

SET GLOBAL event_scheduler = ON;
