--Create the Database

CREATE DATABASE OnlineShoppingDB;
GO

USE OnlineShoppingDB;
GO

--Check All 5 Tables

SELECT TOP 5 * FROM Customers;
SELECT TOP 5 * FROM Products;
SELECT TOP 5 * FROM Orders;
SELECT TOP 5 * FROM Order_items;
SELECT TOP 5 * FROM Payments;

-- to count the rows too (should be 120 for most):

-- Count rows in Customers
SELECT COUNT(*) AS CustomerCount FROM Customers;

-- Count rows in Products
SELECT COUNT(*) AS ProductCount FROM Products;

-- Count rows in Orders
SELECT COUNT(*) AS OrderCount FROM Orders;

-- Count rows in Orders_items
SELECT COUNT(*) AS OrderItemsCount FROM Order_items;

-- Count rows in Pay--Order_items → Products.
ALTER TABLE Order_items
ADD CONSTRAINT FK_OrderItems_Products
FOREIGN KEY (product_id) REFERENCES Products(product_id);ments
SELECT COUNT(*) AS PaymentsCount FROM Payments;
------------------------------------------------------------------------------------------------


-- Orders_items → Orders

ALTER TABLE Order_items
ADD CONSTRAINT FK_OrderItems_Orders
FOREIGN KEY (order_id) REFERENCES Orders(order_id);


-- Orders_items → Products
ALTER TABLE Orders_items
ADD CONSTRAINT FK_OrdersItems_Products
FOREIGN KEY (product_id) REFERENCES Products(product_id);


-- Orders → Customers
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);

-- Payments → Orders
ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Orders
FOREIGN KEY (order_id) REFERENCES Orders(order_id);

--View All Foreign Keys in my Database
SELECT 
    FK.name AS ForeignKeyName,
    ParentTable.name AS ParentTable,
    ParentColumn.name AS ParentColumn,
    ReferencedTable.name AS ReferencedTable,
    ReferencedColumn.name AS ReferencedColumn
FROM 
    sys.foreign_keys AS FK
    INNER JOIN sys.foreign_key_columns AS FKC 
        ON FK.object_id = FKC.constraint_object_id
    INNER JOIN sys.tables AS ParentTable 
        ON FK.parent_object_id = ParentTable.object_id
    INNER JOIN sys.columns AS ParentColumn 
        ON FKC.parent_column_id = ParentColumn.column_id 
        AND FKC.parent_object_id = ParentColumn.object_id
    INNER JOIN sys.tables AS ReferencedTable 
        ON FK.referenced_object_id = ReferencedTable.object_id
    INNER JOIN sys.columns AS ReferencedColumn 
        ON FKC.referenced_column_id = ReferencedColumn.column_id 
        AND FKC.referenced_object_id = ReferencedColumn.object_id
ORDER BY 
    ParentTable.name, FK.name;





--2. Write a query that returns the names and countries of customers who made orders with a total amount between £500 and £1000.
SELECT 
    C.name,
    C.country,
    SUM(OI.Total_amount) AS TotalSpent
FROM 
    Customers AS C
    INNER JOIN Orders AS O ON C.customer_id = O.customer_id
    INNER JOIN Order_items AS OI ON O.order_id = OI.order_id
GROUP BY 
    C.name, C.country
HAVING 
    SUM(OI.Total_amount) BETWEEN 500 AND 1000;

--Question 3:
--Get the total amount paid by customers belonging to UK who bought at least more than three products in an order.

SELECT 
    C.name,
    O.order_id,
    SUM(P.Amount_paid) AS TotalPaid
FROM 
    Customers AS C
    INNER JOIN Orders AS O ON C.customer_id = O.customer_id
    INNER JOIN Order_items AS OI ON O.order_id = OI.order_id
    INNER JOIN Payments AS P ON O.order_id = P.order_id
WHERE 
    C.country = 'UK'
GROUP BY 
    C.name, O.order_id
HAVING 
    SUM(OI.quantity) > 3;

/*Write a query that returns the highest and second highest amount_paid from UK or 
Australia – this is calculated after applying VAT as 12.2% multiplied by the amount_paid.
Some of the results are not integer values and your client has asked you to round the 
result to the nearest integer value.*/

SELECT TOP 2 
    ROUND(P.Amount_paid * 1.122, 0) AS VAT_Adjusted_Amount
FROM 
    Customers AS C
    INNER JOIN Orders AS O ON C.customer_id = O.customer_id
    INNER JOIN Payments AS P ON O.order_id = P.order_id
WHERE 
    C.country IN ('UK', 'Australia')
ORDER BY 
    VAT_Adjusted_Amount DESC;


/*Question 5:
Write a query that returns a list of the distinct product_name and the total quantity purchased for each product,
Label the quantity column as total_quantity
Sort the result by total_quantity.*/

SELECT 
    P.product_name,
    SUM(OI.quantity) AS total_quantity
FROM 
    Products AS P
    INNER JOIN Order_items AS OI ON P.product_id = OI.product_id
GROUP BY 
    P.product_name
ORDER BY 
    total_quantity DESC;

/*Write a stored procedure for the query given as: Update the amount_paid of customers 
who purchased either laptop or smartphone as products and amount_paid>=£17000 of 
all orders to the discount of 5%.*/

CREATE PROCEDURE ApplyHighValueDiscount
AS
BEGIN
    -- Update amount_paid by applying 5% discount
    UPDATE P
    SET P.Amount_paid = P.Amount_paid * 0.95
    FROM Payments AS P
    INNER JOIN Orders AS O ON P.order_id = O.order_id
    INNER JOIN Order_items AS OI ON O.order_id = OI.order_id
    INNER JOIN Products AS PR ON OI.product_id = PR.product_id
    WHERE 
        PR.product_name IN ('laptop', 'smartphone')
        AND P.Amount_paid >= 17000;
END;



--Query 1:  (JOIN)Customers from Canada Who Placed Orders

SELECT DISTINCT country FROM Customers;

SELECT 
    C.name, 
    C.country, 
    O.order_date
FROM 
    Customers AS C
    INNER JOIN Orders AS O ON C.customer_id = O.customer_id
WHERE 
    C.country = 'Canada';

--IN Clause (Nested Query)Show product names that have been ordered at least once.

SELECT product_name
FROM Products
WHERE product_id IN (
    SELECT DISTINCT product_id
    FROM Order_items
);

--(System Functions)Find the total number of days since the earliest order date.

SELECT 
    DATEDIFF(DAY, MIN(order_date), GETDATE()) AS DaysSinceFirstOrder
FROM 
    Orders;


--Show customers who used different payment methods across their orders.(e.g., someone used card for one order and PayPal for another)

SELECT 
    C.name,
    COUNT(DISTINCT P.payment_method) AS payment_methods_used
FROM 
    Customers AS C
    INNER JOIN Orders AS O ON C.customer_id = O.customer_id
    INNER JOIN Payments AS P ON O.order_id = P.order_id
GROUP BY 
    C.name
HAVING 
    COUNT(DISTINCT P.payment_method) > 1;


















