-- Question 1: Achieving 1NF (First Normal Form)

-- Create the initial ProductDetail table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Insert data into the ProductDetail table
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Transform the ProductDetail table into 1NF by splitting the Products column into individual rows
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert transformed data into the ProductDetail_1NF table
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Select the transformed table
SELECT * FROM ProductDetail_1NF;

-- Question 2: Achieving 2NF (Second Normal Form)

-- Create the initial OrderDetails table in 1NF
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT
);

-- Insert data into the OrderDetails table
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Transform the OrderDetails table into 2NF by removing partial dependencies
-- Create a Customer table to hold customer-related information
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert distinct customer data from OrderDetails
INSERT INTO Customer (CustomerName)
SELECT DISTINCT CustomerName FROM OrderDetails;

-- Create an Orders table to hold order-related information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Insert distinct order data into the Orders table
INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT OrderID, (SELECT CustomerID FROM Customer WHERE Customer.CustomerName = OrderDetails.CustomerName)
FROM OrderDetails;

-- Create a ProductOrder table to hold product-related information for each order
CREATE TABLE ProductOrder (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the ProductOrder table
INSERT INTO ProductOrder (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

-- Select data from normalized tables
SELECT * FROM Customer;
SELECT * FROM Orders;
SELECT * FROM ProductOrder;