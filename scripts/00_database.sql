/*
==============================================================================
Project      : Olist E-Commerce Sales Analysis
Author       : Kareem Shaltout
Database     : OlistECommerceDB
SQL Server   : Microsoft SQL Server 2022

Description:
    This script creates the Olist E-Commerce database,
    creates all tables, imports CSV files,
    and applies all constraints.

Instructions:
    1. Download the Olist Dataset.
    2. Put all CSV files inside one folder.
    3. Change the paths in the BULK INSERT section.
    4. Execute the script.

WARNING:
    Running this script will DROP the database if it already exists.
==============================================================================*/

USE master;
GO

IF DB_ID('OlistECommerceDB') IS NOT NULL
BEGIN
    ALTER DATABASE OlistECommerceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OlistECommerceDB;
END
GO

CREATE DATABASE OlistECommerceDB;
GO

USE OlistECommerceDB;
GO

/*===========================================================================
    CREATE TABLES
===========================================================================*/

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);
GO

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);
GO

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght FLOAT,
    product_description_lenght FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);
GO

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
GO

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
GO

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);
GO

CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title NVARCHAR(MAX),
    review_comment_message NVARCHAR(MAX),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
GO

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
GO

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);
GO

/*===========================================================================
    LOAD DATA
===========================================================================*/

/**************** Customers ****************/

BULK INSERT customers
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_customers_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Sellers ****************/

BULK INSERT sellers
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_sellers_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Orders ****************/

BULK INSERT orders
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_orders_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Products ****************/

BULK INSERT products
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_products_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Payments ****************/

BULK INSERT payments
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_order_payments_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Reviews ****************/

BULK INSERT reviews
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_order_reviews_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Order Items ****************/

BULK INSERT order_items
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_order_items_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/**************** Geolocation ****************/

BULK INSERT geolocation
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\olist_geolocation_dataset.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/************** Category Translation **************/

BULK INSERT category_translation
FROM 'C:\Users\Karee\Desktop\project Portfolio\dataset\product_category_name_translation.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO