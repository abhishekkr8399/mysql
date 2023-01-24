 CREATE DATABASE StudentData;
 USE StudentData;
CREATE TABLE Student (
reg_no varchar(10) PRIMARY KEY,
fname varchar(15),
major varchar (20),
bdate date
);
INSERT INTO Student VALUES ('1','Akash','Academic','1999-11-22');
INSERT INTO Student VALUES ('2','Prakash','Academic','1999-03-04');
INSERT INTO Student VALUES ('3','Rajesh','Academic','2000-01-16');
CREATE TABLE Course (
course_id int PRIMARY KEY,
cname varchar(20),
dept varchar (20)
);
INSERT INTO Course VALUES (101,'RDBMS','CSE');
INSERT INTO Course VALUES (102,'Compiler Design','CSE');
INSERT INTO Course VALUES (103,'JAVA Programming','CSE');
INSERT INTO Course VALUES (104,'Signal Processing','ENC');
INSERT INTO Course VALUES (105,'Digital signals','ENC');
CREATE TABLE Enroll (
reg_no varchar(10),
course_id int,
sem int ,
marks int,
PRIMARY KEY(reg_no,course_id,sem),
FOREIGN KEY(reg_no) REFERENCES Student(reg_no) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Enroll VALUES (1,101,5,76);
INSERT INTO Enroll VALUES (1,102,6,89);
INSERT INTO Enroll VALUES (2,102,6,65);
INSERT INTO Enroll VALUES (2,103,7,49);
INSERT INTO Enroll VALUES (3,104,6,80);
INSERT INTO Enroll VALUES (3,105,7,100);
CREATE TABLE Textbook (
bookISBN int PRIMARY KEY,
title varchar(50),
publisher varchar(20),
author varchar(20)
);
INSERT INTO Textbook VALUES (201,'Fundamentals of DBMS','McGraw','Navathe');
INSERT INTO Textbook VALUES (202,'Database Design','McGraw','Raghu Rama');
INSERT INTO Textbook VALUES (203,'Database Concepts','Pearson','Rajagopal');
INSERT INTO Textbook VALUES (204,'Compiler design','Pearson','Ulman');
INSERT INTO Textbook VALUES (205,'JAVA complete Reference','McGraw','Balaguru');
INSERT INTO Textbook VALUES (206,'Signal Processing','McGraw','Nithin');
CREATE TABLE Book_adaption (
course_id int,
sem int,
bookISBN int,
PRIMARY KEY(course_id, sem, bookISBN),
FOREIGN KEY(course_id) REFERENCES Course(course_id) ON DELETE CASCADE ON UPDATE 
CASCADE,
 FOREIGN KEY(bookISBN) REFERENCES Textbook(bookISBN) ON DELETE CASCADE ON UPDATE 
CASCADE
);
INSERT INTO Book_adaption VALUES (101,5,201);
INSERT INTO Book_adaption VALUES (101,7,202);
INSERT INTO Book_adaption VALUES (101,7,203);
INSERT INTO Book_adaption VALUES (102,6,204);
INSERT INTO Book_adaption VALUES (103,7,205);
INSERT INTO Book_adaption VALUES (104,6,206);
INSERT INTO Book_adaption VALUES (105,7,206);

SELECT DISTINCT(T.bookISBN), T.title, C.course_id, C.cname
FROM Textbook T, Course C, Book_adaption B
WHERE B.bookISBN=T.bookISBN AND C.course_id=B.course_id AND C.dept='CSE'
AND C.course_id IN (
SELECT course_id
FROM Book_adaption
GROUP BY course_id
HAVING COUNT(DISTINCT(bookISBN))>2
)
ORDER BY T.title;

SELECT DISTINCT(C.dept)
FROM Course C
WHERE NOT EXISTS (
SELECT bookISBN
FROM Book_adaption
WHERE course_id IN (
SELECT course_id
FROM Course
WHERE dept=C.dept
)
AND bookISBN NOT IN (
SELECT T.bookISBN 
FROM TEXTBOOK T
WHERE T.publisher='McGraw'
)
);

SELECT DISTINCT(T.bookISBN), T.title, C.dept
FROM Textbook T,Book_adaption B, Course C
WHERE T.bookISBN=B.bookISBN AND B.course_id=C.course_id AND C.dept IN (
SELECT dept
FROM Course C1, Enroll E1
WHERE C1.course_id=E1.course_id
GROUP BY C1.dept
HAVING COUNT(DISTINCT(E1.reg_no)) > = ALL (
SELECT COUNT(DISTINCT(reg_no))
FROM Course C2, Enroll E2
WHERE C2.course_id=E2.course_id
GROUP BY C2.dept
) 
);
