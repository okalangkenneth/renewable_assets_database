# Development of an Automated Data Pipeline for Renewable Asset Management

## Table of Contents:

## Introduction:
Renewable energy is on the rise, creating a need for effective asset management. An Automated Data Pipeline (ADP) automates data collection, processing, and analysis from various sources. An ADP can save time, increase accuracy, provide real-time insights, and optimize asset lifespan. The development of an ADP is crucial in the renewable energy industry for ensuring assets reach their full potential in the transition towards a cleaner, sustainable future.

The project involves the development of an Automated Data Pipeline for Renewable Asset Management  a company that manages renewable energy assets. The pipeline will automate the collection, processing, and analysis of data from multiple sources, including trade files and cashflow files for each of the five assets, which are sent to the companys SFTP server every morning. The data is used to monitor the performance of the assets and identify any issues.

A specific table format is required for Power BI reports. The development of an Automated Data Pipeline is necessary to handle the high volume and frequency of data received each day and to reconcile discrepancies between the daily and monthly consolidated files. The project aims to ensure that the data is accurate and consistent across all sources and formats and to streamline the data management process.


## Objective: 

To design and implement an efficient data management system that integrates daily trade and cash flow data from six renewable assets into a centralised database, and prepares the data for use in Power BI reports.

## Database Structure for Daily Data:

Creating a database with a separate table for each of the Solar,Hydro,Wind,Biomass and Geothermal assets to store the daily trade and cash flow data.

![image](https://user-images.githubusercontent.com/68539411/226671940-222c63f3-2c9b-4014-90ee-c7cc90ea5d88.png)

Each table has columns for the relevant data points such as asset ID, date, transaction type, cash flow amount, and trade details.

![image](https://user-images.githubusercontent.com/68539411/226672226-8f33d974-93bc-41d9-907f-6d4f1f0b7cd8.png)


### Minimising Data Loss:

Implement a data backup strategy, such as regular backups to a secondary storage location or cloud-based storage, to minimise the risk of data loss.
Ensure data validation checks are in place to identify and resolve any data discrepancies or errors.

### Efficient Data Integration:

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
