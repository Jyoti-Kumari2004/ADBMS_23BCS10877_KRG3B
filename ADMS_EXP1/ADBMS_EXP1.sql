-- ======================================
-- DATABASE: KRG_3B
-- ======================================
DROP TABLE IF EXISTS TBL_EMPLOYEE;

CREATE DATABASE KRG_3B
USE KRG_3B

/*

  EXP 1.1:
    1. TABLE CREATION
    2. APPLYING CONSTRAINTS (DEFAULT, PK, FK, ETC)
    3. JOINS
    4. SUB-QUERIES
*/

-- ======================================
-- 1. TABLE CREATION
-- ======================================

-- Create a table with EMP_ID auto-starting at 101 with increment of 2
CREATE TABLE TBL_EMPLOYEE (
  EMP_ID INT IDENTITY(101, 2),
  EMP_NAME VARCHAR(MAX) ,
  MANAGER_ID INT 
);

INSERT INTO TBL_EMPLOYEE(EMP_NAME) VALUES('Jyoti')
INSERT INTO TBL_EMPLOYEE(EMP_NAME) VALUES('ABC')

-- View inserted records
SELECT * FROM TBL_EMPLOYEE

/*
  SQL COMMANDS OVERVIEW:

  DQL: SELECT
  DDL: CREATE, ALTER, DROP, TRUNCATE, RENAME
  DML: INSERT, UPDATE, DELETE
  DCL: GRANT, REVOKE

  GRANT SELECT, UPDATE ON EMP TO ALOK_04
  REVOKE UPDATE ON EMP FROM ALOK_04

  TRANSACTIONS:
    BEGIN TRANSACTION
    UPDATE STUDENTS SET SNAME = 'A' WHERE SID = 2
    COMMIT / ROLLBACK
    SAVEPOINT
*/

-- ======================================
-- AUTHOR-BOOK RELATIONSHIP (JOIN PRACTICE)
-- ======================================

CREATE TABLE TBL_AUTHOR (
  AUTHOR_ID INT PRIMARY KEY,
  AUTHOR_NAME VARCHAR(MAX),
  COUNTRY VARCHAR(MAX)
)

CREATE TABLE TBL_BOOKS (
  BOOK_ID INT PRIMARY KEY,
  BOOK_TITLE VARCHAR(MAX),
  AUTHORID INT FOREIGN KEY REFERENCES TBL_AUTHOR(AUTHOR_ID)
)
INSERT INTO TBL_AUTHOR (AUTHOR_ID, AUTHOR_NAME, COUNTRY)
VALUES 
  (1, 'J.K. Rowling', 'UK'),
  (2, 'George R.R. Martin', 'USA'),
  (3, 'Chetan Bhagat', 'India');

INSERT INTO TBL_BOOKS (BOOK_ID, BOOK_TITLE, AUTHORID)
VALUES
  (101, 'Harry Potter', 1),
  (102, 'A Game of Thrones', 2),
  (103, 'Five Point Someone', 3),
  (104, 'The Casual Vacancy', 1),
  (105, 'A Clash of Kings', 2);

 SELECT * FROM TBL_AUTHOR;
 SELECT * FROM TBL_BOOKS

-- INNER JOIN to link books and authors
SELECT 
  B.BOOK_TITLE AS 'BOOK TITLE', 
  A.AUTHOR_NAME, 
  A.COUNTRY
FROM TBL_BOOKS AS B
INNER JOIN TBL_AUTHOR AS A
ON B.AUTHORID = A.AUTHOR_ID

-- ======================================
-- SELF JOIN (MANAGER-EMPLOYEE RELATIONSHIP)
-- ======================================

-- Expected structure:
-- EMPLOYEE_TBL(EMP_ID(PK), EMP_NAME, MANAGER_ID(FK))

SELECT 
  E1.EMP_NAME AS [EMP_NAME], 
  E2.EMP_NAME AS [MANAGER_NAME]
FROM TBL_EMPLOYEE AS E1
INNER JOIN TBL_EMPLOYEE AS E2
ON E1.MANAGER_ID = E2.EMP_ID

-- ======================================
-- MEDIUM LEVEL: DEPARTMENT-COURSE SUBQUERY + ACCESS CONTROL
-- ======================================

/*
  1. Create DEPARTMENT and COURSE tables with FK relationship
  2. Insert at least 5 departments and 10 courses
  3. Use subquery to count number of courses under each department
  4. Filter departments with more than 2 courses
  5. Grant SELECT permission on courses to user
*/

-- FINDING 2ND HIGHEST SALARY
-- EMPLOYEE(EMPID, EMP_NAME, SALARY)

-- First Max Salary
-- SELECT MAX(SALARY) FROM EMPLOYEES

-- Second Max Salary
-- SELECT MAX(SALARY) FROM EMPLOYEES WHERE SALARY NOT IN (SELECT MAX(SALARY) FROM EMPLOYEES)

-- ======================================
-- EXPERIMENT 2
-- ======================================

-- data

CREATE TABLE Employee_tbl (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Designation VARCHAR(100),
    Salary INT
);
CREATE TABLE department (
    DeptId INT PRIMARY KEY,
    DeptName VARCHAR(100),
    EmpId INT,  
    FOREIGN KEY (EmpId) REFERENCES Employee_tbl(EmpId)
);

INSERT INTO Employee_tbl (EmpId, EmpName, Designation, Salary) VALUES
(1, 'Jyoti', 'Software Engineer', 70000),
(2, 'Rohit', 'Data Analyst', 60000),
(3, 'Sneha', 'UI/UX Designer', 55000),
(4, 'Ankit', 'HR Manager', 65000);

INSERT INTO department (DeptId, DeptName, EmpId) VALUES
(101, 'IT', 1),
(102, 'Analytics', 2),
(103, 'Design', 3),
(104, 'HR', 4);

-- View data
SELECT * FROM Employee_tbl
SELECT * FROM department

-- INNER JOIN
SELECT Employee_tbl.*, department.*
FROM Employee_tbl 
INNER JOIN department 
ON Employee_tbl.EmpId = department.EmpId

-- Specific Fields with Aliases
SELECT 
  E.Designation, 
  E.EmpName, 
  D.DeptName
FROM Employee_tbl AS E
INNER JOIN department AS D
ON E.EmpId = D.EmpId

-- LEFT OUTER JOIN
SELECT Employee_tbl.*, department.*
FROM Employee_tbl 
LEFT OUTER JOIN department 
ON Employee_tbl.EmpId = department.EmpId

-- RIGHT OUTER JOIN
SELECT Employee_tbl.*, department.*
FROM Employee_tbl 
RIGHT OUTER JOIN department 
ON Employee_tbl.EmpId = department.EmpId

-- FULL OUTER JOIN
SELECT Employee_tbl.*, department.*
FROM Employee_tbl 
FULL OUTER JOIN department 
ON Employee_tbl.EmpId = department.EmpId

-- EMPLOYEE & MANAGER JOIN (Self Join with Department)
SELECT 
  E1.EMP_NAME AS [EMPLOYEE NAME], 
  E2.EMP_NAME AS [MANAGER NAME],
  E1.DEPT AS [EMPLOYEE_DEPT], 
  E2.DEPT AS [MANAGER_DEPT]
FROM EMPLOYEE AS E1
LEFT OUTER JOIN EMPLOYEE AS E2
ON E1.MANAGER_ID = E2.EMP_ID

-- ======================================
-- HARD PART (B): NPV Table Join
-- ======================================

-- Actual NPV Values Table
CREATE TABLE Year_tbl (
  ID INT,
  YEAR INT,
  NPV INT
)

-- Queries Table
CREATE TABLE Queries (
  ID INT,
  YEAR INT
)

-- Insert data into Year_tbl
INSERT INTO Year_tbl (ID, YEAR, NPV) VALUES
(1, 2018, 100),
(7, 2020, 30),
(13, 2019, 40),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(11, 2020, 99),
(7, 2019, 0)

-- Insert data into Queries
INSERT INTO Queries (ID, YEAR) VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019)

-- LEFT JOIN to fetch NPV for given ID and YEAR
SELECT 
  y1.ID, 
  y1.YEAR, 
  ISNULL(y2.NPV, 0)
FROM Queries AS y1
LEFT OUTER JOIN Year_tbl AS y2 
ON y1.ID = y2.ID AND y1.YEAR = y2.YEAR
