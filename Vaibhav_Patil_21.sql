/* IMPORTANT INSTRUCTIONS FOR LEARNERS
1) DO NOT CHANGE THE ORDER OF COLUMNS.
2) YOUR QUERY SHOULD DISPLAY COLUMNS IN THE SAME ORDER AS MENTIONED IN ALL QUESTIONS.
3) YOU CAN FIND THE ORDER OF COLUMNS IN QUESTION TEMPLATE SECTION OF EACH QUESTION.
4) USE ALIASING AS MENTIONED IN QUESTION TEMPLATE FOR ALL COLUMNS
5) DO NOT CHANGE COLUMN NAMES*/
Use northwind
-- Question 1 (Marks: 2)
-- Objective: Retrieve data using basic SELECT statements
-- List the names of all customers in the database.
-- Question Template: Display CustomerName Column

-- Write your SQL solution here
SELECT 
    CustomerName
FROM
    customers
ORDER BY customerID

-- Question 2 (Marks: 2)
-- Objective: Apply filtering using the WHERE clause
-- Retrieve the names and prices of all products that cost less than $15.
-- Question Template: Display ProductName Column

-- Write your SQL solution here
SELECT 
    ProductName
FROM
    products
WHERE
    price < 15
ORDER BY ProductName

-- Question 3 (Marks: 2)
-- Objective: Use SELECT to extract multiple fields
-- Display all employees first and last names.
-- Question Template: Display FirstName, LastName Columns

-- Write your SQL solution here
SELECT 
    FirstName, LastName
FROM
    employees
ORDER BY EmployeeID;

-- Question 4 (Marks: 2)
-- Objective: Filter data using a function on date values
-- List all orders placed in the year 1997.
-- Question Template: Display OrderID, OrderDate Columns

-- Write your SQL solution here
SELECT 
    OrderID,
    CustomerID,
    DATE_FORMAT(OrderDate, '%D %M %Y') AS OrderDate
FROM
    orders
WHERE
    YEAR(OrderDate) = '1997'
ORDER BY CustomerID

-- Question 5 (Marks: 2)
-- Objective: Apply numeric filters
-- List all products that have a price greater than $50.
-- Question Template: Display ProductName, Price Column

-- Write your SQL solution here
SELECT 
    ProductName, Price
FROM
    products
WHERE
    Price > 50
ORDER BY ProductName

-- Question 6 (Marks: 3)
-- Objective: Perform multi-table JOIN operations
-- Show the names of customers and the names of the employees who handled their orders.
-- Question Template: Display CustomerName, FirstName, LastName Columns

-- Write your SQL solution here
SELECT 
    customers.CustomerName, employees.FirstName, employees.LastName
    -- CONCAT(employees.EmployeeID,
       --      ' -> ',
          --  employees.FirstName,
            -- ' ',
           -- employees.LastName) AS EmployeeID_and_FullName,
   -- CONCAT(customers.CustomerID,
     --       ' -> ',
       --     CustomerName,
         --   ' A.K.A ',
           -- ContactName) AS CustomerID_and_FullName
FROM
    customers
        JOIN
    orders ON orders.CustomerID = customers.CustomerID
        JOIN
    employees ON employees.EmployeeID = orders.EmployeeID
GROUP BY orders.OrderID

-- Question 7 (Marks: 3)
-- Objective: Use GROUP BY for aggregation
-- List each country along with the number of customers from that country.
-- Question Template: Display Country, CustomerCount Columns

-- Write your SQL solution here
SELECT 
    Country, COUNT(customerID) AS CustomerCount
FROM
    customers
GROUP BY Country
ORDER BY country

-- Question 8 (Marks: 3)
-- Objective: Group data by a foreign key relationship and apply aggregation
-- Find the average price of products grouped by category.
-- Question Template: Display CategoryName, AvgPrice Columns

-- Write your SQL solution here
SELECT 
    categories.categoryName, AVG_PRICE.AvgPrice
FROM
    categories
        INNER JOIN
    (SELECT 
        categoryID, AVG(Price) AS AvgPrice
    FROM
        products
    GROUP BY categoryID) AS AVG_PRICE ON categories.categoryID = AVG_PRICE.categoryID
ORDER BY categoryName

-- Question 9 (Marks: 3)
-- Objective: Use aggregation to count records per group
-- Show the number of orders handled by each employee.
-- Question Template: Display EmployeeID, OrderCount Columns

-- Write your SQL solution here
SELECT 
    EmployeeID, COUNT(OrderID) as OrderCount
FROM
    orders
GROUP BY EmployeeID

-- Question 10 (Marks: 3)
-- Objective: Filter results using values from a joined table
-- List the names of products supplied by "Exotic Liquids".
-- Question Template: Display ProductName Column

-- Write your SQL solution here
SELECT 
    ProductName
FROM
    products
        JOIN
    suppliers ON suppliers.SupplierID = products.SupplierID
WHERE
    suppliers.SupplierName = 'Exotic Liquid'
GROUP BY ProductName

-- Question 11 (Marks: 5)
-- Objective: Rank records using aggregation and sort
-- List the top 3 most ordered products (by quantity).
-- Question Template: Display ProductID, TotalOrdered Columns

-- Write your SQL solution here

SELECT 
    products.ProductID,
    SUM(orderdetails.quantity) AS TotalOrdered
FROM
    products
        JOIN
    orderdetails ON orderdetails.ProductID = products.ProductID
GROUP BY products.ProductID
ORDER BY TotalOrdered DESC
LIMIT 3

-- Question 12 (Marks: 5)
-- Objective: Use GROUP BY and HAVING to filter on aggregates
-- Find customers who have placed orders worth more than $10,000 in total.
-- Question Template: Display CustomerName, TotalSpent Columns

-- Write your SQL solution here
SELECT 
    customers.CustomerName,
    SUM(products.Price * orderdetails.Quantity) AS TotalSpent
FROM
    customers
        JOIN
    orders ON orders.CustomerID = customers.CustomerID
        JOIN
    orderdetails ON orders.OrderID = orderdetails.OrderID
        JOIN
    products ON products.productID = orderdetails.productID
GROUP BY Customers.CustomerName , customers.customerID
HAVING TotalSpent > 10000
ORDER BY TotalSpent DESC

-- Question 13 (Marks: 5)
-- Objective: Aggregate and filter at the order level
-- Display order IDs and total order value for orders that exceed $2,000 in value.
-- Question Template: Display OrderID, OrderValue Columns

-- Write your SQL solution here
SELECT 
    orderdetails.OrderID,
    SUM(orderdetails.quantity * products.Price) AS OrderValue
FROM
    orderdetails
        JOIN
    products ON products.productID = orderdetails.productID
GROUP BY orderdetails.orderID
HAVING OrderValue > 2000
ORDER BY OrderValue DESC

-- Question 14 (Marks: 5)
-- Objective: Use subqueries in HAVING clause
-- Find the name(s) of the customer(s) who placed the largest single order (by value).
-- Question Template: Display CustomerName, OrderID, TotalValue Column

-- Write your SQL solution here
WITH TotalOrders as (
	select orderdetails.OrderID, sum(orderdetails.Quantity * products.Price) as TotalValue from orderdetails
    join products on products.ProductID = orderdetails.ProductID
    group by orderdetails.OrderID
    ),
	ValueMax as (
    select max(TotalValue) as Max_O
    from TotalOrders
    )
    
    select customers.CustomerName, orders.OrderID, TotalOrders.TotalValue from TotalOrders
    join orders on orders.OrderID = TotalOrders.OrderID
    join customers on customers.CustomerID = orders.CustomerID
    join ValueMax on ValueMax.Max_O = TotalOrders.TotalValue
    order by orders.OrderID

-- Question 15 (Marks: 5)
-- Objective: Identify records using NOT IN with subquery
-- Get a list of products that have never been ordered.
-- Question Template: Display ProductName Columns

-- Write your SQL solution here
SELECT 
    products.ProductName
FROM
    products
        LEFT OUTER JOIN
    orderdetails ON products.ProductID = orderdetails.ProductID
WHERE
    orderdetails.OrderID IS Null or orderdetails.OrderDetailID is Null
ORDER BY products.ProductName

