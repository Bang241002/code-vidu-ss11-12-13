--chương 11
--vidu1
CREATE TABLE Production.parts(
	part_id int NOT NULL,
	part_name VARCHAR(100))
GO

--vidu2
CReATE CLUSTERED INDEX ix_parts_id ON Production.parts (part_id);
Go

--vidu3
EXEC sp_rename
		N'production.parts.ix_parts_id',
		N'index_part_id',
N'INDEX';
GO

--vidu4
ALTER INDEX INDEX_PART_ID
ON Production.Parts
DISABLE;
Go

--vidu5
ALTER INDEX ALL ON Production.Parts
DISABLE;
Go

--vidu6
DROP INDEX IF EXISTS
INDEX_PART_ID ON Production.Parts;
GO

--vidu7
CREATE NONCLUSTERED INDEX INDEX_CUSTOMER_STOREID
ON Sales.Customer(StoreID);
Go

--vidu8
CREATE UNIQUE INDEX AK_Customer_rowguid
ON Sales.Customer(rowguide);
GO

--vidu9
CREATE INDEX index_cust_presonID
ON Sales.Customer(PersonID)
WHERE PersonID IS NOT NULL;
GO

--vidu10
select customerID, PersonID, StoreID from Sales.Customer WHERE PersonId=1700;
GO

--vidu11
CREATE PARTITION FUNCTION partition_function (int)
RANGE LEFT FOR VALUES (20200630, 20200731, 20200831);
Go

--vidu12
(SELECT 2020613 date, $PARTITION.partition_function(20200613)
PartitionNumber)
UNION
(SELECT 2020713 date, $PARTITION.partition_function(20200713)
PartitionNumber)
UNION
(SELECT 2020813 date, $PARTITION.partition_function(20200813)
PartitionNumber)
UNION
(SELECT 2020913 date, $PARTITION.partition_function(20200913));
Go

--vidu13
CREATE PRIMARY XML INDEX PXML_ProductModel_CatalogDescription
ON Production.ProductModel (CatalogDescription);
Go

--vidu14
CREATE  XML INDEX IXML_ProductModel_CatalogEscription_path
ON Production.productModel (CatalogDescription)
USING XML INDEX PXML_ProductModel_CatalogDesCription
FOR PATH;
Go

--vidu15
CREATE COLUMNSTORE INDEX IX_SalesORderDetail_ProductIDorderQty_ColumnStore
ON Sales.SalesOrderDetail (ProductID, OrderQty);
GO

--vidu16
select productID, SUM (OrderQty)
from Sales.SalesOrderdetail
GROUP BY ProductID;
Go

--chương 12
--vidu1
CREATE TABLE locations (LocationID int, LocName varchar(100))
Create TABLE LocationHistory (LocationID int, ModifiedDate DATETIME );
Go

--vidu2
CREATE TRIGGER TRIGGER_INSERT_Locations ON Locations
FOR INSERT 
NOT FOR REPLICATION
AS
BEGIN 
INSERT INTO LocationHistory
SELECT LocationID
,getdate ()
From inserted
END;
Go

--vidu3
INSERT INTO dbo.locations (LocationID,LocName) VALUES (443101,'Alaska');
GO

--vidu4
CREATE TRIGGER TRIGGER_UPDATE_Locations ON Locations
FOR UPDATE 
NOT FOR REPLICATION 
AS
BEGIN 
INSERT INTO LocationHistory
SELECT locationID 
,getdate ()
FROM inserted
END;
GO

--vidu5
UPDATE dbo.locations
SET LocName='Atlanta'
where LocationID=443101;
Go

--vidu6
CREATE TRIGGER TRIGGER_DELETE_Locations ON Locations
FOR DELETE
NOT FOR REPLICATION 
AS
BEGIN
INSERT INTO LocationHistory
SELECT locationID
,getdate()
FROM deleted
END;
GO

--vidu7
DELETE FROM dbo.locations
where LocationID=443101;
Go

--vidu8
CREATE TRIGGER AFTER_INSERT_Locations ON Locations
AFTER INSERT AS
BEGIN
INSERT INTO LocationHistory
select LocationID
,getdate()
FROM inserted
END;
Go

--vidu9
INSERT INTO dbo.locations (LocationID,LocName) VALUES (443101, 'SAN ROMAN');
Go

--vidu10
CREATE TRIGGER INSTEADOF_DELETE_Location ON Locations
Instead OF DELETE AS
BEGIN 
SELECT 'sample Instead of trigger' as [message]
END;
Go

--vidu11
DELETE FROM dbo.locations
WHERE LocationID=443101;
Go

--vidu12
EXEC sp_settriggerorder @triggername = 'TRIGGER_DELETE_Locations ', @order = 'FIRST', @stmttype ='DELETE'
Go

--vidu13
sp_helptext TRIGGER_DELETE_locations
GO

--vidu14
ALTER TRIGGER TRIGGER_UPDATE_Locations ON Locations
With ENCRYPTION FOR INSERT AS
IF '443101' IN (SELECT LocationID FROM inserted)
BEGIN 
PRINT 'Location cannot be updated'
ROLLBACK TRANSACTION 
END;
Go

--vidu15
CREATE TRIGGER Secure ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE AS
PRINT 'you must disable trigger "secure" to drop or alter tables!'
ROLLBACK;
Go

--vidu16
CREATE TRIGGER Secure ON DATEBASE 
FOR DROP_TABLE, Alter_table AS
PRINT 'You must disable trigger "secure" to drop or alter tables!'
ROLLBACK;
Go

--vidu17
CREATE TRIGGER Employee_Deletion ON HumanResources.Employee
AFTER DELETE AS
BEGIN
PRINT 'Deletion will affect EmployeePayHistory table'
DELECTE FROM EmployeePayHistory WHERE businessENtityID In (SELECT 
BusinessEntityID FROM deleted)
END;
GO

--vidu18
CREATE TRIGGER Deletion_Confirmation
ON HumanResources.EmployeePayhistory AFter DELETE AS
BEGIN 
PRINT 'Employee details successfully deleted from EmployeePayHistory table'
END;
DELETE FROM EmployeePayHistory WHERE EmpID=1
Go

--vidu19
CREATE TRIGGER Accounting ON Production.transactionHistory AFTER UPDATE AS
IF (UPDATE (Transaction) OR UPDATE (ProductID)) BEGIN 
RAISERROR (5009, 16, 10 ) END;
Go

--vidu20
USE AdventureWorks2019;
GO
CREATE TRIGGER PODetails
ON Purchasing.PurchaseOrderDetail AFTER INSERT AS
UPDATE PurchaseOrderHeader
SET SubTotal = SubTotal + LineTotal FROM inserted
WHERE PurchaseOrderHeader.PurchaseOrderID = inserted.PurchaseOrderID;
Go

--vidu21
USE AdventureWorks2019;
GO
CREATE TRIGGER PODetailsMultiple
ON Purchasing.PurchaseOrderDetail AFTER INSERT AS
UPDATE Purchasing.PurchaseOrderHeader SET SubTotal = SubTotal +
(SELECT SUM(LineTotal) FROM inserted
WHERE PurchaseOrderHeader.PurchaseOrderID
= inserted.PurchaseOrderID)
WHERE PurchaseOrderHeader.PurchaseOrderID IN (SELECT PurchaseOrderID FROM inserted);
GO

--chương 13
--vidu1
USE AdventureWorks2019;
GO
CREATE VIEW dbo.vProduct
AS
SELECT ProductNumber, Name FROM Production.Product; GO
SELECT * FROM dbo.vProduct;
GO

--vidu2
BEGIN TRANSACTION 
Go
USE AdventureWorks2019;
Go
CREATE TABLE company (
Id_Num int IDENTITY(100, 5),
Company_Name nvarchar(100))
Go
INSERT company (Company_Name) VALUES (N'A Bike Store')
INSERT company (Company_Name) VALUES (N'progressive sports')
INSERT company (Company_Name) VALUES (N'modular cycle systems')
INSERT company (Company_Name) VALUES (N'asvenced bike components')
INSERT company (Company_Name) VALUES (N'metroplitan sports supply')
INSERT company (Company_Name) VALUES (N'aerobic exercise company')
INSERT company (Company_Name) VALUES (N'associated bikes')
INSERT company (Company_Name) VALUES (N'exemplary cycles')
GO
SELECT ID_Num, company_Name FROM dbo.company
ORDER BY Company_Name ASC;
Go

--vidu3
USE AdventureWorks2019;
GO
DECLARE @find varchar(30) = 'Man%';
SELECT p.LastName, p.FirstName, ph.PhoneNumber FROM Person.Person AS p JOIN
Person.PersonPhone AS ph ON p.BusinessEntityID = ph.BusinessEntityID 
WHERE LastName LIKE @find;
GO

--vidu4
DECLARE @myvar char(20);
SET @myvar = 'This is a test';
Go

--vidu5
USE AdventureWorks2019;
GO
DECLARE @varl nvarchar(30);
SELECT Gvarl = 'Unnamed Company';
SELECT @varl = Name FROM Sales.Store WHERE BusinessEntityID = 10;
SELECT Gvarl AS 'Company Name';
Go

--vidu6
USE AdventureWorks2019;
GO
CREATE SYNONYM MyAddressType
FOR AdventureWorks2019.Person.AddressType; 
GO

--vidu7
USE AdventureWorks2019;
GO
BEGIN TRANSACTION;
GO
IF @@TRANCOUNT = 0 BEGIN 
SELECT FirstName, MiddleName
FROM Person.Person WHERE LastName = 'Andy';
ROLLBACK TRANSACTION;
PRINT N'Rollin back the transaction two times wouid cause an error ';
END ;
ROLLBACK TRANSACTION;
PRINT N'Rolled back the transaction';
GO

--vidu9
DECLARE @flag int SET (@flag = 10 WHILE (@flag <=95) BEGIN
IF @flag%2 =0 PRINT @flag
SET @flag = @flag + 1 
CONTINUE; END
GO

--vidu11
SELECT * FROM Sales.ufn_CustDates();
Go

--vidu12
USE AdventureWorks2019;
GO
ALTER FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS (datetime) AS BEGIN
RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112)); END;
GO

--vidu13
USE AdventureWorks2019;
GO
SELECT SalesOrderID, ProductID, OrderQty
,SUM(OrderQty) OVER(PARTITION BY SalesOrderlD) AS Total
,MAX(OrderQty) OVER(PARTITION BY SalesOrderlD) AS MaxOrderQty FROM
Sales.SalesOrderDetail
WHERE ProductId IN(776, 773);
GO

--vidu14
SELECT CustomerID, StoreID,
RANK() OVER (ORDER BY StoreID DESC) AS Rnk_All, RANK() OVER (PARTITION BY
PersonID
ORDER BY CustomerID DESC) AS Rnk_Cust 
FROM Sales.Customer;
Go

--vidu15
SELECT TerritoryID, Name, SalesYTD, RANK() OVER(ORDER BY SalesYTD DESC) AS
Rnk_One, RANK() OVER(PARTITION BY TerritoryID
ORDER BY SalesYTD DESC) AS Rnk_Two
FROM Sales.SalesTerritory;
GO

--vidu16
SELECT ProductID, Shelf, Quantity,
SUM(Quantity) OVER(PARTITION BY ProductID ORDER BY LocationlD
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunQty
FROM Production.ProductInventory;
Go

--vidu17
USE AdventureWorks2019;
GO
SELECT p.FirstName, p.LastName
,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS 'Row Number'
,NTILE(4) OVER (ORDER BY a.PostalCode) AS 'NTILE'
,s.SalesYTD, a.PostalCode FROM Sales.Salesperson AS s INNER JOIN Person.Person AS p
ON s.BusinessEntityID = p.BusinessEntityID INNER JOIN Person.Address AS a ON a.AddressID =
p.BusinessEntityID
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;
Go

--vidu19
(SELECT DATETIMEOFFSETFROMPARTS (2010, 12, 31, 14, 23, 23, 0, 12, 0, 7)
AS Result;
GO

--vidu20
SELECT SYSDATETIME() AS SYSDATETIME 
,SYSDATETIMEOFFSET() AS SYSDATETIMEOFFSET
,SYSUTCDATETIME () AS SYSUTCDATETIME
Go

--vidu21
USE AdventureWorks2019;
GO
SELECT BusinessEntityID, YEAR(QuotaDate) AS QuotaYear, SalesQuota AS NewQuota,
LEAD(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS FutureQuota FROM
Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('20111','12014');
GO

--vidu22
USE AdventureWorks2019;
GO
SELECT Name, ListPrice,
FIRST_VALUE(Name) OVER (ORDER BY ListPrice ASC) AS LessExpensive FROM
Production.Product
WHERE ProductSubcategoryID = 37
Go

