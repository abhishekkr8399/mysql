 CREATE DATABASE bank;
 USE bank;
 CREATE TABLE Branch (
bname varchar(20) PRIMARY KEY,
bcity varchar(20),
assets real
);
INSERT INTO Branch VALUES('Synd MNG','Mangalore',200000);
INSERT INTO Branch VALUES('CORP MNG','Mangalore',700000);
INSERT INTO Branch VALUES('Canera MNG','Mangalore',500000);
INSERT INTO Branch VALUES('SBI UDP','Udupi',600000);
INSERT INTO Branch VALUES('SYND NITTE','Karkal',800000);
CREATE TABLE Account (
accno int PRIMARY KEY,
bname varchar(20),
balance real,
FOREIGN KEY(bname) REFERENCES Branch(bname) ON DELETE CASCADE ON UPDATE 
CASCADE
);
INSERT INTO Account VALUES(1,'Synd MNG',20000);
INSERT INTO Account VALUES(2,'SBI UDP',300);
INSERT INTO Account VALUES(3,'SYND NITTE',5000);
INSERT INTO Account VALUES(4,'SYND NITTE',7000);
INSERT INTO Account VALUES(5,'SYND NITTE',30000);
INSERT INTO Account VALUES(6,'Synd MNG',9000);
INSERT INTO Account VALUES(7,'CORP MNG',11000);
CREATE TABLE Customer (
cname varchar(20) PRIMARY KEY,
cstreet varchar(10),
ccity varchar(20)
);
INSERT INTO Customer VALUES('Ashok','S1','Udupi');
INSERT INTO Customer VALUES('Rajesh','S3','Mangalore');
INSERT INTO Customer VALUES('Sukhesh','S5','Karkala');
CREATE TABLE Depositor 
(
cname varchar(20),
accno int,
PRIMARY KEY(cname,accno),
FOREIGN KEY(cname) REFERENCES Customer(cname) ON DELETE CASCADE ON UPDATE 
CASCADE,
FOREIGN KEY(accno) REFERENCES Account(accno) ON DELETE CASCADE ON UPDATE 
CASCADE
);
INSERT INTO Depositor VALUES('Ashok',1);
INSERT INTO Depositor VALUES('Ashok',2);
INSERT INTO Depositor VALUES('Ashok',3);
INSERT INTO Depositor VALUES('Rajesh',4);
INSERT INTO Depositor VALUES('Rajesh',5);
INSERT INTO Depositor VALUES('Sukhesh',6);
INSERT INTO Depositor VALUES('Sukhesh',7);
CREATE TABLE Loan 
(
lno int PRIMARY KEY,
bname varchar(20),
amt real,
FOREIGN KEY(bname) REFERENCES Branch(bname) ON DELETE CASCADE ON UPDATE 
CASCADE
);
INSERT INTO Loan VALUES(123,'CORP MNG',10000);
CREATE TABLE Borrower 
(
cname varchar(20),
lno int,
PRIMARY KEY(cname,lno),
FOREIGN KEY(cname) REFERENCES Customer(cname) ON DELETE CASCADE ON UPDATE 
CASCADE,
FOREIGN KEY(lno)REFERENCES Loan(lno) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Borrower VALUES('Ashok',123);

SELECT C.cname 
FROM Customer C 
WHERE NOT EXISTS (
SELECT B.bname 
FROM Branch B 
WHERE B.bcity='Karkal' AND B.bname NOT IN (
SELECT A.bname 
FROM Account A, Depositor D
WHERE A.accno=D.accno AND A.bname=B.bname AND D.cname=C.cname
GROUP BY A.bname HAVING COUNT(*)>=2
)
);

SELECT C.cname 
FROM Customer C 
WHERE NOT EXISTS (
SELECT DISTINCT(B.bcity) 
FROM Branch B 
WHERE B.bcity NOT IN (
SELECT B1.bcity 
FROM Account A, Depositor D, Branch B1 
WHERE A.accno=D.accno AND A.bname=B1.bname AND D.cname=C.cname 
GROUP BY B1.bcity HAVING COUNT(*)>=1 (This line is not necessary)
)
);

SELECT C.cname 
FROM Customer C 
WHERE EXISTS (
SELECT COUNT(B.bname)
FROM Branch B, Account A, Depositor D
WHERE B.bcity='Mangalore' AND A.accno=D.accno AND A.bname=B.bname AND
D.cname=C.cname
GROUP BY B.bcity HAVING COUNT(*)>=2
);