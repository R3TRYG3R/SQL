create database Academy
use Academy

create table Curators(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(max) check (LEN(Name) > 0) NOT NULL ,
    Surname nvarchar(max) check (LEN(Surname) > 0) NOT NULL
);

create table Faculties(
    Id int primary key identity (1,1) NOT NULL,
    Financing money check (Financing >= 0) default 0 NOT NULL,
    Name nvarchar(100) unique check (LEN(Name) > 0) NOT NULL
);

create table Departments(
    Id int primary key identity (1,1) NOT NULL,
    Financing money check (Financing >= 0) default 0 NOT NULL,
    Name nvarchar(100) check (LEN(Name) > 0) UNIQUE NOT NULL,
    FacultyId int NOT NULL,
    foreign key (FacultyId) references Faculties(Id)
);

create table Groups(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(10) unique check (LEN(Name) > 0) NOT NULL,
    Year int check (Year >= 1 and Year < 5) NOT NULL,
    DepartmentId int NOT NULL,
    foreign key (DepartmentId) references Departments(Id)
);

create table GroupsCurators(
    Id int primary key identity (1,1) NOT NULL,
    CuratorId int NOT NULL,
    GroupId int NOT NULL,
    foreign key (CuratorId) references Curators(Id),
    foreign key (GroupId) references Groups(Id)
);

create table Subjects(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(100) unique check (LEN(Name) > 0) NOT NULL
);

create table Teachers(
    Id int primary key identity (1,1) NOT NULL,
    Name nvarchar(max) check (LEN(Name) > 0) NOT NULL,
    Salary money check (Salary > 0) NOT NULL,
    Surname nvarchar(max) check (LEN(Surname) > 0) NOT NULL
);

create table Lectures(
    Id int primary key identity (1,1) NOT NULL,
    LectureRoom nvarchar(max) check (LEN(LectureRoom) > 0) NOT NULL,
    SubjectId int NOT NULL,
    TeacherId int NOT NULL,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);

create table GroupsLectures(
    Id int primary key identity (1,1) NOT NULL,
    GroupId int NOT NULL,
    LectureId int NOT NULL,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
);


INSERT INTO Curators (Name, Surname) VALUES
('Ivan', 'Petrov'),
('Maria', 'Sidorova'),
('Oleg', 'Ivanov');

INSERT INTO Faculties (Financing, Name) VALUES
(100000, 'Computer Science'),
(80000, 'Mathematics'),
(90000, 'Physics');

INSERT INTO Departments (Financing, Name, FacultyId) VALUES
(50000, 'Software Engineering', 1),
(40000, 'Applied Mathematics', 2),
(45000, 'Theoretical Physics', 3);

INSERT INTO Groups (Name, Year, DepartmentId) VALUES
('SE-101', 1, 1),
('AM-202', 2, 2),
('TP-303', 3, 3);

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Subjects (Name) VALUES
('Databases'),
('Linear Algebra'),
('Quantum Mechanics');

INSERT INTO Teachers (Name, Surname, Salary) VALUES
('Dmitry', 'Smirnov', 60000),
('Elena', 'Kuznetsova', 55000),
('Sergey', 'Volkov', 58000);

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES
('Room 101', 1, 1),
('Room 202', 2, 2),
('Room 303', 3, 3);

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
(1, 1),
(2, 2),
(3, 3);



select * from Teachers -- 1 запрос
select * from Groups

select f.Name as FacultyName -- 2 запрос
from Faculties f
join Departments D on f.Id = D.FacultyId
group by f.Name, f.Financing, d.Financing
having d.Financing > f.Financing

SELECT c.Surname AS CuratorSurname, g.Name AS GroupName -- 3 запрос
FROM GroupsCurators gc
JOIN Curators c ON gc.CuratorId = c.Id
JOIN Groups g ON gc.GroupId = g.Id;

SELECT t.Name, t.Surname -- 4 запрос
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
WHERE g.Name = 'P107';

SELECT t.Surname AS TeacherSurname, f.Name AS FacultyName -- 5 запрос
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN Subjects s ON l.SubjectId = s.Id
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
JOIN Departments d ON g.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id;

SELECT d.Name AS DepartmentName, g.Name AS GroupName -- 6 запрос
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id;

SELECT s.Name AS SubjectName -- 7 запрос
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
JOIN Teachers t ON l.TeacherId = t.Id
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams';

SELECT d.Name AS DepartmentName -- 8 запрос
FROM Departments d
JOIN Groups g ON d.Id = g.DepartmentId
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
JOIN Subjects s ON l.SubjectId = s.Id
WHERE s.Name = 'Database Theory';

SELECT g.Name AS GroupName -- 9 запрос
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Computer Science';

SELECT g.Name AS GroupName, f.Name AS FacultyName -- 10 запрос
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id
WHERE g.Year = 5;

SELECT t.Name AS TeacherName, t.Surname AS TeacherSurname, s.Name AS SubjectName, g.Name AS GroupName -- 11 запрос
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
JOIN Subjects s ON l.SubjectId = s.Id
JOIN GroupsLectures gl ON l.Id = gl.LectureId
JOIN Groups g ON gl.GroupId = g.Id
WHERE l.LectureRoom = 'B103';