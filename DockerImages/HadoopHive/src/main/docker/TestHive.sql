-- Creating Database
CREATE DATABASE IF NOT EXISTS db1;

-- Create Table
CREATE TABLE IF NOT EXISTS db1.employee (
    eid INT,
    ename STRING,
    esalary INT,
    eage INT,
    edept STRING
) STORED AS TEXTFILE;

-- Insert Records
INSERT INTO TABLE db1.employee VALUES (
    1,
    "ABC",
    10000,
    25,
    "X1"
);

-- Read Records
SELECT * FROM db1.employee;

-- Count Records
SELECT COUNT(*) FROM db1.employee;
