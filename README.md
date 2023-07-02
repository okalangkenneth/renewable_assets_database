# Development of an Automated Data Pipeline for Renewable Asset Management

## Table of Contents:
1. [Introduction](#introduction)
2. [Objective](#objective)
3. [Database Structure for Daily Data](#database-structure-for-daily-data)
4. [Minimising Data Loss](#minimising-data-loss)
5. [Efficient Data Integration](#efficient-data-integration)
6. [Consolidated File Storage](#consolidated-file-storage)
7. [Preparing Data for Power BI Reporting](#preparing-data-for-power-bi-reporting)
8. [Business Requirement Changes](#business-requirement-changes)
9. [Integration of New Datasets](#integration-of-new-datasets)


## Introduction:

In this project, we aim to develop an Automated Data Pipeline for Renewable Asset Management for a company that manages renewable energy assets. Our goal is to automate the collection, processing, and analysis of data from multiple sources, including trade files and cashflow files, to monitor asset performance and identify any issues. We will ensure data accuracy and consistency across all sources and formats and reconcile discrepancies between daily and monthly consolidated files.

The project aims to streamline data management and ensure that renewable assets reach their full potential, contributing to a cleaner and more sustainable future.

## Objective: 

The objective of this project is to design and implement an efficient data management system that integrates daily trade and cash flow data from six renewable assets into a centralized database, and prepares the data for use in Power BI reports.

## Database Structure for Daily Data:

The database is structured with a separate table for each of the Solar, Hydro, Wind, Biomass, and Geothermal assets to store the daily trade and cash flow data. Each table has columns for the relevant data points such as asset ID, date, transaction type, cash flow amount, and trade details.

Here is a diagram of the SQL server:

![image](https://user-images.githubusercontent.com/68539411/226671940-222c63f3-2c9b-4014-90ee-c7cc90ea5d88.png)

And here is a representation of the SQL file:

![image](https://user-images.githubusercontent.com/68539411/226672226-8f33d974-93bc-41d9-907f-6d4f1f0b7cd8.png)


## Minimising Data Loss:

### Regular Backups.
One of the most common ways to minimize data loss is by regularly backing up your database. In SQL Server, you can use the BACKUP DATABASE command to create a full backup of your database. Here's an example:

````
BACKUP DATABASE RenewableAssetsDB
TO DISK = 'D:\Backups\RenewableAssetsDB.bak';
````
This command creates a backup of the RenewableAssetsDB database and stores it in the specified location.

### Data Validation.
Data validation is another crucial aspect of minimizing data loss. This can be done at the database level using constraints. For example, you can use the NOT NULL constraint to ensure that a specific column in your table always has a value:

````
CREATE TABLE Solar (
    ID int NOT NULL,
    Date date NOT NULL,
    TransactionType varchar(255) NOT NULL,
    CashFlowAmount float NOT NULL,
    TradeDetails varchar(255)
);
````
In this example, the NOT NULL constraint is used to ensure that the ID, Date, TransactionType, and CashFlowAmount columns always have values. If a user tries to insert a record without a value for these columns, the database will return an error.

### Redundancy
Redundancy is another strategy for minimizing data loss. This involves storing copies of your data in multiple locations. In a SQL Server environment, you can achieve this using database mirroring or Always On availability groups.

Here's a simple diagram illustrating the concept of redundancy:

    +----------------+     +----------------+
    |                |     |                |
    |  Primary DB    |<--->|  Secondary DB  |
    |                |     |                |
    +----------------+     +----------------+


## Efficient Data Integration:
Efficient data integration involves combining data from multiple sources to create a unified view of the data. This process can be achieved using various methods, including ETL (Extract, Transform, Load) processes, data pipelines, and data warehousing.

### ETL Process.
ETL is a type of data integration that involves:

1. Extracting data from different source systems,
2. Transforming it to fit operational needs (which can include quality levels),
3. Loading it into the end target database or data warehouse.

   We use a combination of INSERT INTO, SELECT, and JOIN statements to extract, transform, and load data like this:
   
````   
-- Extract and Transform
CREATE VIEW transformed_data AS
SELECT 
    a.asset_id, 
    a.date, 
    a.transaction_type, 
    b.cash_flow_amount, 
    a.trade_details
FROM 
    daily_trade_data AS a
JOIN 
    daily_cash_flow_data AS b ON a.asset_id = b.asset_id AND a.date = b.date;

-- Load
INSERT INTO consolidated_data
SELECT * FROM transformed_data;
````
We first create a view that joins the daily_trade_data and daily_cash_flow_data tables on the asset_id and date columns. This view represents the transformed data. We then insert this transformed data into the consolidated_data table.

### Data Pipelines.
We create data pipelines using stored procedures. A stored procedure is a prepared SQL code that one can save and reuse like this:

````
-- Create a stored procedure
CREATE PROCEDURE update_consolidated_data AS
BEGIN
    -- Extract and Transform
    CREATE VIEW transformed_data AS
    SELECT 
        a.asset_id, 
        a.date, 
        a.transaction_type, 
        b.cash_flow_amount, 
        a.trade_details
    FROM 
        daily_trade_data AS a
    JOIN 
        daily_cash_flow_data AS b ON a.asset_id = b.asset_id AND a.date = b.date;

    -- Load
    INSERT INTO consolidated_data
    SELECT * FROM transformed_data;

    -- Clean up
    DROP VIEW transformed_data;
END;
````
In this example, we create a stored procedure that performs the ETL process. This stored procedure can be called as part of a data pipeline to update the consolidated_data table with the latest data.

### Data Warehousing
We create a data warehouse by creating a separate database and using INSERT INTO SELECT statements to load data from the source databases into the data warehouse. Here's an example:

````
-- Create a new database for the data warehouse
CREATE DATABASE RenewableAssetsDW;

-- Use the data warehouse database
USE RenewableAssetsDW;

-- Create a table for the consolidated data
CREATE TABLE consolidated_data (
    asset_id INT,
    date DATE,
    transaction_type VARCHAR(255),
    cash_flow_amount FLOAT,
    trade_details VARCHAR(255)
);

-- Load data from the source database into the data warehouse
INSERT INTO consolidated_data
SELECT * FROM RenewableAssetsDB.dbo.consolidated_data;
````
In this example, we first create a new database for the data warehouse. We then create a table for the consolidated data and load data from the source database into this table.


## Consolidated File Storage:

Create a separate table in the database to store the reconciled data from the monthly consolidated file.
Use a primary key to ensure data integrity and efficient querying.

### Preparing Data for Power BI Reporting:

Develop a process to extract the required data from the database and transform it into a specific table format for use in Power BI reports.
Use data visualisation tools to create reports that provide insights into asset performance and financial metrics.

## Business Requirement Changes:

Develop a change management process that ensures any changes to business requirements are thoroughly documented, reviewed, and tested before implementation.
Conduct regular reviews of the data management system to identify areas for improvement and make necessary adjustments.

## Integration of New Datasets:

Develop a process to integrate new datasets into the existing architecture, ensuring that the new data is compatible with the current database structure and reporting requirements.
Conduct thorough testing to ensure the new data does not negatively impact the performance or reliability of the existing system.
