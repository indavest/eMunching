ALTER TABLE [dbo].[MenuItemGroups] ADD [Parent] [int]
GO


/***** Changes to p_gv_GetCategories *********/

/****** Object:  StoredProcedure [dbo].[p_gv_GetCategories]    Script Date: 12/17/2012 15:17:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[p_gv_GetCategories]
	@RestID int
AS
SELECT [MenuItemGroupID]
      ,[Restaurant]
      ,[MenuItemGroup]
      ,ISNULL([MenuItemGroupDesc],' ') as MenuItemGroupDesc
      ,ISNULL([MenuItemGroupImage], 'tacos.png') as MenuItemGroupImage
      ,[Order]
      ,[Parent]
  FROM [MenuItemGroups]
WHERE Restaurant=@RestID


/******* Changes to Update p_gv_UpdateCategory *******/

/****** Object:  StoredProcedure [dbo].[p_gv_UpdateCategory]    Script Date: 12/17/2012 16:26:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[p_gv_UpdateCategory]
	@MenuItemGroupID int,
	@RestID int,
	@MenuItemGroup nvarchar(50),
	@MenuItemGroupDesc nvarchar(500),
	@MenuItemGroupImage nvarchar(500),
	@Order int,
	@Parent int
AS
UPDATE [dbo].[MenuItemGroups]
   SET [Restaurant] = @RestID
	  ,[MenuItemGroup] = @MenuItemGroup
      ,[MenuItemGroupDesc] = @MenuItemGroupDesc
      ,[MenuItemGroupImage] = @MenuItemGroupImage
      ,[Order] = @Order
      ,[Parent] = @Parent
 WHERE MenuItemGroupID = @MenuItemGroupID
 
 
 /****** New Table MenuItemPriceRange ******/
 
 /****** Object:  Table [dbo].[MenuItemPriceRange]    Script Date: 12/19/2012 10:36:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MenuItemPriceRange](
	[PriceRange] [nvarchar](100) NOT NULL,
	[MenuItemGroup] [int] NOT NULL
) ON [PRIMARY]

GO

INSERT INTO [dbo].[MenuItemPriceRange] ([PriceRange],[MenuItemGroup]) VALUES('1000 - 5000',469),('5000 - 10000',469),('10000 - 15000',469),('15000 - 20000',469),('20000 - 50000',469),('50000 - 100000',469),('100 - 5000',470),('5000 - 10000',470),('10000 - 20000',470),('10000 - 20000',471),('50000 - 100000',471)
GO


/***** Search MenuItems Procedure *****/


/****** Object:  StoredProcedure [dbo].[p_Svc_SearchRestaurantMenuItemsByPriceRange]    Script Date: 12/19/2012 10:43:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
<RestaurantID>string</RestaurantID>
<MealType>string</MealType>					-	Values: Breakfast,Brunch,Morning Tea (Elevenses),Lunch,Dinner,Afternoon Tea,Supper = 1,2,3,4,5,6,7
<DealType>string</DealType>					-   Values: All, ChefSpecials, FeaturedDeals = 0,1,2
<MenuItemType>string</MenuItemType>			-	Values: All, Veg, NonVeg = 0,1,2
<MenuItemCategory>string</MenuItemCategory> -	Values: All, Starters, Main Course, Sides, Deserts, Appetizers, Specials, Beverages
*/


CREATE proc [dbo].[p_Svc_SearchRestaurantMenuItemsByPriceRange] --36,0,2,0,0
	@rid int,
	@MealType int = 0,
	@DealType int = 0,
	@MenuType int = 0,
	@Category int = 0,
	@LowerLimit nvarchar(20),
	@UpperLimit nvarchar(20)
as

DECLARE @SQL nvarchar(4000)
DECLARE @DT nvarchar(500)
DECLARE @MT nvarchar(500)
DECLARE @CT nvarchar(500)
DECLARE @ML nvarchar(500)

IF @MealType = 0
	BEGIN
		SET @ML = ' and (MealType LIKE ''%1%'' or MealType LIKE ''%2%'' or MealType LIKE ''%3%'' or MealType LIKE ''%4%'' or MealType LIKE ''%5%'' or MealType LIKE ''%6%'' or MealType LIKE ''%7%'')'
	END

IF @MealType <> 0
	BEGIN
		SET @ML = ' and MealType LIKE ''%' + CAST(@MealType as nvarchar(50)) + '%'''
	END

IF @DealType = 2
	BEGIN
		SET @DT = ' and DiscountPrice NOT IN (''0.00'',''0'')'
	END

IF @DealType = 1
	BEGIN
		SET @DT = ' and ChefSpecial=1 '
	END
	
IF @DealType = 0
	BEGIN
		SET @DT = ' and ChefSpecial IN (1,0) '
	END

IF @MenuType = 1
	BEGIN
		SET @MT = ' and Veg=1 '
	END

IF @MenuType = 0 
	BEGIN
		SET @MT = ' and Veg=0 '
	END
	
IF @MenuType = 0
	BEGIN
		SET @MT = ' and Veg IS NOT NULL '
	END
	
IF @Category <> 0
	BEGIN
		SET @CT = ' and MenuGroup = ' + CAST(@Category as nvarchar(25)) + ' '
	END
	
IF @Category = 0
	BEGIN
		SET @CT = ' and MenuGroup IS NOT NULL '
	END		
			
SET @SQL = 'SELECT [MenuItemID],[baseUrl] + [ItemImage1] as [ItemImage1],[baseUrl] + [ItemImage2] as [ItemImage2],[baseUrl] + [ItemImage3] as [ItemImage3],[Item],[ItemDesc],[ItemPriceA] as ItemPrice,[ComboPrice],[DiscountPrice],[MenuType]
			FROM [dbo].[MenuItems] m
			JOIN [dbo].[Restaurant] r ON m.Restaurant=r.ID
			WHERE Active=1 AND m.ItemPriceA BETWEEN '+ @LowerLimit +' AND '+ @UpperLimit +' AND Restaurant = ' + cast(@rid as CHAR(3)) + @ML + @DT + @MT + @CT + ';'
			

PRINT @SQL


EXEC(@SQL)









GO