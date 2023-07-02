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


### Efficient Data Integration:
Data integration is the process of combining data from multiple sources to create a unified view of the data. The goal of efficient data integration is to minimize the time, cost, and complexity involved in integrating the data while ensuring the accuracy and completeness of the data.

Develop an automated script that retrieves the 12 files from the downing SFTP server every morning between 7am to 8am.
Use an ETL (extract, transform, load) process to transform and load the data from the daily files into the relevant tables in the database.
Use a version control system to track changes to the data and prevent duplication.

### Consolidated File Storage:

Create a separate table in the database to store the reconciled data from the monthly consolidated file.
Use a primary key to ensure data integrity and efficient querying.

### Preparing Data for Power BI Reporting:

Develop a process to extract the required data from the database and transform it into a specific table format for use in Power BI reports.
Use data visualisation tools to create reports that provide insights into asset performance and financial metrics.

### Business Requirement Changes:

Develop a change management process that ensures any changes to business requirements are thoroughly documented, reviewed, and tested before implementation.
Conduct regular reviews of the data management system to identify areas for improvement and make necessary adjustments.

### Integration of New Datasets:

Develop a process to integrate new datasets into the existing architecture, ensuring that the new data is compatible with the current database structure and reporting requirements.
Conduct thorough testing to ensure the new data does not negatively impact the performance or reliability of the existing system.
