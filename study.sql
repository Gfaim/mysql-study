-- Remove database if exists
-- DROP DATABASE IF EXISTS studysql;

-- Create databases
CREATE DATABASE studysql IF NOT EXISTS;
-- Same as
-- CREATE SCHEMA studysql;


-- Use database, just an alias
USE studysql;

-- Create a new table
CREATE TABLE user
(
    id int unsigned NOT NULL auto_increment,
    username varchar(100) NOT NULL,
    email varchar(100) NOT NULL,
    PRIMARY KEY (id)
);

-- Create two users that fits the requirement of the table "user"
INSERT INTO user (username, email) VALUES ('Allan', "allan.xxx@xxx.xxx");
INSERT INTO user (username, email) VALUES ('Diego', "diego.xxx@xxx.xxx");

-- Update a user by id (change it's username)
UPDATE user SET username="allan" WHERE id=1;

-- Delete a user by id
DELETE FROM user WHERE id=2;

-- Show every "table" where field username=Allan
SELECT * FROM user WHERE username='Allan';

-- Show all databases
SHOW databases;

-- Show all tables inside of used database
SHOW tables;

-- Show fields inside of the table "user"  
DESCRIBE user;

-- Create user
CREATE USER 'alioune'@'%' IDENTIFIED BY 'Yves1234*' IF NOT EXISTS;

-- Grant permission to user (here read, create, update) on database 
GRANT SELECT, INSERT, UPDATE ON studysql.* TO 'alioune'@'%';

-- Grant all permissions on all databases and tables (be able to give other permissions too)
-- GRANT ALL ON *.* TO 'oof'@'localhost' WITH GRANT OPTION;

-- Use back ticks if there is an issue with keyword conflict or a space in a field name, table name or database name
CREATE TABLE `table`
(
    `first name` VARCHAR(30)
);

-- After SELECT, field name is expected (to retrieve only what is needed). 
SELECT `first name` FROM `table` WHERE `first name` LIKE 'a%';

-- Table sheet with all types in mysql
CREATE TABLE typesheet
(
    -- CHAR is a string with a fixed nb of characters, don't use it unless justified
    uuid CHAR(32) CHARACTER SET ascii,
    -- VARCHAR is a string with at most n characters (will truncate if more), btw VARCHAR(255) sucks, try to estimate amount neededs
    name VARCHAR(64) CHARACTER SET ascii, -- "Allan", "Véronique" ...
    -- TEXT is a string with at most 65000 characters => if need bigger, check MEDIUMTEXT or LONGTEXT (up to 4GB)
    description TEXT CHARACTER SET ascii,
    -- INT: don't forget to precise UNSIGNED and AUTO_INCREMENT if needed
    -- AUTO_INCREMENT can stop working if you insert things with a specified id
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- DECIMAL: slower than INT, but on 4 bytes instead of 8 bytes, more exact than int
    `money` DECIMAL(13, 4), -- GAAP compliant
    age DECIMAL UNSIGNED NOT NULL,
    -- Avoid using FLOAT or DOUBLE precision, it is not being useful and costs more performance to truncate and round
    -- FLOAT: floating point number with a precision up to 24, you can precise the precision as parameter
    diameter FLOAT,
    -- DOUBLE: floating point number with a precision up to 53, you can presie the amount of digits stocked and the precision
    pi DOUBLE,
    -- BIT: stock bits. can pass nb of bytes , one by default
    bitshift BIT(4),
    -- BLOB: large binary object not stored in the table
    packet BLOB,
    -- BINARY: 256 bytes binary object stored in the table
    packet_in_table BINARY,
    -- Avoid using ENUM and SET, they are not maintanable as it is defined on the table's creation
    -- ENUM: set of strings to be an enum
    gender ENUM('male', 'female', 'other'), -- can be either male, female or other
    -- SET: same as enum, but can hold multiple values
    col SET('a', 'b', 'c', 'd'), -- can be a and b or b or b and d
    -- JSON: some json string, use JSON_OBJECT, JSON_ARRAY, JSON_MERGE_PRESERVE, JSON_TYPE to query, modify and get the type of the json: https://dev.mysql.com/doc/refman/8.0/en/json.html
    jdoc JSON,
    -- mysql supports a bunch of mathematics / geometry / spatial related types:
    -- check https://dev.mysql.com/doc/refman/8.0/en/spatial-types.html for more

    -- TIME RELATED --
    
    -- All of the following time-related types can have float precision given as parameter in the "()"
    -- TIME ('hhh:mm:ss'), daily
    do_each TIME,
    -- DATE ('YYYY-MM-DD') yearly
    created_day DATE,
    -- DATETIME ('YYYY-MM-DD hh:mm:ss') yearly + daily, use this if you are not sure what you will stock
    created_time DATETIME,
    -- TIMESTAMP ('YYYY-MM-DD hh:mm:ss') same as DATETIME, only diff is the supported range
    archived_time TIMESTAMP(4),
    -- YEAR ('YYYY')
    `year` YEAR,
    PRIMARY KEY (id) -- Make it primary key to auto increment correctly: https://stackoverflow.com/questions/8114535/mysql-1075-incorrect-table-definition-autoincrement-vs-another-key
);

DESCRIBE typesheet;

-- Show all running queries, or waiting to be starting
-- SELECT * FROM information_schema.PROCESSLIST ORDER BY INFO DESC, TIME DESC;

-- Show time running of queries and sort them
-- SELECT ID, USER, HOST, DB, COMMAND, TIME as time_seconds, ROUND(TIME / 60, 2) as time_minutes, ROUND(TIME / 60 / 60, 2) as time_hours, STATE, INFO FROM information_schema.PROCESSLIST ORDER BY INFO DESC, TIME DESC;

-- Casting into int is done implicitly if the digit is the first thing in the string

-- SELECT --
SELECT '123ABC' * 3; -- 246 

CREATE TABLE person
(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    age DECIMAL UNSIGNED,
    name VARCHAR(64) CHARACTER SET ascii,
    gender ENUM('male', 'female', 'other'),
    PRIMARY key (id)
);

CREATE TABLE archive
(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY key (id)
);

INSERT INTO person (age, name, gender) VALUES (19, 'Allan', 'male');
INSERT INTO person (age, name, gender) VALUES (28, 'Alioune', 'male');
-- Insert into but create by default
INSERT INTO archive () VALUES (); -- Insert by default, so current datetime
INSERT INTO archive (created_time) VALUES ('2022-05-10');
INSERT INTO archive (created_time) VALUES ('2021-12-24');
INSERT INTO archive (created_time) VALUES ('2021-12-22');

-- Don't query names that are the same
SELECT DISTINCT `name` FROM person;

-- Avoid using wildcard '*', always specify to get optimization
SELECT * FROM person;

-- Using like to specify query (ex: name contains a "a")
-- LIKE keyword is used to match a pattern. Regexp equivalent: (% = *), (_ = ?) 
-- RLIKE keyword is the same as LIKE but with a regexp pattern (slower)

SELECT * FROM person WHERE name LIKE "%a%";

-- Using CASE WHEN to list person with age > 18
SELECT p.name, p.age, 
    CASE WHEN p.age >= 18
        THEN 'Adult'
        ELSE 'Minor'
    END AS `isAdult`
FROM person as p;

-- Using IF to list person with age > 18
SELECT p.name, p.age, 
    IF (p.age >= 18, 'Adult', 'Minor') AS `isAdult`
FROM person as p;

-- AS is used to rename / create temporary names for columns
SELECT name AS first_name FROM person; -- here column name is named first_name
SELECT name first_name FROM person; -- same

-- LIMIT is used to query a maximum amount of elements (constant): query 4 people by age
-- Always use ORDER BY when using a LIMIT to get predictable rows
SELECT * FROM person ORDER BY age LIMIT 4;
-- LIMIT can have a second argument to specify the maximum number of rows retrieved
SELECT * FROM person ORDER BY age LIMIT 2, 4;

-- WHERE: specify condition to select
SELECT * FROM person WHERE id >= 2 AND id <= 5;

-- BETWEEN: in a where, alternative syntax of the same query
SELECT * FROM person WHERE id BETWEEN 2 AND 5;


-- NOT BETWEEN: negate the BETWEEN (strict)
SELECT * FROM person WHERE id NOT BETWEEN 2 AND 5;

-- Nested query: query inside a query: don't use if you got multiple rows (need to specify one)
SELECT created_time from archive where id = (SELECT id from person WHERE name = 'Allan');

-- Use interval date to query easier between two dates
SELECT created_time from archive WHERE created_time >= '2017-02-01' AND created_time < CURRENT_DATE() + INTERVAL 1 MONTH;

-- NULL is used to create data not initialized on creation, example:
-- NULL is "" if string or 0 if int
CREATE TABLE feedback
(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) CHARACTER SET ascii,
    middle_initial CHAR(1) CHARACTER SET ascii NULL, -- 'Rosemary D. Blood'
    rating SMALLINT NULL, -- 1 to 5 range, so default to 0
    PRIMARY KEY (id)
);
INSERT INTO feedback (name, middle_initial, rating) VALUES ('Rosemary Blood', 'D', 2);
INSERT INTO feedback (name, rating) VALUES ('Allan', 2);
INSERT INTO feedback (name) VALUES ('Diego');

-- Usage of select to check NULL
SELECT `name`, `middle_initial`, `rating` FROM feedback WHERE `middle_initial` IS NOT NULL OR `rating` IS NOT NULL;

