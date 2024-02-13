create database assignment;
use assignment;
show tables;
select * from customers;


-- Assignment Day 3--
-- Que. 1 
SELECT customerNumber, customerName, state, creditLimit
FROM customers
WHERE state IS NOT NULL
  AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;

-- Que. 2
SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';


-- Assignment Day 4 --
-- Que. 1
SELECT orderNumber, status, COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';
 
-- Que. 2
SELECT employeeNumber, 
       firstName, 
       jobTitle,
       CASE
           WHEN jobTitle = 'President' THEN 'P'
           WHEN jobTitle LIKE 'Sales Manager%' THEN 'SM'
           WHEN jobTitle = 'Sales Rep' THEN 'SR'
           WHEN jobTitle LIKE '%VP%' THEN 'VP'
           ELSE jobTitle
       END AS jobTitleAbbreviation
FROM employees;


-- Assignment Day 5 --
-- Que. 1
SELECT YEAR(paymentDate) AS paymentYear, 
       MIN(amount) AS minimumAmount
FROM payments
GROUP BY paymentYear;

-- Que.2
SELECT
    YEAR(orderDate) AS orderYear,
    CONCAT('Q', QUARTER(orderDate)) AS Quarter,
    COUNT(DISTINCT customerNumber) AS uniqueCustomers,
    COUNT(*) AS totalOrders
FROM
    orders
GROUP BY
    orderYear, Quarter
ORDER BY
    orderYear, Quarter;
    
-- Que 3.
SELECT
    DATE_FORMAT(paymentDate, '%b') AS Month,
    CONCAT(ROUND(SUM(amount) / 1000), 'K') AS FormattedAmount
FROM
    Payments
GROUP BY
    Month
HAVING
    SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY
    SUM(amount) DESC;


-- Assignment Day 6 --
--  Que. 1
CREATE TABLE journey (
    Bus_ID INT PRIMARY KEY,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE
);

-- Que. 2
CREATE TABLE vendor (
    Vendor_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Country VARCHAR(255) DEFAULT 'N/A'
);

-- Que. 3
CREATE TABLE movies (
    Movie_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows >= 0)
);

-- Que. 4
-- Create Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Create Product table
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create Stock table
CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


-- Assignment Day 7--
-- Que. 1
SELECT
    e.employeeNumber AS EmployeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS UniqueCustomers
FROM
    Employees e
LEFT JOIN
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    EmployeeNumber, SalesPerson
ORDER BY
    UniqueCustomers DESC;
    
-- Que. 2
SELECT
    c.customerNumber AS CustomerNumber,
    p.productCode AS ProductCode,
    SUM(od.quantityOrdered) AS TotalQuantitiesOrdered,
    p.quantityInStock AS TotalQuantitiesInStock,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS LeftoverQuantities
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
JOIN
    OrderDetails od ON o.orderNumber = od.orderNumber
JOIN
    Products p ON od.productCode = p.productCode
GROUP BY
    CustomerNumber, ProductCode
ORDER BY
    CustomerNumber;
    
-- Que. 3
-- -- Create the Laptop table
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(255)
);

-- Create the Colours table
CREATE TABLE Colours (
    Colour_Name VARCHAR(255)
);

-- Insert some sample data into the tables (you can add more data as desired)
INSERT INTO Laptop (Laptop_Name) VALUES
    ('Laptop A'),
    ('Laptop B'),
    ('Laptop C');

INSERT INTO Colours (Colour_Name) VALUES
    ('Red'),
    ('Blue'),
    ('Green');

-- Perform a cross join between the two tables
SELECT COUNT(*) AS NumberOfRows
FROM Laptop
CROSS JOIN Colours;

-- Que. 4
CREATE TABLE Project (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Gender VARCHAR(10),
    ManagerID INT
);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT
    e.FullName AS EmployeeName,
    COALESCE(m.FullName, 'N/A') AS ManagerName
FROM
    Project e
LEFT JOIN
    Project m ON e.ManagerID = m.EmployeeID;
    
    
-- Assignment Day 8 --
-- Create the "facility" table
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

-- Add a primary key constraint and make Facility_ID auto-increment
ALTER TABLE facility
ADD PRIMARY KEY (Facility_ID),
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;

-- Add a new column "City" after "Name" with NOT NULL constraint
ALTER TABLE facility
ADD COLUMN City VARCHAR(255) NOT NULL AFTER Name;



-- Day9
-- Create the University table
CREATE TABLE University (
    ID INT,
    Name VARCHAR(255)
);


INSERT INTO University (ID, Name)
VALUES
    (1, "       Pune          University     "),
    (2, "  Mumbai          University     "),
    (3, "     Delhi   University     "),
    (4, "Madras University"),
    (5, "Nagpur University");

UPDATE University
SET Name = TRIM(BOTH ' ' FROM Name);
select * from university;


-- Assignment Day 10 --
-- Create a view named "products_status"
Select *from orders;

CREATE VIEW products_status AS
SELECT
    YEAR(ord_date) AS year,
    COUNT(*) AS total_products_sold,
    SUM(ord_amount + advance_amount) AS total_value
FROM
    orders
GROUP BY
    YEAR(ord_date)
ORDER BY
    year;

SELECT
    year,
    total_products_sold,
    total_value,
    ROUND((total_value / (SELECT SUM(total_value) FROM products_status)) * 100, 2) AS percentage_of_total
FROM
    products_status;



-- Assignment Day 11 --
-- Que1 
DELIMITER //

CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT customerLevel VARCHAR(10))
BEGIN
    DECLARE creditLimit DECIMAL(10, 2);
    
    SELECT creditLimit INTO creditLimit
    FROM Customers
    WHERE customerNumber = customerNumber;
    
    IF creditLimit > 100000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF creditLimit >= 25000 AND creditLimit <= 100000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END //

DELIMITER ;


-- Que 2 
DELIMITER //

CREATE PROCEDURE Get_country_payments(IN yearInput INT, IN countryInput VARCHAR(50), OUT totalAmountFormatted VARCHAR(50))
BEGIN
    SELECT CONCAT(ROUND(SUM(p.amount) / 1000), 'K')
    INTO totalAmountFormatted
    FROM Payments p
    JOIN Customers c ON p.customerNumber = c.customerNumber
    WHERE YEAR(p.paymentDate) = yearInput
    AND c.country = countryInput;
END //

DELIMITER ;
CALL Get_country_payments(2003,'France', @formattedAmount);
SELECT @formattedAmount AS TotalAmountFormatted;


-- Assignment Day 12 --
-- Que. 1
WITH MonthlyOrderCounts AS (
    SELECT
        YEAR(OrderDate) AS OrderYear,
        DATE_FORMAT(OrderDate, '%M') AS OrderMonth,
        COUNT(*) AS OrderCount
    FROM
        Orders
    GROUP BY
        YEAR(OrderDate),
        DATE_FORMAT(OrderDate, '%M')
),
YoYPercentage AS (
    SELECT
        M1.OrderYear,
        M1.OrderMonth,
        M1.OrderCount AS CurrentYearCount,
        COALESCE(M2.OrderCount, 0) AS PreviousYearCount
    FROM
        MonthlyOrderCounts M1
    LEFT JOIN
        MonthlyOrderCounts M2
    ON
        M1.OrderYear = M2.OrderYear + 1
        AND M1.OrderMonth = M2.OrderMonth
)
SELECT
    OrderYear,
    OrderMonth,
    CurrentYearCount,
    CASE
        WHEN COALESCE(CurrentYearCount, 0) = 0 THEN 'N/A'
        ELSE CONCAT(CAST(((CurrentYearCount - PreviousYearCount) / NULLIF(PreviousYearCount, 0) * 100) AS SIGNED), '%')
    END AS YoYPercentageChange
FROM
    YoYPercentage
ORDER BY
    OrderYear,
    STR_TO_DATE(CONCAT('01-', OrderMonth, '-2000'), '%d-%M-%Y');


-- Que.2
-- Create the emp_udf table
-- Step 1: Create the Emp_UDF table
CREATE TABLE Emp_UDF (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    DOB DATE
);

-- Step 2: Insert data into the Emp_UDF table
INSERT INTO Emp_UDF(Name, DOB)
VALUES
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");

-- Step 3: Create the user-defined function calculate_age
DELIMITER //

CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);

    SET years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) - (years * 12);

    SET age = CONCAT(years, ' years ', months, ' months');

    RETURN age;
END;
//
DELIMITER ;

-- Step 4: Query to retrieve employee names and their ages
SELECT Name, calculate_age(DOB) AS Age FROM Emp_UDF;



-- Assignment Day 13
-- Que. 1
SELECT CustomerNumber, CustomerName
FROM Customers
WHERE CustomerNumber NOT IN (
    SELECT DISTINCT CustomerNumber
    FROM Orders
);


-- Que. 2
-- Full outer join customers and orders using UNION
SELECT c.CustomerNumber, c.CustomerName, COUNT(o.OrderNumber) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.CustomerNumber, c.CustomerName

UNION

SELECT c.CustomerNumber, c.CustomerName, COUNT(o.OrderNumber) AS OrderCount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.CustomerNumber, c.CustomerName;


-- Que. 3
SELECT OrderNumber, MAX(Quantity) AS SecondHighestQuantity
FROM (
    SELECT OrderNumber, Quantity, DENSE_RANK() OVER (PARTITION BY OrderNumber ORDER BY Quantity DESC) AS Rnk
    FROM Orderdetails
) AS RankedData
WHERE Rnk = 2
GROUP BY OrderNumber;


-- Que. 4
WITH OrderProductCounts AS (
    SELECT OrderNumber, COUNT(*) AS ProductCounts
    FROM Orderdetails
    GROUP BY OrderNumber
)
SELECT
    MAX(ProductCount) AS MaxProductCount,
    MIN(ProductCount) AS MinProductCount
FROM OrderProductCounts;

-- Que. 5
SELECT ProductLine, COUNT(*) AS Total
FROM Products
WHERE BuyPrice > (SELECT AVG(BuyPrice) FROM Products)
GROUP BY ProductLine;



-- Assignment Day 14--
-- Create the Emp_EH table

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);

-- Create a stored procedure with exception handling
DELIMITER //
CREATE PROCEDURE Insert_Emp_EH(IN empID_param INT, IN empName_param VARCHAR(255), IN email_param VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle the error and show the message
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error occurred';
    END;

    -- Insert the values into the Emp_EH table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress) VALUES (empID_param, empName_param, email_param);
    
    -- Show a success message
    SELECT 'Record inserted successfully' AS Message;
END;

-- Call the stored procedure with values
CALL Insert_Emp_EH(1, 'John Doe', 'john.doe@example.com');




-- Assignment Day 15 --
CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT
);

-- Insert data into the Emp_BIT table
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours)
VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);





