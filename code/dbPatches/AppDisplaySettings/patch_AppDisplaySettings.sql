ALTER TABLE [dbo].[RestaurantEvents] ADD [Teaser] [nvarchar](max)
GO


/***** Changes to p_gv_CreateEvent*****/

/****** Object:  StoredProcedure [dbo].[p_gv_CreateEvent]    Script Date: 12/06/2012 13:51:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[p_gv_CreateEvent]
	@Restaurant int,
	@RestLoca int,
	@EventName nvarchar(150),
	@Desc nvarchar(max),
	@Date char(10),
	@time char(10),
	@Teaser nvarchar(max)
AS
INSERT INTO [RestaurantEvents]
           ([Restaurant]
           ,[Loca]
           ,[Name]
           ,[Description]
           ,[Date]
           ,[Time]
           ,[Teaser])
     VALUES
           (@Restaurant
           ,@RestLoca
           ,@EventName
           ,@Desc
           ,@Date
           ,@time
           ,@Teaser)
		   
		   
/******* Adding Teaser Coloumn in Deal Table *******/
ALTER TABLE [dbo].[Deals] ADD [Teaser] [nvarchar](max)
GO


/******* Changes to Create Deal procedure *******/


USE [eMunchingDev]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateDeal]    Script Date: 12/12/2012 11:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[p_CreateDeal]
	@RestID int,
	@title nvarchar(255),
	@desc nvarchar(max),
	@Stops varchar(15),
	@Starts varchar(15),
	@DealType int,
	@Teaser nvarchar(max)
AS
	INSERT INTO [Deals]
           ([Restaurant]
           ,[title]
           ,[description]
           ,[thumbnail]
           ,[image]
           ,[type]
           ,[value]
           ,[expiresOn]
           ,[startsFrom]
           ,[createdTime]
           ,[lastModified]
           ,[DealType]
           ,[Teaser])
     VALUES
           (@RestID
           ,@title
           ,@desc
           ,''
           ,''
           ,''
           ,0.00
           ,CAST(@stops as datetime)
           ,CAST(@starts as datetime)
           ,GETDATE()
           ,GETDATE()
           ,@DealType
           ,@Teaser)

/******* Changes to p_gv_GetDeals**********/


/****** Object:  StoredProcedure [dbo].[p_gv_GetDeals]    Script Date: 12/12/2012 12:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[p_gv_GetDeals]
	@RestID int
AS
SELECT [id]
      ,[title]
      ,[description]
      ,[thumbnail]
      ,[image]
      ,[type]
      ,[value]
      ,[expiresOn]
      ,[startsFrom]
      ,[active]
      ,CASE WHEN Active = 1 THEN 'Published'
			ELSE 'Publish'
		END AS Publish
	  ,mit.MenuType AS DealType
	  ,mit.MenuTypeId AS DealTypeId
	  ,[Teaser]
  FROM [Deals]
  JOIN MenuItemTypes mit on Deals.DealType = mit.MenuTypeId
  WHERE Restaurant = @RestID		 
  
/******* Changed to p_gv_UpdateDeals*******/


/****** Object:  StoredProcedure [dbo].[p_gv_UpdateDeals]    Script Date: 12/12/2012 12:16:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[p_gv_UpdateDeals]
	@RestID int,
	@id int,
	@Title nvarchar(200),
	@Description nvarchar(max),
	@StartsFrom nvarchar(15),
	@ExpiresOn nvarchar(15),
	@MenuType int,
	@Teaser nvarchar(max)
AS
UPDATE Deals SET title=@title, description=@Description, startsFrom=CAST(@StartsFrom as datetime), expiresOn=CAST(@ExpiresOn as datetime), DealType=@MenuType, Teaser=@Teaser WHERE id=@id AND Restaurant=@RestID 
