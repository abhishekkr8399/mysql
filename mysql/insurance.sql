CREATE DATABASE insurance;
 USE insurance;
 CREATE TABLE Person (
Driver_id varchar(10) PRIMARY KEY,
Fname varchar(30),
Address varchar(100)
);
INSERT INTO Person VALUES('1','Akash','Jyothi, Mangalore');
INSERT INTO Person VALUES('2','Suresh','Kadri, Mangalore');
INSERT INTO Person VALUES('3','Ramesh','Udyawar, Udupi');
CREATE TABLE Car (
Reg_no varchar(10) PRIMARY KEY,
model varchar(10),
cyear int
);
INSERT INTO Car VALUES('101','Alto 800',2012);
INSERT INTO Car VALUES('102','WagonR',2015);
INSERT INTO Car VALUES('103','Hyundai',2017);
INSERT INTO Car VALUES('104','Ford',2016);
INSERT INTO Car VALUES('105','Audi',2017);
CREATE TABLE Accident 
(
Rept_no int PRIMARY KEY,
Acc_date date,
Location varchar(10)
);
INSERT INTO Accident VALUES('11','12-FEB-2018','Udupi');
INSERT INTO Accident VALUES('12','31-OCT-2014','Mangalore');
INSERT INTO Accident VALUES('13','17-NOV-2018','Karkal');
CREATE TABLE Owns 
(
Driver_id varchar(10),
Reg_no varchar(10) UNIQUE,
PRIMARY KEY(Driver_id,Reg_no),
FOREIGN KEY(Driver_id) REFERENCES Person(Driver_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Reg_no) REFERENCES Car(Reg_no) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Owns VALUES('1','102');
INSERT INTO Owns VALUES('1','103');
INSERT INTO Owns VALUES('3','101');
INSERT INTO Owns VALUES('2','104');
INSERT INTO Owns VALUES('2','105');
CREATE TABLE Participated (
Driver_id varchar(10),
Reg_no varchar(10),
Rept_no int UNIQUE,
damount float,
PRIMARY KEY(Driver_id,Reg_no,Rept_no),
FOREIGN KEY(Driver_id) REFERENCES Person(Driver_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Reg_no) REFERENCES Car(Reg_no) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Rept_no) REFERENCES Accident(Rept_no) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Driver_id,Reg_no) REFERENCES Owns(Driver_id,Reg_no)
);
INSERT INTO Participated VALUES('1','103','11',50500.00);
INSERT INTO Participated VALUES('1','102','12',20300.00);
INSERT INTO Participated VALUES('2','104','13',304899.00);

SELECT COUNT(DISTINCT(Driver_id)) AS 'No. of Owners
FROM Participated P, Accident A 
WHERE P.Rept_no=A.Rept_no AND YEAR(Acc_date)=2018;

SELECT COUNT(Pr.Rept_no) AS 'No. of Accidents'
FROM Participated Pr, Person P
WHERE P.Driver_id = Pr.Driver_id AND P.Fname='Suresh';

UPDATE PARTICIPATED SET damount=30000 WHERE reg_no='102' AND rept_no = '12';