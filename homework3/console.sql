CREATE DATABASE Academy

USE Academy

CREATE TABLE Departments (
Id INT primary key identity (1,1),
Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0,
Name NVARCHAR(100) NOT NULL UNIQUE check (LEN(Name) > 0)
);

CREATE TABLE Faculties (
Id INT primary key identity (1,1),
Dean NVARCHAR(MAX) NOT NULL check (LEN(Dean) > 0),
Name NVARCHAR(100) NOT NULL UNIQUE check (LEN(Name) > 0)
);

CREATE TABLE Groups (
Id INT primary key identity (1,1),
Name NVARCHAR(10) NOT NULL UNIQUE check (LEN(Name) > 0),
Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5)
);

CREATE TABLE Teachers (
Id INT primary key identity (1,1),
EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
IsAssistant BIT NOT NULL DEFAULT 0,
IsProfessor BIT NOT NULL DEFAULT 0,
Name NVARCHAR(MAX) NOT NULL,
Surname NVARCHAR(MAX) NOT NULL,
Position NVARCHAR(MAX) NOT NULL,
Premium MONEY NOT NULL CHECK (Premium >= 0) DEFAULT 0,
Salary MONEY NOT NULL CHECK (Salary > 0)
);



INSERT INTO Departments (Financing, Name) VALUES
(15000, 'Computer Science'),
(12000, 'Mathematics'),
(18000, 'Physics');

select * from Departments

INSERT INTO Faculties (Dean, Name) VALUES
('Dr. Smith', 'Engineering'),
('Dr. Johnson', 'Sciences'),
('Dr. Brown', 'Arts');

select * from Faculties

INSERT INTO Groups (Name, Rating, Year) VALUES
('CS101', 4, 1),
('MAT202', 3, 2),
('PHY303', 5, 3);

select * from Groups

INSERT INTO Teachers (EmploymentDate, IsAssistant, IsProfessor, Name, Surname, Position, Premium, Salary)
VALUES
('2005-09-01', 1, 0, 'Alice', 'Walker', 'Lecturer', 300, 2000),
('2010-06-15', 0, 1, 'Bob', 'Johnson', 'Professor', 500, 3000),
('2015-08-20', 1, 0, 'Charlie', 'Brown', 'Assistant', 250, 1800);

select * from Teachers

-- 1 query
select Name, Financing, Id from Departments;

-- 2 query
select Name as 'Group Name', Rating as 'Group Rating' from Groups;

-- 3 query
select Surname,
       (Premium / Salary) * 100 as "Premium Percentage",
       (Salary / (Salary + Premium)) * 100 as "Salary Percentage"
from Teachers;

-- 4 query
select 'The dean of faculty ' + Name + ' is ' + Dean from Faculties;

-- 5 query
select Surname from Teachers where IsProfessor = 1 and Salary > 1050;

-- 6 query
select Name from Departments where Financing < 11000 or Financing > 25000;

-- 7 query
select Name from Faculties where name != 'Computer Science';

-- 8 query
select Surname, Position from Teachers where IsProfessor = 0;

-- 9 query
select Surname, Position, Salary, Premium from Teachers where Premium between 160 and 550;

-- 10 query
select Surname, Salary from Teachers

-- 11 query
select Surname, Position from Teachers where EmploymentDate < '01.01.2000';

-- 12 query
select Name as 'Name of Department' from Departments where Name < 'Physics' ORDER BY Name;

-- 13 query
select Surname from Teachers where (Salary + Premium) <= 1200 and IsAssistant = 1;

-- 14 query
select Name from Groups where Year = 5 and Rating between 2 and 4;

-- 15 query
select Surname from Teachers where IsAssistant = 1 and Salary < 550 or Premium < 200;