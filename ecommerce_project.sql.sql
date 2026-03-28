-- DATEBASE SETUP

DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- TABLE CREATION

-- CATEGORY TABLE
CREATE TABLE Category (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description   VARCHAR(255)
);

-- CUSTOMER TABLE
CREATE TABLE Customer (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(15),
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ADDRESS TABLE
CREATE TABLE Address (
    address_id    INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    street        VARCHAR(150) NOT NULL,
    city          VARCHAR(80)  NOT NULL,
    state         VARCHAR(80)  NOT NULL,
    pincode       VARCHAR(10)  NOT NULL,
    is_default    BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- PRODUCT TABLE
CREATE TABLE Product (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    category_id   INT NOT NULL,
    product_name  VARCHAR(150) NOT NULL,
    description   TEXT,
    price         DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_qty     INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- ORDERS TABLE
CREATE TABLE Orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    address_id    INT NOT NULL,
    order_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('Pending','Confirmed','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    total_amount  DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id ),
    FOREIGN KEY (address_id)  REFERENCES Address(address_id)
);

-- ORDER_ITEM TABLE
CREATE TABLE Order_Item (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    payment_id     INT PRIMARY KEY AUTO_INCREMENT,
    order_id       INT NOT NULL UNIQUE,
    payment_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount         DECIMAL(10, 2) NOT NULL,
    method         ENUM('Credit Card','Debit Card','UPI','Net Banking','COD') NOT NULL,
    status         ENUM('Pending','Success','Failed','Refunded') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- REVIEW TABLE
CREATE TABLE Review (
    review_id     INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    product_id    INT NOT NULL,
    rating        INT CHECK (rating BETWEEN 1 AND 5),
    comment       TEXT,
    review_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Product(product_id)
);

-- DATA INSERTION

-- CATEGORY
INSERT INTO Category (category_name, description) values ('Electronics', 'gadgets and electronic devices'),
('clothing','Men and Women fashion'),
('Books','Academic and fiction books'),
('Home & Kitechen','Home applications and Kitchen tools'),
('sports','Sports and fitness equipment');

-- CUSTOMER
INSERT INTO Customer (first_name, last_name, email, phone) values 
('Ravi','Kumar','ravi.kumar@gmail.com', '9876543210'),
('Priya','Sharma','priya.sharma@gmail.com','9823456789'),
('Arjun','Mehta','arjun.mehta@gmail.com','9712345678'),
('Sneha','Reddy','sneha.reddy@gmail.com','9545678901'),
('Kiran','Das','kiran.das@gmail.com','9545678901');

-- ADDRESS
INSERT INTO Address (customer_id, street, city, state,pincode, is_default) values
(1,'12 MG Road','Bangalore','Karnataka','560001',True),
(2,'45 Park street','Kolkata','West Bengal','700016',true),
(3,'78 Linking Road','Mumbai','Maharashtra','400050',true),
(4,'23 Anna Nagar', 'Chennai','Tamil Nadu','600040',true),
(5,'9 Connaught Place','New Delhi','Delhi','110001',true);

-- PRODUCT
INSERT INTO Product (category_id,product_name, price, stock_qty) VALUES 
(1,'Samsung Galaxy M34', 18999.00,50),
(1,'boAt Airdopes 141', 1499.00, 120),
(1,'HP Laptop 15s',52000.00,20),
(2,'Levi''s 511 Jeans',2999.00,80),
(2,'Niko Dri-FIT T-Shirt', 1299.00,150),
(3,'DBMS by Navathe', 799.00,60),
(3,'Clean Code by R. Marthin',699.00,45),
(4,'Presting Pressure Cooker', 1799.00,35),
(4,'Philips Air Fryer', 6499.00,25),
(5,'Cosco Football', 899.00,70);

-- ORDERS
INSERT INTO Orders (customer_id, address_id, status, total_amount) values 
(1,1,'Delivered',20498.00),
(2,2,'Shipped', 2999.00),
(3,3, 'Confirmed',53499.00),
(4,4,'Pending',1598.00),
(5,5, 'Cancelled', 6499.00),
(1,1, 'Delivered', 1799.00),
(2,2, 'Pending', 899.00);

-- ORDER_IREM
INSERT INTO Order_Item (order_id, product_id, quantity, unit_price) VALUES 
(1,1,1, 18999.00),
(1,2,1, 1499.00),
(2,4,1, 2999.00),
(3,3,1, 52000.00),
(3,6,1, 799.00),
(4,5,1, 1299.00),
(4,7,1, 699.00),
(5,9,1, 6499.00),
(6,8,1, 1799.00),
(7,10,1, 899.00);

-- PAYMENT
INSERT INTO Payment (order_id, amount, method, status) values 
(1,20498.00,'UPI','Success'),
(2,2999.00,'credit Card','Success'),
(3,53499.00,'Net Banking','Pending'),
(4,1598.00,'COD','Pending'),
(5,6499.00,'Debit Card','Refunded'),
(6,1799.00,'UPI','Success');

-- REVIEW
INSERT INTO Review (customer_id, product_id, rating, comment) values 
(1,1,5, 'Excellent phonel Great battery life.'),
(1,2,4, 'Good sound quality for the peice.'),
(2,4,5, 'Perfect fir and great quaility!'),
(3,3,4, 'Fast laptop, good for college use.'),
(3,6,5, 'Must read for every CS student!'),
(4,5,3, 'Decent t-shirt, color faded after wash.');


-- INDEXS 

-- Speed up customer lookups by email
CREATE INDEX idx_customer_email ON customer(email);

-- Speed up order queries by customer
CREATE INDEX idx_order_customer ON orders(customer_id);

-- Speed up order item queries by order
CREATE INDEX idx_orderitem_order ON order_item(order_id);

-- Speed up product search by category
CREATE INDEX idx_product_category ON product(category_id);

-- Speed up payment lookup by order
CREATE INDEX idx_payment_order ON payment(order_id);


-- VIEWS 

-- View 1: Full Order Summary

CREATE VIEW vw_order_summary AS 
SELECT o.order_id, 
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
c.email,
o.order_date,
o.total_amount,
p.method AS payment_medhod,
p.status AS payment_status 
from orders o join customer c ON o.customer_id = c.customer_id 
left join payment p ON o.order_id = p.order_id;
select * from vw_order_summary;

-- View 2: Product Stock Status
CREATE VIEW vw_stoke_status AS 
SELECT 
p.product_id,
p.product_name,
c.category_id,
p.price,
p.stock_qty ,
CASE 
when p.stock_qty = 0 then 'Out of stoke'
when p.stock_qty < 20 then 'Low stoke'
else 'In stoke' end as stock_status 
from product p join category c ON p.category_id = c.category_id;

select * from vw_stock_status

rename table vw_stoke_status to vw_stock_status;

-- View 3: Customer Purchase History

CREATE VIEW vw_customer_history AS 
select c.customer_id,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
COUNT(distinct o.order_id) AS total_orders,
SUM(o.total_amount) AS total_amount,
MAX(o.order_date) AS last_order_date FROM 
customer c left join orders o ON c.customer_id = o.customer_id
GROUP BY  customer_id,customer_name;
select * from vw_customer_history;


-- TRIGGERS 

-- Trigger 1: Reduce stock when an order item is inserted

DELIMITER $$
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON Order_Item
FOR EACH ROW
BEGIN
    UPDATE Product
    SET    stock_qty = stock_qty - NEW.quantity
    WHERE  product_id = NEW.product_id;
END$$
DELIMITER ;

-- Trigger 2: Restore stock when an order is cancelled

DELIMITER $$
CREATE TRIGGER trg_restore_stack_on_cancel
AFTER UPDATE on orders 
FOR EACH ROW 
BEGIN 
IF new.status = 'Cancelled' AND old.status != 'Cancelled' THEN
UPDATE product p 
join order_item oi SET p.stack_qty = p.stack_qty + oi.quantity 
where  oi.order_id = new.order_id;
end if;
END$$
DELIMITER ;

-- Trigger 3: Update order total when order item is added
DELIMITER $$
CREATE TRIGGER trg_update_order_total 
AFTER UPDATE ON order_item 
FOR EACH ROW 
begin 
UPDATE orders  
SET total_amount = (select sum(quantity * unit_price) from order_item 
where order_id = new.order_id) 
where order_id = new.order_id;
END$$
DELIMITER ;

-- STORED PROCEDURES

-- Procedure 1: Place a New Order
DELIMITER $$
CREATE PROCEDURE sp_place_order (
IN p_customer_id INT ,
IN p_address_id INT ,
OUT p_order_id INT )
begin
INSERT INTO Orders (customer_id,address_id,status) VALUES 
(p_customer_id,p_address_id,'pending') ;
SET p_order_id = LAST_INSERT_ID();
end$$
DELIMITER ;
CALL sp_place_order(1, 5, @new_order_id);
SELECT @new_order_id;

-- Procedure 2: Get All Orders for a Customer
DELIMITER $$ 
CREATE PROCEDURE sp_get_customer_orders (
IN p_customer_id INT )
begin select o.order_id,
o.order_date,
o.status,
o.total_amount 
from orders o 
where o.customer_id = p_customer_id;
END$$ 
DELIMITER ;

call sp_get_customer_orders(1);

-- Procedure 3: Get Top N Products by Revenue
DELIMITER $$ 
CREATE PROCEDURE sp_top_products (
IN P_limit INT)
begin 
SELECT 
p.product_name,
sum(oi.quantity) as total_units_solid,
sum(oi.quantity * oi.unit_price) AS revenue
from order_item oi 
join product p where oi.product_id = p.product_id 
group by product_name
order by revenue DESC
LIMIT p_limit;
END$$ 
DELIMITER ;
drop procedure if exists sp_top_products;
call sp_top_products(4);



--  SQL QUERIES

-- Q1: List all customers with their total number of orders
SELECT 
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
COUNT(o.order_id) AS total_orders
from customer c left join orders o ON
c.customer_id = o.customer_id 
GROUP BY customer_name
order by total_orders DESC;

-- Q2: Find all orders with customer name, product details and order status
SELECT 
o.order_id,
CONCAT(c.first_name,' ',c.last_name) AS Customer,
p.product_name,
oi.quantity,
oi.unit_price,
o.status 
from customer c join orders o ON c.customer_id = o.customer_id 
join order_item oi ON o.order_id = oi.order_id 
join product p ON oi.product_id = p.product_id; 


-- Q3: Total revenue generated per category
SELECT c.category_name,
SUM(oi.quantity * oi.unit_price) AS Revenue
FROM 
category c join product p ON c.category_id = p.category_id 
JOIN order_item oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id
where o.status != 'Cancelled'
group by category_name
order by Revenue desc;

-- Q4: Top 3 best-selling products (by quantity sold)
SELECT 
p.product_name ,
SUM(oi.quantity) AS total_sold 
from product p join order_item oi 
group by product_name 
order by total_sold 
limit 3;


-- Q5: Customers who have NOT placed any order (using LEFT JOIN)
SELECT 
CONCAT(c.first_name,' ',c.last_name) AS customer,
c.email,
o.order_id
from customer c LEFT JOIN orders o ON c.customer_id = o.customer_id 
where o.order_id IS NULL;

-- Q6: Orders where payment failed or is still pending
SELECT 
o.order_id,
CONCAT(c.first_name,' ',c.last_name) AS customer,
o.total_amount,
p.method,
p.status AS payment_status 
FROM orders o JOIN customer c ON o.customer_id = c.customer_id 
JOIN payment p ON  o.order_id = p.order_id 
where p.status IN ('pending','failed');

-- Q7: Average rating of each product (only products with reviews)
SELECT 
p.product_id,
p.product_name,
round(avg(r.rating),2) AS AVG_Rating,
Count(r.review_id) AS review_count 
FROM product p join review r ON p.product_id = r.product_id 
group by p.product_id
having review_count > 0
order by AVG_Rating DESC;

-- Q8: Monthly revenue report
SELECT 
year(o.order_date) AS year,
month(o.order_date) AS month,
SUM(o.total_amount) AS monthly_revenue,
count(o.order_id) AS total_orders 
from orders o
group by year,month 
order by year,month;

-- Q9: Find products with stock below 30 (Low stock alert)
SELECT 
p.product_id,
p.product_name,
c.category_id,
p.stock_qty 
from product p join category c 
ON p.category_id = c.category_id 
where p.stock_qty < 30 
order by p.stock_qty ASC;

-- Q10: Customers who spent more than the average customer spend (Subquery)
SELECT 
c.customer_id,
CONCAT(c.first_name,' ',c.last_name) AS customer,
SUM(o.total_amount) AS total_spent 
from customer c join orders o ON c.customer_id = o.order_id 
group by c.customer_id
having total_spent > (
select 
AVG(total_per_customer) 
from (
select SUM(total_amount) AS total_per_customer
from orders
group by c.customer_id
) AS sub
) 
order by total_spent DESC;


-- Q11: Full order details using the view
select * from vw_order_summary
order by order_date DESC;


-- Q12: Products never ordered (using NOT EXISTS)
SELECT p.product_name,
p.price,
p.stock_qty 
from product p 
where NOT EXISTS (
select * from order_item oi 
where p.product_id = oi.product_id);

-- Q13: Customer who gave the most reviews
SELECT 
c.customer_id,
CONCAT(c.first_name,' ',last_name) AS customer,
COUNT(r.review_id) AS total_reviews 
from customer c join review r ON c.customer_id = r.customer_id 
group by customer_id
order by total_reviews DESC 
limit 1;

-- Q14: Orders with more than 1 item (multi-item orders)
SELECT 
o.order_id,
CONCAT(c.first_name,' ',c.last_name) AS customer,
COUNT(oi.order_item_id) AS total_orders,
o.total_amount 
from orders o 
join customer c ON o.customer_id = c.customer_id 
join order_item oi ON o.order_id = oi.order_id
group by o.order_id 
having total_orders > 1
order by total_orders DESC;

-- Q15: Rank customers by total spending using Window Function
SELECT 
c.customer_id,
CONCAT(c.first_name,' ',c.last_name) AS customer,
RANK() OVER (order by sum(o.total_amount) DESC) AS spending_rank 
from customer c join orders o 
on c.customer_id = o.customer_id 
group by c.customer_id;


-- TRANSACTION EXAMPLE
START transaction; 
insert INTO orders (customer_id,address_id,status,total_amount) values 
(3,3,'Confirmed',1400.00);

insert into order_item(order_id,product_id,quantity,unit_price) values
(last_insert_id(),2,1,1499.00);

insert into payment(order_id,amount,method,status) values 
(last_insert_id(),1499.00,'UPI','Success');

commit;



