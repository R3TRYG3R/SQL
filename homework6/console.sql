CREATE TABLE Students (
    StudentId INT PRIMARY KEY,
    Name VARCHAR(100),
    GroupId INT,
    PaymentStatus VARCHAR(20)
);

INSERT INTO Students (StudentId, Name, GroupId, PaymentStatus) VALUES
(1, 'Иван Иванов', 101, 'оплачено'),
(2, 'Петр Петров', 101, 'неоплачено'),
(3, 'Мария Смирнова', 102, 'оплачено');



CREATE TABLE Group (
    GroupId INT PRIMARY KEY,
    GroupName VARCHAR(100),
    StudentsCount INT
);

INSERT INTO Group (GroupId, GroupName, StudentsCount) VALUES
(101, 'Группа 1', 28),
(102, 'Группа 2', 30),
(103, 'Группа 3', 25);



CREATE TABLE Courses (
    CourseId INT PRIMARY KEY,
    CourseName VARCHAR(100),
    TeacherId INT,
    IsActive BOOLEAN
);

INSERT INTO Courses (CourseId, CourseName, TeacherId, IsActive) VALUES
(1, 'Введение в программирование', 1, TRUE),
(2, 'Математика', 2, TRUE),
(3, 'Физика', 3, FALSE);



CREATE TABLE Teachers (
    TeacherId INT PRIMARY KEY,
    Name VARCHAR(100)
);

INSERT INTO Teachers (TeacherId, Name) VALUES
(1, 'Сергей Сергеев'),
(2, 'Ирина Иванова'),
(3, 'Анна Анатольевна');



CREATE TABLE Grade (
    GradeId INT PRIMARY KEY,
    StudentId INT,
    CourseId INT,
    Grade INT
);

INSERT INTO Grade (GradeId, StudentId, CourseId, Grade) VALUES
(1, 1, 1, 4),
(2, 2, 1, 2),
(3, 3, 2, 5);



CREATE TABLE Warnings (
    WarningId INT PRIMARY KEY,
    StudentId INT,
    Reason VARCHAR(255),
    Date DATETIME
);

INSERT INTO Warnings (WarningId, StudentId, Reason, Date) VALUES
(1, 1, 'Низкая оценка', '2025-02-16 10:00:00'),
(2, 2, 'Низкая оценка', '2025-02-16 10:30:00'),
(3, 3, 'Низкая оценка', '2025-02-16 11:00:00');



CREATE TABLE StudentCourses (
    StudentCourseId INT PRIMARY KEY,
    StudentId INT,
    CourseId INT
);

INSERT INTO StudentCourses (StudentCourseId, StudentId, CourseId) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2);



CREATE TABLE Attendance (
    AttendanceId INT PRIMARY KEY,
    StudentId INT,
    AbsenceDate DATETIME
);

INSERT INTO Attendance (AttendanceId, StudentId, AbsenceDate) VALUES
(1, 1, '2025-02-10'),
(2, 1, '2025-02-11'),
(3, 2, '2025-02-12');



CREATE TABLE RetakeList (
    RetakeId INT PRIMARY KEY,
    StudentId INT,
    Reason VARCHAR(255)
);

INSERT INTO RetakeList (RetakeId, StudentId, Reason) VALUES
(1, 1, 'Более 5 пропусков подряд'),
(2, 2, 'Более 5 пропусков подряд'),
(3, 3, 'Более 5 пропусков подряд');



CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    StudentId INT,
    Amount DECIMAL(10, 2),
    Status VARCHAR(20)
);

INSERT INTO Payments (PaymentId, StudentId, Amount, Status) VALUES
(1, 1, 5000.00, 'оплачено'),
(2, 2, 3000.00, 'неоплачено'),
(3, 3, 4000.00, 'оплачено');



CREATE TABLE GradeHistory (
    HistoryId INT PRIMARY KEY,
    StudentId INT,
    OldGrade INT,
    NewGrade INT,
    ChangeTime DATETIME
);

INSERT INTO GradeHistory (HistoryId, StudentId, OldGrade, NewGrade, ChangeTime) VALUES
(1, 1, 4, 3, '2025-02-16 12:00:00'),
(2, 2, 3, 2, '2025-02-16 12:30:00'),
(3, 3, 5, 4, '2025-02-16 13:00:00');


--------------------------------------------------------------------------------------------------


CREATE TRIGGER restrict_student_addition
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE student_count INT;
    
    SELECT COUNT(*) INTO student_count
    FROM Students
    WHERE GroupId = NEW.GroupId;
    
    IF student_count >= 30 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Группа уже полная (30 студентов)';
    END IF;
END; -- 1 query



CREATE TRIGGER update_student_count
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    UPDATE Group
    SET StudentsCount = StudentsCount + 1
    WHERE GroupId = NEW.GroupId;
END;

CREATE TRIGGER decrement_student_count
AFTER DELETE ON Students
FOR EACH ROW
BEGIN
    UPDATE Group
    SET StudentsCount = StudentsCount - 1
    WHERE GroupId = OLD.GroupId;
END; -- 2 query



CREATE TRIGGER auto_register_student
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE course_exists INT;
    
    SELECT COUNT(*) INTO course_exists
    FROM Courses
    WHERE CourseName = 'Введение в программирование';
    
    IF course_exists > 0 THEN
        INSERT INTO StudentCourses (StudentId, CourseId)
        SELECT NEW.StudentId, CourseId
        FROM Courses
        WHERE CourseName = 'Введение в программирование';
    END IF; 
END; -- 3 query



CREATE TRIGGER warn_low_grade
AFTER INSERT OR UPDATE ON Grade
FOR EACH ROW
BEGIN
    IF NEW.Grade < 3 THEN
        INSERT INTO Warnings (StudentId, Reason, Date)
        VALUES (NEW.StudentId, 'Низкая оценка', NOW());
    END IF;
END; -- 4 query



CREATE TRIGGER prevent_teacher_deletion
BEFORE DELETE ON Teachers
FOR EACH ROW
BEGIN
    DECLARE course_count INT;
    
    SELECT COUNT(*) INTO course_count
    FROM Courses
    WHERE TeacherId = OLD.TeacherId AND IsActive = 1;
    
    IF course_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Невозможно удалить преподавателя с активными курсами';
    END IF;
END; -- 5 query



CREATE TRIGGER save_grade_history
AFTER UPDATE ON Grade
FOR EACH ROW
BEGIN
    INSERT INTO GradeHistory (StudentId, OldGrade, NewGrade, ChangeTime)
    VALUES (OLD.StudentId, OLD.Grade, NEW.Grade, NOW());
END; -- 6 query



CREATE TRIGGER check_consecutive_absences
AFTER INSERT ON Attendance
FOR EACH ROW
BEGIN
    DECLARE consecutive_absences INT;
    
    SELECT COUNT(*) INTO consecutive_absences
    FROM Attendance
    WHERE StudentId = NEW.StudentId AND AbsenceDate >= DATE_SUB(NEW.AbsenceDate, INTERVAL 5 DAY)
    GROUP BY StudentId;
    
    IF consecutive_absences > 5 THEN
        INSERT INTO RetakeList (StudentId, Reason)
        VALUES (NEW.StudentId, 'Более 5 пропусков подряд');
    END IF;
END; -- 7 query



CREATE TRIGGER prevent_student_deletion_with_debts
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    DECLARE has_debts INT;
    
    SELECT COUNT(*) INTO has_debts
    FROM Payments
    WHERE StudentId = OLD.StudentId AND Status = 'неоплачено';
    
    IF has_debts = 0 THEN
        SELECT COUNT(*) INTO has_debts
        FROM Grade
        WHERE StudentId = OLD.StudentId AND Grade < 3;
    END IF;
    
    IF has_debts > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Невозможно удалить студента с долгами';
    END IF;
END; -- 8 query



CREATE TRIGGER update_student_average
AFTER INSERT OR UPDATE ON Grade
FOR EACH ROW
BEGIN
    DECLARE avg_grade DECIMAL(5,2);
    
    SELECT AVG(Grade) INTO avg_grade
    FROM Grade
    WHERE StudentId = NEW.StudentId;
    
    UPDATE Student
    SET AverageGrade = avg_grade
    WHERE StudentId = NEW.StudentId;
END; -- 9 query