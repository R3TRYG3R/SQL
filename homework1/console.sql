create database Academy

use Academy

create table Teachers(
    Id int primary key identity (1, 1) NOT NULL,
    Name varchar(100) NOT NULL,
    EmploymentDate date NOT NULL check (EmploymentDate >= '1990-01-01'),
    Premium money check (Premium >= 0) default 0 NOT NULL,
    Salary money check(Salary > 0) NOT NULL,
    Surname nvarchar(max) NOT NULL
);

create table Faculties(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(100) unique NOT NULL
);

create table Departments(
    Id int primary key identity (1,1) NOT NULL,
    Financing money check (Financing >= 0) default 0 NOT NULL,
    Name nvarchar(100) unique NOT NULL
);

create table Groups(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(10) unique NOT NULL,
    Rating int check (Rating >= 0 and Rating < 5) NOT NULL,
    Year int check (Year >= 1 and Year < 5) NOT NULL
);


INSERT INTO Teachers (Name, Surname, EmploymentDate, Premium, Salary) VALUES
('John', 'Doe', CAST('2000-05-15' AS DATE), 500, 3000),
('Jane', 'Smith', CAST('1995-09-22' AS DATE), 700, 3200),
('Michael', 'Brown', CAST('2010-07-10' AS DATE), 0, 2800),
('Emily', 'Davis', CAST('2005-11-30' AS DATE), 300, 3500),
('David', 'Wilson', CAST('1998-04-25' AS DATE), 1000, 4000);

INSERT INTO Faculties VALUES
(N'Computer Science'),
(N'Mathematics'),
(N'Physics'),
(N'Biology'),
(N'Chemistry');

INSERT INTO Departments (Financing, Name) VALUES
(100000, N'Software Engineering'),
(75000, N'Theoretical Mathematics'),
(90000, N'Quantum Mechanics'),
(85000, N'Molecular Biology'),
(70000, N'Organic Chemistry');

INSERT INTO Groups (Name, Rating, Year) VALUES
(N'CS101', 4, 1),
(N'MT202', 3, 2),
(N'PH303', 4, 3),
(N'BI404', 2, 4),
(N'CH505', 3, 1);

select * from Teachers
select * from Faculties
select * from Departments
select * from Groups
