CREATE DATABASE ADVDB_HO1;

USE ADVDB_HO1;

/*START OF SALES SCRIPT*/
CREATE TABLE go_products (
    Product_number INT,
    Product_line VARCHAR(255),
    Product_type VARCHAR(255),
    Product VARCHAR(255),
    Product_brand VARCHAR(255),
    Product_color VARCHAR(255),
    Unit_cost DECIMAL(10,2),
    Unit_price DECIMAL(10,2),
    PRIMARY KEY (Product_number)
);

CREATE TABLE go_methods (
    Order_method_code INT,
    Order_method_type VARCHAR(255),
    PRIMARY KEY (order_method_code)
);

CREATE TABLE go_daily_sales (
    Retailer_code INT,
    Product_number INT,
    Order_method_code INT,
    Date DATE,
    Quantity INT,
    Unit_price DECIMAL(10,2),
    Unit_sale_price DECIMAL(10,2),
    PRIMARY KEY (Retailer_code, Product_number, Order_method_code, date),
    FOREIGN KEY (Product_number) REFERENCES go_products(Product_number),
    FOREIGN KEY (Order_method_code) REFERENCES go_methods(Order_method_code)
);

CREATE TABLE go_retailers (
    Retailer_code INT,
    Retailer_name VARCHAR(255),
    Type VARCHAR(255),
    Country VARCHAR(255),
    PRIMARY KEY (Retailer_code)
);

CREATE TABLE go_1k (
    Retailer_code INT,
    Product_number INT,
    Date DATE,
    Quantity INT,
    PRIMARY KEY (Retailer_code, Product_number, Date),
    FOREIGN KEY (Retailer_code) REFERENCES go_retailers(Retailer_code),
    FOREIGN KEY (Product_number) REFERENCES go_products(Product_number)
);
/*END OF SALES SCRIPT*/

/*START OF EMPLOYEES SCRIPT*/
CREATE TABLE employees (
    emp_no INT,
    birth_date DATE,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    gender ENUM('M','F'),
    hire_date DATE,
    PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
    emp_no INT,
    salary INT,
    from_date DATE,
    to_date DATE,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles (
    emp_no INT,
    title VARCHAR(255),
    from_date DATE,
    to_date DATE,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


CREATE TABLE departments (
    dept_no CHAR(4),
    dept_name VARCHAR(255),
    PRIMARY KEY (dept_no)
);

CREATE TABLE dept_emp (
    emp_no INT,
    dept_no CHAR(4),
    from_date DATE,
    to_date DATE,
    PRIMARY KEY (emp_no, dept_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
    dept_no CHAR(4),
    emp_no INT,
    from_date DATE,
    to_date DATE,
    PRIMARY KEY (dept_no, emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
/*END OF EMPLOYEES SCRIPT*/

/*START OF COMPLAINTS SCRIPT*/
CREATE TABLE complaints (
    Complaint_ID INT,
    Product VARCHAR(255),
    Sub_product VARCHAR(255),
    Issue VARCHAR(255),
    Sub_issue VARCHAR(255),
    State VARCHAR(255),
    ZIP_code DECIMAL(6,1),
    Date_received DATE,
    Date_sent_to_company DATE,
    Company VARCHAR(255),
    Company_response VARCHAR(255),
    Timely_response CHAR(3),
    Consumer_disputed CHAR(3),
    PRIMARY KEY (Complaint_ID)
);
/*END OF COMPLAINTS SCRIPT*/

/*START OF SUPPLIERS SCRIPT*/
CREATE TABLE Supplies_orders (
    id VARCHAR(255) NOT NULL,
    saleDate VARCHAR(255),
    storeLocation VARCHAR(255),
    customer_email VARCHAR(255),
    customer_gender CHAR(1),
    customer_age INT,
    customer_satisfaction INT,
    couponUsed BOOLEAN,
    purchaseMethod VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE Supplies_order_items (
    supplies_order_items_key VARCHAR(255),
    orderid VARCHAR(255),
    name VARCHAR(255),
    price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (orderid) REFERENCES Supplies_orders(id)
);

CREATE TABLE Supplies_order_item_tags (
    supplies_order_item_tag_key INT NOT NULL AUTO_INCREMENT,
    supplies_order_items_key VARCHAR(255),
    tagname VARCHAR(255),
    PRIMARY KEY (supplies_order_item_tag_key)
);
/*END OF SUPPLIERS SCRIPT*/



