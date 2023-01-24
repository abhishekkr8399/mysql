 CREATE DATABASE OrderDatabase;
USE OrderDatabase;
CREATE TABLE Customer (
cust_id int PRIMARY KEY,
cname varchar(15),
city varchar(15)
);
INSERT INTO Customer VALUES(1,'Akash','Moodbidri');
INSERT INTO Customer VALUES(2,'Rakesh','Mangalore');
INSERT INTO Customer VALUES(3,'Suresh','Karkal');
CREATE TABLE C_order (
orderid int PRIMARY KEY,
odate date,
cust_id int,
ordamt int,
FOREIGN KEY (cust_id) REFERENCES Customer(cust_id) ON DELETE CASCADE ON UPDATE CASCADE
);
( Currently total order amount is not known. You can manually enter or update it later.
Amount=SUM of All(itemPrice * qty )
INSERT INTO C_order VALUES(11,'23-FEB-2018',1,NULL); 
INSERT INTO C_order VALUES(12,'23-JUN-2016',2,NULL);
INSERT INTO C_order VALUES(13,'02-MAR-2015',3,NULL);
INSERT INTO C_order VALUES(14,'02-MAR-2018',3,NULL);
CREATE TABLE Item (
item_id int PRIMARY KEY,
price int,
);
INSERT INTO Item VALUES(101,40);
INSERT INTO Item VALUES(102,70);
INSERT INTO Item VALUES(103,100);
CREATE TABLE Order_item (
orderid int,
item_id int,
qty int,
PRIMARY KEY (orderid,item_id),
FOREIGN KEY(orderid) REFERENCES C_order(orderid) ON DELETE CASCADE ON UPDATE
CASCADE,
FOREIGN KEY(item_id) REFERENCES Item(item_id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Order_item VALUES(11, 101, 4);
INSERT INTO Order_item VALUES(12, 102, 2);
INSERT INTO Order_item VALUES(13, 103, 1);
INSERT INTO Order_item VALUES(12, 101, 5);
INSERT INTO Order_item VALUES(13, 101, 3);
INSERT INTO Order_item VALUES(14, 102, 1);
CREATE TABLE Warehouse (
warehouseid int PRIMARY KEY,
city varchar(20),
);
INSERT INTO Warehouse VALUES(111,'Mangalore');
INSERT INTO Warehouse VALUES(112,'Udupi');
INSERT INTO Warehouse VALUES(113,'Karkal');
CREATE TABLE Shipment (
orderid int,
warehouseid int,
ship_dt date,
PRIMARY KEY (orderid,warehouseid),
FOREIGN KEY(orderid) REFERENCES C_order(orderid) ON DELETE CASCADE ON UPDATE 
CASCADE,
FOREIGN KEY (warehouseid) REFERENCES Warehouse(warehouseid) ON DELETE CASCADE ON 
UPDATE CASCADE
);
INSERT INTO Shipment VALUES(11,111,'24-FEB-2018');
INSERT INTO Shipment VALUES(12,112,'24-JUN-2016');
INSERT INTO Shipment VALUES(13,113,'02-MAR-2015');
INSERT INTO Shipment VALUES(11,113,'23-FEB-2018');
INSERT INTO Shipment VALUES(12,113,'23-JUN-2016');
INSERT INTO Shipment VALUES(13,111,'03-MAR-2015');
INSERT INTO Shipment VALUES(14,111,'03-MAR-2018');

UPDATE C_order SET ordamt=(SELECT SUM(O.qty * T.price) FROM Order_item O, Item T 
WHERE 
 O.item_id=T.item_id AND O.orderid = 11) WHERE orderid = 11;

 UPDATE C_order SET ordamt=(SELECT SUM(O.qty * T.price) FROM Order_item O, Item T WHERE 
 O.item_id=T.item_id AND O.orderid = 12) WHERE orderid = 12;

 UPDATE C_order SET ordamt=(SELECT SUM(O.qty * T.price) FROM Order_item O, Item T WHERE 
 O.item_id=T.item_id AND O.orderid = 13) WHERE orderid = 13;

UPDATE C_order SET ordamt=(SELECT SUM(O.qty * T.price) FROM Order_item O, Item T WHERE 
 O.item_id=T.item_id AND O.orderid = 14) WHERE orderid = 14;

 SELECT C.cname, COUNT(CO.orderid) as 'No of orders' , AVG(CO.ordamt) as 'Average'
FROM Customer C, C_order CO 
WHERE C.cust_id=CO.cust_id 
GROUP BY C.cname, C.cust_id;

SELECT item_id, COUNT(*) AS 'No of orders', SUM(qty) AS 'Total quantity'
FROM Order_item
WHERE orderid IN (
SELECT orderid 
FROM Shipment
GROUP BY orderid 
HAVING COUNT(*) >=2
)
GROUP BY item_id
HAVING COUNT(*) > 2;

SELECT C.cname
FROM Customer C
WHERE NOT EXISTS (
SELECT item_id
FROM Item
WHERE item_id NOT IN (
SELECT (I.item_id)
FROM Order_item I, C_order O
WHERE O.orderid=I.orderid AND O.cust_id=C.cust_id
