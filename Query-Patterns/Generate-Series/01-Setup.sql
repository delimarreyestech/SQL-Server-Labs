
/*
===============================================================================
Lab 01: Finding Missing Values with GENERATE_SERIES()
File: 01-setup.sql

Purpose:
    Create and populate the sample dataset used in this lab.

Requirements:
    SQL Server 2022+
    Database compatibility level 160
===============================================================================
*/

-- Remove the sample table if it already exists.
DROP TABLE IF EXISTS dbo.Numbers;
GO

-- Create sample table.
CREATE TABLE dbo.Numbers
(
    Num INT NOT NULL PRIMARY KEY
);
GO

-- Insert sample data with intentional gaps.
INSERT INTO dbo.Numbers (Num)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (10);
GO

-- Verify the dataset.
SELECT Num
FROM dbo.Numbers
ORDER BY Num;
