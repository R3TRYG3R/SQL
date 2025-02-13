create database Academy
use Academy

create table curators (
id int identity(1,1) primary key,
name nvarchar(max) not null,
surname nvarchar(max) not null
);

create table faculties (
id int identity(1,1) primary key,
name nvarchar(100) not null unique
);

create table departments (
id int identity(1,1) primary key,
building int not null check (building between 1 and 5),
financing money not null check (financing >= 0) default 0,
name nvarchar(100) not null unique,
facultyid int not null,
foreign key (facultyid) references faculties(id)
);

create table groups (
id int identity(1,1) primary key,
name nvarchar(10) not null unique,
year int not null check (year between 1 and 5),
departmentid int not null,
foreign key (departmentid) references departments(id)
);

create table groupscurators (
id int identity(1,1) primary key,
curatorid int not null,
groupid int not null,
foreign key (curatorid) references curators(id),
foreign key (groupid) references groups(id)
);

create table groupslectures (
id int identity(1,1) primary key,
groupid int not null,
lectureid int not null,
foreign key (groupid) references groups(id),
foreign key (lectureid) references lectures(id)
);

create table groupsstudents (
id int identity(1,1) primary key,
groupid int not null,
studentid int not null,
foreign key (groupid) references groups(id),
foreign key (studentid) references students(id)
);

create table students (
id int identity(1,1) primary key,
name nvarchar(max) not null,
surname nvarchar(max) not null,
rating int not null check (rating between 0 and 5)
);

create table subjects (
id int identity(1,1) primary key,
name nvarchar(100) not null unique
);

create table teachers (
id int identity(1,1) primary key,
isprofessor bit not null default 0,
name nvarchar(max) not null,
surname nvarchar(max) not null,
salary money not null check (salary > 0)
);

create table lectures (
id int identity(1,1) primary key,
date date not null check (date <= getdate()),
subjectid int not null,
teacherid int not null,
foreign key (subjectid) references subjects(id),
foreign key (teacherid) references teachers(id)
);



insert into curators (name, surname) values
                                         ('John', 'Smith'),
                                         ('Michael', 'Johnson'),
                                         ('Emily', 'Davis'),
                                         ('Sarah', 'Brown'),
                                         ('James', 'Miller');

insert into faculties (name) values
                                 ('Engineering'),
                                 ('Science'),
                                 ('Arts'),
                                 ('Business'),
                                 ('Medicine');

insert into departments (building, financing, name, facultyid) values
                                                                   (1, 100000, 'Computer Science', 1),
                                                                   (2, 150000, 'Physics', 2),
                                                                   (3, 120000, 'Literature', 3),
                                                                   (4, 200000, 'Finance', 4),
                                                                   (5, 180000, 'Surgery', 5);

insert into groups (name, year, departmentid) values
                                                  ('CS101', 1, 1),
                                                  ('PHY201', 2, 2),
                                                  ('LIT301', 3, 3),
                                                  ('BUS401', 4, 4),
                                                  ('MED501', 5, 5);

insert into groupscurators (curatorid, groupid) values
                                                    (1, 1),
                                                    (2, 2),
                                                    (3, 3),
                                                    (4, 4),
                                                    (5, 5);

insert into subjects (name) values
                                ('Mathematics'),
                                ('Physics'),
                                ('History'),
                                ('Economics'),
                                ('Biology');

insert into teachers (isprofessor, name, surname, salary) values
                                                              (1, 'Robert', 'Williams', 70000),
                                                              (0, 'Jessica', 'Taylor', 50000),
                                                              (1, 'Daniel', 'Anderson', 75000),
                                                              (0, 'Laura', 'Martinez', 48000),
                                                              (1, 'William', 'Garcia', 80000);

insert into students (name, surname, rating) values
                                                 ('David', 'Harris', 4),
                                                 ('Sophia', 'Clark', 5),
                                                 ('Benjamin', 'Lewis', 3),
                                                 ('Emma', 'Walker', 5),
                                                 ('Matthew', 'Allen', 2);

insert into lectures (date, subjectid, teacherid) values
                                                      ('2024-02-01', 1, 1),
                                                      ('2024-02-02', 2, 2),
                                                      ('2024-02-03', 3, 3),
                                                      ('2024-02-04', 4, 4),
                                                      ('2024-02-05', 5, 5);

insert into groupslectures (groupid, lectureid) values
                                                    (1, 1),
                                                    (2, 2),
                                                    (3, 3),
                                                    (4, 4),
                                                    (5, 5);

insert into groupsstudents (groupid, studentid) values
                                                    (1, 1),
                                                    (2, 2),
                                                    (3, 3),
                                                    (4, 4),
                                                    (5, 5);



select building from departments
group by building
having sum(financing > 100000) -- 1 запрос

select g.name
from groups g
join departments d on g.departmentid = d.id
join groupslectures gl on g.id = gl.groupid
join lectures l on gl.lectureid = l.id
where g.year = 5
  and d.name = 'Software Development'
  and l.date between '2024-02-05' and '2024-02-11'
group by g.name
having count(l.id) > 10; -- 2 запрос

select g.name
from groups g
         join groupsstudents gs on g.id = gs.groupid
         join students s on gs.studentid = s.id
group by g.id, g.name
having avg(s.rating) > (
    select avg(s.rating)
    from groups g
             join groupsstudents gs on g.id = gs.groupid
             join students s on gs.studentid = s.id
    where g.name = 'CS101'
); -- 3 запрос

select surname, name
from teachers
where salary > (
    select avg(salary)
    from teachers
    where isprofessor = 1
); -- 4 запрос

select gc.groupid, g.name
from groups g
join groupscurators gc on g.id = gc.groupid
group by gc.groupid, g.name
having Count(gc.groupid) > 1 -- 5 запрос

select g.name
from groups g
join groupsstudents gs on g.id = gs.groupid
join students s on gs.studentid = s.id
group by g.id, g.name
having avg(s.rating) < (
    select min(avg_rating)
    from (
             select g5.id, avg(s.rating) as avg_rating
             from groups g5
                join groupsstudents gs5 on g5.id = gs5.groupid
                join students s on gs5.studentid = s.id
             where g5.year = 5
             group by g5.id
         ) as min_rating_5_course
); -- 6 запрос

select f.name
from faculties f
join departments d on f.id = d.facultyid
group by f.id, f.name
having sum(d.financing) > (
    select sum(d.financing)
    from faculties f
    join departments d on f.id = d.facultyid
    where f.name = 'Engineering'
); -- 7 запрос

select sub.name as subject_name, t.name as teacher_name, t.surname as teacher_surname
from lectures l
         join subjects sub on l.subjectid = sub.id
         join teachers t on l.teacherid = t.id
where exists (
    select 1
    from lectures l1
    group by l1.subjectid, l1.teacherid
    having count(l1.id) = (
        select max(lecture_count)
        from (
                 select l2.subjectid, l2.teacherid, count(l2.id) as lecture_count
                 from lectures l2
                 group by l2.subjectid, l2.teacherid
             ) as lecture_counts
        where lecture_counts.subjectid = l1.subjectid
    )
       and l1.subjectid = l.subjectid
       and l1.teacherid = l.teacherid
); -- 8 запрос

select sub.name
from subjects sub
         join lectures l on sub.id = l.subjectid
group by sub.id, sub.name
having count(l.id) = (
    select min(lecture_count)
    from (
             select subjectid, count(id) as lecture_count
             from lectures
             group by subjectid
         ) as lecture_counts
); -- 9 запрос


select
    (select count(distinct gs.studentid)
     from groups g
              join groupsstudents gs on g.id = gs.groupid
     where g.departmentid = (
         select id from departments where name = 'Physics'
     )) as student_count,

    (select count(distinct l.subjectid)
     from groups g
              join groupslectures gl on g.id = gl.groupid
              join lectures l on gl.lectureid = l.id
     where g.departmentid = (
         select id from departments where name = 'Physics'
     )) as subject_count; -- 10 запрос