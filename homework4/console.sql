create database HomeWork4
use HomeWork4

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Email VARCHAR(100)
);

insert into Customers (CustomerID, FirstName, LastName, Email) values
(1, 'Ayxan', 'Abbasov', 'test1@gmail.com'),
(2, 'Riad', 'Sadiqov', 'test2@gmail.com'),
(3, 'Raul', 'Mamedov','test3@gmail.com')

select * from Customers; -- 1 запрос
update Customers set Email = 'updatedtest@gmail.com' where CustomerID = 1; -- 2 запрос
delete Customers where CustomerID = 3; -- 3 запрос
select * from Customers order by LastName; -- 4 запрос
insert into Customers (CustomerID, FirstName, LastName, Email) values
(3, 'Raul', 'Mamedov', 'test3@gmail.com'),
(4, 'Faik', 'Hasanov', 'test4@gmail.com'),
(5, 'Saleh', 'Birbidov', 'test5@gmail.com') -- 5 запрос



CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

insert into Orders (OrderID, CustomerID, OrderDate, TotalAmount) values
(1, 1, '2025-11-22', 100), -- 6 запрос
(2, 3, '2025-10-11', 153),
(3, 5, '2025-12-15', 230),
(4, 2, '2024-09-10', 111),
(5,4,'2023-02-17', 22);

update Orders set TotalAmount = 1000 where OrderId = 2; -- 7 запрос
delete Orders where OrderID = 3; -- 8 запрос
select * from Orders where CustomerID = 1; -- 9 запрос
select * from Orders where year(OrderDate) = '2023'; -- 10 запрос



CREATE TABLE Products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Price DECIMAL(10, 2)
);

insert into Products(ProductID, ProductName, Price) values -- 11 запрос
(1, 'Doner-Kebab', 4.99),
(2, 'Khinkhali', 10.99),
(3, 'Lule', 7.43),
(4, 'Shaurma', 11.90),
(5, 'Big Mac', 8.90);
select * from Products
update Products set Price = 11.99 where ProductID = 2; -- 12 запрос
delete Products where ProductID = 4; -- 13 запрос
select * from Products where Price > 10; -- 14 запрос
select * from Products where Price <= 50; -- 15 запрос



CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
Price DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

insert into OrderDetails(OrderDetailID, OrderID, ProductID, Quantity, Price) values
(1, 1, 1, 100, 199.99),
(2,2,2,123,449.59);
select * from OrderDetails -- 16 запрос
update OrderDetails set Quantity = 1 where OrderDetailID = 1; -- 17 запрос
delete OrderDetails where OrderDetailID = 2; -- 18 запрос
select * from OrderDetails where OrderDetailID = 1; -- 19 запрос
SELECT * from Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE OrderDetails.ProductID = 2; -- 20 запрос

select Customers.FirstName, Customers.LastName, Orders.OrderID
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID -- 21 запрос

select Customers.FirstName, Products.ProductName, OrderDetails.Quantity
from OrderDetails
inner join Orders ON OrderDetails.OrderID = Orders.OrderID
inner join Customers ON Orders.CustomerID = Customers.CustomerID
inner join Products ON OrderDetails.ProductID = Products.ProductID; -- 22 запрос

select Orders.OrderID, Orders.TotalAmount, Customers.FirstName, Customers.LastName
from Orders
left join Customers on Orders.CustomerID = Customers.CustomerID; -- 23 запрос

select Orders.OrderID, Orders.OrderDate, Orders.TotalAmount,
       Products.ProductName, OrderDetails.Quantity
from Orders
inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID; -- 24 запрос

select Customers.FirstName, Customers.LastName,
       Orders.OrderID, Orders.OrderDate
from Customers
left join Orders on Orders.CustomerID = Customers.CustomerID; -- 25 запрос

select Products.ProductID, Products.ProductName, Orders.OrderID, Orders.OrderDate, Orders.TotalAmount
from Products
right join OrderDetails on Products.ProductID = OrderDetails.ProductID
right join Orders on OrderDetails.OrderID = Orders.OrderID; -- 26 запрос

select Orders.OrderID, Orders.OrderDate, Products.ProductName, OrderDetails.Quantity
from Orders
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
inner join Products on OrderDetails.ProductID = Products.ProductID; -- 27 запрос

select Customers.FirstName, Customers.LastName,
       Orders.OrderID, Orders.OrderDate,
       Products.ProductName,
       OrderDetails.Price
from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
inner join Products on OrderDetails.ProductID = Products.ProductID; -- 28 запрос

select FirstName, LastName
from Customers
where CustomerID in (select CustomerID from Orders where TotalAmount > 500); -- 29 запрос

select ProductName
from Products
where ProductID in (select ProductID from OrderDetails group by ProductID having sum(Quantity) > 10); -- 30 запрос

select Customers.FirstName, Customers.LastName,
(select sum(TotalAmount) from Orders where Orders.CustomerID = Customers.CustomerID) as TotalSpent
from Customers; -- 31 запрос

select ProductName, Price
from Products
where Price > (select avg(Price) from Products); -- 32 запрос

select Orders.OrderID, Orders.OrderDate,
       Customers.FirstName, Customers.LastName,
       Products.ProductName,
       OrderDetails.Quantity, OrderDetails.Price
from Orders
inner join Customers on Orders.CustomerID = Customers.CustomerID
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
inner join Products on OrderDetails.ProductID = Products.ProductID; -- 33 запрос

select Customers.FirstName, Customers.LastName,
       Orders.OrderID,
       Products.ProductName,
       OrderDetails.Quantity, OrderDetails.Price
from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
inner join Products on OrderDetails.ProductID = Products.ProductID; -- 34 запрос

select Customers.FirstName, Customers.LastName,
       Products.ProductName,
       sum(OrderDetails.Quantity * OrderDetails.Price) as TotalSpent
from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
inner join Products on OrderDetails.ProductID = Products.ProductID
group by Customers.FirstName, Customers.LastName, Products.ProductName; -- 35 запрос

select Orders.OrderID,
       sum(OrderDetails.Quantity * OrderDetails.Price) as TotalOrderValue
from Orders
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
group by Orders.OrderID
having sum(OrderDetails.Quantity * OrderDetails.Price) > 1000; -- 36 запрос

select FirstName, LastName
from Customers
where CustomerID in (select CustomerID from Orders group by CustomerID having avg(TotalAmount)
                    >
                    (select avg(TotalAmount) from Orders)); -- 37 запрос

select Customers.FirstName, Customers.LastName, count(Orders.OrderID) as OrderCount
from Customers
left join Orders on Customers.CustomerID = Orders.CustomerID
group by Customers.FirstName, Customers.LastName; -- 38 запрос

select ProductID, sum(Quantity) as TotalQuantity
from OrderDetails
group by ProductID
having sum(Quantity) > 3; -- 39 запрос

select Customers.FirstName, Customers.LastName,
       Orders.OrderID,
       sum(OrderDetails.Quantity) as TotalProducts
from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join OrderDetails on Orders.OrderID = OrderDetails.OrderID
group by Customers.FirstName, Customers.LastName, Orders.OrderID; -- 40 запрос



