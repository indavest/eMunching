/****** Object:  StoredProcedure [dbo].[p_gv_OrdersDetails]    Script Date: 12/17/2012 10:53:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[p_gv_OrdersDetails] --'53B06704-5047-4D9A-9615-3D7BBB796787'
	@Oid nvarchar(50)
AS

create table #orderTemp (oId nvarchar(50), Item nvarchar(100), quantity int, SubItems nvarchar(max), ItemPriceA nchar(10), ItemPriceB nchar(10), GroupID int, CollectionID int)
create table #orderTemp2 (oId nvarchar(50), Item nvarchar(100), quantity int, SubItems nvarchar(max), ItemPriceA nchar(10), ItemPriceB nchar(10), GroupID int, CollectionID int)
INSERT INTO #orderTemp
SELECT [oId]
      ,[Item]
      ,[quantity]
      ,'None' as [SubItems]
      ,[ItemPriceA]
      ,[ItemPriceB]
      ,[GroupID]
      ,CollectionID
  FROM [dbo].[v_OrdersAll]
  where oId = @Oid AND Active=1
  ORDER BY createdTime desc
  
DECLARE @GroupID int
DECLARE @Item nvarchar(100)
WHILE EXISTS(SELECT * FROM #orderTemp)
BEGIN
	SET @GroupID = (SELECT TOP 1 GroupID FROM #orderTemp)
	SET @Item = (SELECT TOP 1 Item FROM #orderTemp)
	IF(@GroupID IS NULL)
	BEGIN
		INSERT INTO #orderTemp2
		SELECT TOP 1 * FROM #orderTemp
		DELETE FROM #orderTemp WHERE Item=@Item AND GroupID IS NULL
	END
	ELSE
	BEGIN
		DECLARE @SubItems VARCHAR(500)
		DECLARE @ItemPriceA nchar(10)
		DECLARE @CollectionID int
		SET @SubItems = NULL
		SET @CollectionID = (SELECT TOP 1 CollectionID FROM #orderTemp WHERE GroupID=@GroupID)
		SELECT @SubItems = COALESCE(@SubItems + ',  ','') + Item FROM #orderTemp WHERE GroupID=@GroupID AND CollectionID = @CollectionID
		SET @ItemPriceA = (SELECT SUM(CAST([ItemPriceA] AS MONEY)) FROM #orderTemp WHERE GroupID=@GroupID AND CollectionID = @CollectionID)
		INSERT INTO #orderTemp2
		SELECT TOP 1 [oId],(SELECT MenuItemGroup FROM MenuItemGroups WHERE MenuItemGroupID=@GroupID) AS [Item],[quantity],(SELECT @SubItems) as SubItems,@ItemPriceA,[ItemPriceB],[GroupID],[CollectionID] FROM #orderTemp
		DELETE FROM #orderTemp WHERE GroupID=@GroupID AND CollectionID = @CollectionID
	END
	
END
SELECT * FROM #orderTemp2