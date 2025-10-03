
DROP TABLE IF EXISTS TBL_EMPLOYEE;

CREATE DATABASE KRG_3B
USE KRG_3B

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



