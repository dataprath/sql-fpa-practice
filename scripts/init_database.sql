/*
=========================================
Create Database and Schemas
=========================================
Script Purpose:
    The script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    withinbg the database: 'bronze', 'silver' and 'gold'
Warning:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All Data in the database will be permanently deleted. Procees with caution
    and ensure you have proper backups before running the script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database if it exists.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

