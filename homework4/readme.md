
# 40 Заданий по DML с использованием JOIN

## 1. Создать таблицу `Customers`:
```sql
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);
```
### Задания:
1. Вставить данные о новом клиенте в таблицу `Customers`.
2. Обновить email клиента с `CustomerID = 1`.
3. Удалить клиента с `CustomerID = 5` из таблицы `Customers`.
4. Выбрать все записи из таблицы `Customers`, отсортированные по фамилии (`LastName`).
5. Вставить несколько новых клиентов в таблицу `Customers`.

## 2. Создать таблицу `Orders`:
```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
```
### Задания:
6. Вставить новый заказ в таблицу `Orders` для клиента с `CustomerID = 1`.
7. Обновить `TotalAmount` заказа с `OrderID = 2`.
8. Удалить заказ с `OrderID = 3` из таблицы `Orders`.
9. Выбрать все заказы клиента с `CustomerID = 1`.
10. Выбрать все заказы, сделанные в 2023 году.

## 3. Создать таблицу `Products`:
```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);
```
### Задания:
11. Вставить новый продукт в таблицу `Products`.
12. Обновить цену продукта с `ProductID = 2`.
13. Удалить продукт с `ProductID = 4` из таблицы `Products`.
14. Выбрать все продукты, цена которых больше 100.
15. Выбрать все продукты, цена которых меньше или равна 50.

## 4. Создать таблицу `OrderDetails` (связь многие ко многим):
```sql
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
```
### Задания:
16. Вставить данные о товаре в заказ в таблицу `OrderDetails`.
17. Обновить количество товара в заказе с `OrderDetailID = 1`.
18. Удалить товар из заказа с `OrderDetailID = 2`.
19. Выбрать все товары из заказа с `OrderID = 1`.
20. Выбрать все заказы, в которых есть продукт с `ProductID = 2`.

## 5. Использование JOIN

### Простые JOIN
21. Выбрать все заказы с полным именем клиента (использовать INNER JOIN между таблицами `Orders` и `Customers`).
22. Выбрать все продукты с именем клиента и количеством товаров, используя INNER JOIN между `OrderDetails`, `Orders` и `Customers`.
23. Используя LEFT JOIN, выбрать все заказы и соответствующие данные о клиентах, включая заказы без клиентов.

### Комбинированные JOIN
24. Используя INNER JOIN, вывести все заказы с названиями продуктов.
25. Используя LEFT JOIN, вывести всех клиентов и их заказы, включая тех, у кого нет заказов.
26. Используя RIGHT JOIN, вывести все продукты и информацию о заказах, в которых они присутствуют.
27. Используя INNER JOIN между таблицами `Products`, `OrderDetails` и `Orders`, вывести все заказы с названиями продуктов.
28. Используя INNER JOIN между таблицами `Customers`, `Orders` и `OrderDetails`, вывести имена клиентов и их заказы с указанием стоимости каждого товара.

### Подзапросы и JOIN
29. Используя подзапрос в SELECT, вывести имена клиентов, которые сделали заказ на сумму больше 500.
30. Используя подзапрос в WHERE, вывести все продукты, которые были заказаны более 10 раз.
31. Используя подзапрос в SELECT, вывести общую сумму всех заказов для каждого клиента.
32. Используя подзапрос в SELECT, вывести все продукты, стоимость которых больше средней стоимости всех продуктов.

### Многоступенчатые JOIN
33. Используя несколько JOIN, вывести все заказы с подробной информацией о клиентах и продуктах.
34. Написать запрос с использованием нескольких JOIN, чтобы вывести список клиентов, их заказов и продуктов, которые они заказали, с количеством и ценой.
35. Используя несколько JOIN, вывести список всех клиентов и продуктов, которые они купили, а также суммарную стоимость товаров в каждом заказе.

## 6. Дополнительные задания:
36. Выбрать все заказы с количеством товаров, общая стоимость которых превышает 1000.
37. Выбрать клиентов, у которых заказы превышают среднюю сумму всех заказов.
38. Написать запрос с использованием GROUP BY для подсчета количества заказов каждого клиента.
39. Написать запрос с использованием HAVING для подсчета общего числа товаров, заказанных более чем 3 раза.
40. Выбрать клиентов и количество заказанных товаров для каждого заказа с использованием GROUP BY и JOIN.
