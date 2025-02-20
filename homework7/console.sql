
CREATE DATABASE CarDealership;

USE CarDealership;


CREATE TABLE Customers (
                           Id INT PRIMARY KEY IDENTITY(1,1),
                           Name NVARCHAR(100) NOT NULL,
                           Email NVARCHAR(100) UNIQUE NOT NULL,
                           Phone NVARCHAR(20) NOT NULL
);

CREATE TABLE Cars (
                      Id INT PRIMARY KEY IDENTITY(1,1),
                      Brand NVARCHAR(50) NOT NULL,
                      Model NVARCHAR(50) NOT NULL,
                      Year INT CHECK (Year >= 2000),
                      Price DECIMAL(10,2) CHECK (Price > 0)
);

CREATE TABLE Orders (
                        Id INT PRIMARY KEY IDENTITY(1,1),
                        CustomerId INT FOREIGN KEY REFERENCES Customers(Id) ON DELETE CASCADE,
                        CarId INT FOREIGN KEY REFERENCES Cars(Id) ON DELETE CASCADE,
                        OrderDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE CarPriceHistory (
                                 Id INT PRIMARY KEY IDENTITY(1,1),
                                 CarId INT FOREIGN KEY REFERENCES Cars(Id) ON DELETE CASCADE,
                                 OldPrice DECIMAL(10,2),
                                 NewPrice DECIMAL(10,2),
                                 ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DeletedOrdersLog (
                                  Id INT PRIMARY KEY IDENTITY(1,1),
                                  OrderId INT,
                                  CustomerId INT,
                                  CarId INT,
                                  OrderDate DATETIME,
                                  DeletedAt DATETIME DEFAULT GETDATE()
);

INSERT INTO Customers (Name, Email, Phone) VALUES
                                               ('Иван Петров', 'ivan.petrov@email.com', '123-456-789'),
                                               ('Мария Сидорова', 'maria.sidorova@email.com', '987-654-321'),
                                               ('Алексей Смирнов', 'alex.smirnov@email.com', '555-666-777');

INSERT INTO Cars (Brand, Model, Year, Price) VALUES
                                                 ('Toyota', 'Camry', 2022, 30000),
                                                 ('BMW', 'X5', 2023, 60000),
                                                 ('Mercedes', 'C-Class', 2021, 50000);

INSERT INTO Orders (CustomerId, CarId) VALUES
                                           (1, 1),
                                           (2, 2),
                                           (3, 3);



---------------------------------------------------------------------------

-- 1 trigger
create trigger car_price_update
    on Cars
    after update
    as
begin
    if UPDATE(Price)
        begin
            insert into CarPriceHistory (CarId, OldPrice, NewPrice, ChangeDate)
            select d.Id, d.Price, i.Price, GETDATE()
            from deleted d
            join inserted i on d.Id = i.Id;
        end
end;

-- 2 trigger
create trigger delete_client_with_active_users
    on Customers
    instead of delete
    as
begin
    if EXISTS (select 1 from Orders where CustomerId in (select Id from deleted))
    BEGIN
        print('Нельзя удалить клиента с активными заказами.');
        rollback transaction;
    END
    delete from Customers where Id in (select Id from deleted);
end;

-- 3 trigger
create trigger deleted_orders_log
    on Orders
    after delete
        as
    begin
        insert into DeletedOrdersLog (OrderId, CustomerId, CarId, OrderDate, DeletedAt)
        select Id, CustomerId, CarId, OrderDate, getdate()
        from deleted;
end;

-- 4 trigger
create trigger reduce_car_price_by_5
    on Cars
    after update
    as
begin
    if update(Price)
        begin
            insert into CarPriceHistory (CarId, OldPrice, NewPrice, ChangeDate)
            select d.Id, d.Price as OldPrice, i.Price as NewPrice, getdate()
            from deleted d
                join inserted i on d.Id = i.Id;
    end
end;

-- 5 trigger
create trigger duplicate_orders
    on Orders
    instead of insert
    as
begin
    if exists (
        select 1 from inserted i
        join Orders o on i.CustomerId = o.CustomerId and i.CarId = o.CarId
    )
        begin
            print('Этот клиент уже заказал данный автомобиль.');
            rollback transaction;
        end
    insert into Orders (CustomerId, CarId, OrderDate)
    select CustomerId, CarId, OrderDate from inserted;
end;

---------------------------------------------------------------------------