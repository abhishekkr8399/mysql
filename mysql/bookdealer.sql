CREATE DATABASE book_dealer;
 USE book_dealer;
CREATE TABLE Author (
authorid int PRIMARY KEY,
aname varchar(20),
city varchar(20),
country varchar(20)
);
INSERT INTO Author VALUES(111,'Elmasri','Houston','Canada');
INSERT INTO Author VALUES(112,'Renuka','Delhi','India');
INSERT INTO Author VALUES(113,'Herbert','California','USA');
CREATE TABLE Publisher (
pubid int PRIMARY KEY,
pname varchar(20),
city varchar(20),
country varchar(20)
);
INSERT INTO Publisher VALUES(201,'McGRAW','Delhi','India');
INSERT INTO Publisher VALUES(202,'Pearson','Bangalore','India');
CREATE TABLE Category (
catid int PRIMARY KEY,
description varchar(30),
);
INSERT INTO Category VALUES(1,'Computer Science');
INSERT INTO Category VALUES(2,'Popular Novels');
CREATE TABLE Catalogue (
bookid int PRIMARY KEY,
title varchar(20),
authorid int,
pubid int,
catid int, 
yr int,
price int,
FOREIGN KEY(pubid) REFERENCES Publisher(pubid) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(authorid) REFERENCES Author(authorid) ON DELETE CASCADE ON UPDATE 
CASCADE,
FOREIGN KEY(catid) REFERENCES Category(catid) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Catalogue VALUES(301,'Operating Systems',111,201,1,2008,300);
INSERT INTO Catalogue VALUES(302,'Unix Programming',112,201,1,2007,400);
INSERT INTO Catalogue VALUES(303,'Village Life',113,202,2,2016,100);
CREATE TABLE Order_details (
ordno int ,
bookid int,
qty int,
PRIMARY KEY (ordno,bookid),
FOREIGN KEY(bookid) REFERENCES Catalogue(bookid) ON DELETE CASCADE ON UPDATE 
CASCADE
);
INSERT INTO Order_details VALUES(1,301,10);
INSERT INTO Order_details VALUES(1,302,6);
INSERT INTO Order_details VALUES(2,301,5);
INSERT INTO Order_details VALUES(2,303,1);
INSERT INTO Order_details VALUES(3,303,2);

SELECT A.authorid, A.aname, C.bookid, SUM(O.qty) AS 'Quantity'
FROM Author A, Catalogue C, Order_details O
WHERE A.authorid=C.authorid AND C.bookid=O.bookid
GROUP BY A.authorid, A.aname,C.bookid
HAVING SUM(O.qty) >= ALL (
SELECT SUM(qty)
FROM Order_details
GROUP BY bookid
);

UPDATE Catalogue SET price=price+(price*0.1) WHERE pubid IN (
SELECT pubid FROM Publisher WHERE pname='Pearson');

SELECT COUNT(ordno) AS 'No. of orders',bookid 
FROM Order_details
GROUP BY bookid
HAVING SUM(qty) <=ALL (
SELECT SUM(qty)
FROM Order_details
GROUP BY bookid
);