/****** Object:  Table [dbo].[MenuItemTypes]    Script Date: 11/26/2012 16:08:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MenuItemTypes](
	[MenuTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MenuType] [nvarchar](200) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_MenuItemTypes] PRIMARY KEY CLUSTERED 
(
	[MenuTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MenuItemTypes] ADD  CONSTRAINT [DF_MenuItemTypes_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO

INSERT INTO MenuItemTypes (MenuType, CreatedTime, LastModified) VALUES ('Regular', GETDATE(), GETDATE()),('Sold Out', GETDATE(), GETDATE()), ('Special Edition', GETDATE(), GETDATE())
GO
/*** Adding Menu Type in Menu Items Table ***/
ALTER TABLE [dbo].[MenuItems] ADD [MenuType] [int] NOT NULL DEFAULT ((1))
GO

ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD FOREIGN KEY([MenuType])
REFERENCES [dbo].[MenuItemTypes] ([MenuTypeId])
GO

ALTER TABLE [dbo].[MenuItems] ADD [Active] [int] NOT NULL DEFAULT ((1))
GO
/***** Changes to p_gv_SelectRestaurantMenuItemsNonUS ****/

/****** Object:  StoredProcedure [dbo].[p_gv_SelectRestaurantMenuItemsNonUS]    Script Date: 11/26/2012 17:07:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[p_gv_SelectRestaurantMenuItemsNonUS] --36
	@RestaurantID int
AS

-- Grab the appropriate currency code
DECLARE @CoCode nvarchar(10)
DECLARE @CurrCode nvarchar(10)

SET @CoCode = (SELECT PrimaryCountry FROM Restaurant WHERE ID = @RestaurantID)
SET @CurrCode = (SELECT [symbol] FROM [CurrencyCodes] JOIN Country ON code = CurrencyCode WHERE countryid = @CoCode)

SELECT [MenuItemID]
      ,m.[Restaurant]
      --,m.[LocaID]
      ,[MenuGroup]
      ,[MenuItemGroup]
      ,[MenuItemGroupDesc]
      --,[MealType]
      ,dbo.Concatenate(e.Name) as MealTypes
      ,MAX(CASE e.MealID WHEN 1 Then '1' ELSE '0' END) AS Breakfast
      ,MAX(CASE e.MealID WHEN 3 Then '1' ELSE '0' END) AS MorningTeaElevenses
      ,MAX(CASE e.MealID WHEN 2 Then '1' ELSE '0' END) AS Brunch
      ,MAX(CASE e.MealID WHEN 4 Then '1' ELSE '0' END) AS Lunch
      ,MAX(CASE e.MealID WHEN 5 Then '1' ELSE '0' END) AS Dinner
      ,MAX(CASE e.MealID WHEN 6 Then '1' ELSE '0' END) AS AfternoonTea
      ,MAX(CASE e.MealID WHEN 7 Then '1' ELSE '0' END) AS Supper
      ,ISNULL([ItemImage1],'Placeholder-MenuItem.Sm.120x83.png') as ItemImage1
      ,ISNULL([ItemImage2],'Placeholder-MenuItem.Lg.320x183.png') as ItemImage2
      ,ISNULL([ItemImage3],'Placeholder-Thumbnail.35x35.png') as ItemImage3
      ,[Item]
      ,[ItemDesc]
      ,@CurrCode + [ItemPriceA] as ItemPriceA
      ,[ItemPriceB]
      ,CASE WHEN ItemPriceB <> '0' THEN @CurrCode + [ItemPriceA] + '/' + @CurrCode + [ItemPriceB]
			ELSE @CurrCode + [ItemPriceA] END as FmItemPrice
      ,[ComboPrice]
      ,@CurrCode + ComboPrice as FmComboPrice
      ,[DiscountPrice]
      ,@CurrCode + DiscountPrice as FmDiscountPrice
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,ISNULL([Veg],'0') as Veg
      ,ISNULL([ChefSpecial],'0') as ChefSpecial
      ,mit.MenuType as MenuType
      ,mit.MenuTypeId as MenuTypeId
      ,CASE WHEN m.Active = 1 THEN 'UnPublish'
			ELSE 'Publish'
		END AS Publish
	  ,m.Active
  FROM [MenuItems] m
  JOIN [Restaurant] r ON Restaurant = ID
  --JOIN [RestaurantLocation] rl ON m.LocaID = rl.LocaID
  JOIN [MenuItemGroups] mg ON m.MenuGroup = mg.MenuItemGroupID and m.Restaurant = mg.Restaurant
  JOIN [MenuMealTypes] e ON e.MealID IN (SELECT value FROM dbo.ft_Split(m.MealType,','))
  JOIN [MenuItemTypes] mit ON mit.MenuTypeId = m.MenuType
  WHERE m.Restaurant = @RestaurantID
  GROUP BY [MenuItemID]
      ,m.[Restaurant]
      --,m.[LocaID]
      ,[MenuGroup]
      ,[MenuItemGroup]
      ,[MenuItemGroupDesc]
      --,[MealType]
      ,[ItemImage1]
      ,[ItemImage2]
      ,[ItemImage3]
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ItemPriceB]
      ,[ComboPrice]
      ,[DiscountPrice]
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[Veg]
      ,[ChefSpecial]
      ,mit.[MenuType]
      ,mit.[MenuTypeId]
      ,[Active]
	  
	  
	  
/****** Changes to p_gv_InsertMenuItemNonUS ****/

/****** Object:  StoredProcedure [dbo].[p_gv_InsertMenuItemNonUS]    Script Date: 11/26/2012 16:11:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[p_gv_InsertMenuItemNonUS]
	   @RestID int
	  ,@Breakfast int
	  ,@Brunch int
	  ,@Lunch int
	  ,@Supper int
	  ,@Dinner int
	  ,@MorningTeaElevenses int
	  ,@AfternoonTea int
	  ,@MenuGroup int
      ,@ItemImage1 nvarchar(50)
      ,@ItemImage2 nvarchar(50)
      ,@ItemImage3 nvarchar(50)
      ,@Item nvarchar(255)
      ,@ItemDesc nvarchar(500)
      ,@ItemPriceA nchar(10)
      ,@DiscountPrice nchar(10)
      ,@Veg int
      ,@ChefSpecial int
      ,@MenuType int
AS

Declare @MealTypes varchar(50)
Set @MealTypes = ''

If @Breakfast = 1
	Begin
		Set @MealTypes = @MealTypes + '1,'
	End
	
If @Brunch = 1 
	Begin
		Set @MealTypes = @MealTypes + '2,'
	End
	
If @Lunch = 1
	Begin
		Set @MealTypes = @MealTypes + '4,'
	End
	
If @Supper = 1
	Begin
		Set @MealTypes = @MealTypes + '7,'
	End
	
If @Dinner = 1
	Begin
		Set @MealTypes = @MealTypes + '5,'
	End
	
If @MorningTeaElevenses = 1
	Begin
		Set @MealTypes = @MealTypes + '3,'
	End
	
If @AfternoonTea = 1
	Begin
		Set @MealTypes = @MealTypes + '6'
	End
	
IF @MealTypes = ''
	Begin
		Set @MealTypes = (Select MealTypesEnabled from Config where Restaurant = @RestID)
	End
	
IF @MenuGroup = 0 
	Begin
		Set @MenuGroup = (Select Top 1 MenuItemGroupID from MenuItemGroups where Restaurant = @RestID)
	End	

	
	INSERT INTO [MenuItems]
           ([Restaurant]
           ,[LocaID]
           ,[MenuGroup]
           ,[GroupCategory]
           ,[MealType]
           ,[ItemImage1]
           ,[ItemImage2]
           ,[ItemImage3]
           ,[Item]
           ,[ItemDesc]
           ,[ItemPriceA]
           ,[ItemPriceB]
           ,[ComboPrice]
           ,[DiscountPrice]
           ,[PriceSchedule]
           ,[Archive]
           ,[ChildsPlate]
           ,[Veg]
           ,[ChefSpecial]
           ,[MenuType])
     VALUES
           (@RestID
           ,0
           ,@MenuGroup
           ,0
           ,@MealTypes
           ,@ItemImage1
           ,@ItemImage2
           ,@ItemImage3
           ,dbo.ReplaceSpecChars(@Item,'0-9 a-z')
           ,dbo.ReplaceSpecChars(@ItemDesc,'0-9 a-z')
           ,@ItemPriceA
           ,0.00
           ,0.00
           ,@DiscountPrice
           ,1
           ,0
           ,0
           ,@Veg
           ,@ChefSpecial
           ,@MenuType)	  
		   

/***** Changes to p_gv_UpdateMenuItemsNonUS ****/

/****** Object:  StoredProcedure [dbo].[p_gv_UpdateMenuItemsNonUS]    Script Date: 11/26/2012 16:12:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[p_gv_UpdateMenuItemsNonUS] --10048,0,0,1,1,0,33,'','','','','','',0
	   @MenuItemID int
	  ,@Breakfast int
	  ,@Brunch int
	  ,@Lunch int
	  ,@Supper int
	  ,@Dinner int
	  ,@MenuGroup int
      ,@ItemImage1 nvarchar(50)
      ,@ItemImage2 nvarchar(50)
      ,@ItemImage3 nvarchar(50)
      ,@Item nvarchar(255)
      ,@ItemDesc nvarchar(500)
      ,@ItemPriceA nchar(10)
      ,@DiscountPrice nchar(10)
      ,@Veg int
      ,@ChefSpecial int
      ,@MorningTeaElevenses int
	  ,@AfternoonTea int
      ,@MenuTypeId int
as

Declare @MealTypes varchar(50)
Declare @DealVal int
Set @MealTypes = ''

If @Breakfast = 1
	Begin
		Set @MealTypes = @MealTypes + '1,'
	End
	
If @Brunch = 1 
	Begin
		Set @MealTypes = @MealTypes + '2,'
	End
	
If @Lunch = 1
	Begin
		Set @MealTypes = @MealTypes + '4,'
	End
	
If @Supper = 1
	Begin
		Set @MealTypes = @MealTypes + '7,'
	End
	
If @Dinner = 1
	Begin
		Set @MealTypes = @MealTypes + '5,'
	End

If @MorningTeaElevenses = 1
	Begin
		Set @MealTypes = @MealTypes + '3,'
	End

If @AfternoonTea = 1
	Begin
		Set @MealTypes = @MealTypes + '6'
	End
		
If @DiscountPrice IN ('$0.00','0.00')
	BEGIN
		Set @DealVal = 0
	End
Else
	BEGIN
		Set @DealVal = 1
	END
	
--Select @MealTypes

UPDATE [dbo].[MenuItems]
   SET MenuGroup = @MenuGroup
	  ,MealType = @MealTypes
      ,ItemImage1 = @ItemImage1
      ,ItemImage2 = @ItemImage2
      ,ItemImage3 = @ItemImage3
      ,Item = dbo.ReplaceSpecChars(@Item,'0-9 a-z')
      ,ItemDesc = dbo.ReplaceSpecChars(@ItemDesc,'0-9 a-z')
      ,ItemPriceA = @ItemPriceA
      ,DiscountPrice = @DiscountPrice
      ,Veg = @Veg
      ,ChefSpecial = @ChefSpecial
      ,FeaturedDeal = @DealVal
      ,MenuType = @MenuTypeId
 WHERE MenuItemID = @MenuItemID
 
 /****** Changes to p_gv_SelectRestaurantMenuItemsUS *****/
 
 
 /****** Object:  StoredProcedure [dbo].[p_gv_SelectRestaurantMenuItemsUS]    Script Date: 11/26/2012 17:24:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[p_gv_SelectRestaurantMenuItemsUS] --5
	@RestaurantID int
AS
SELECT [MenuItemID]
      ,m.[Restaurant]
      --,m.[LocaID]
      ,[MenuGroup]
      ,[MenuItemGroup]
      ,[MenuItemGroupDesc]
      --,[MealType]
      ,dbo.Concatenate(e.Name) as MealTypes
      ,MAX(CASE e.MealID WHEN 1 Then '1' ELSE '0' END) AS Breakfast
      ,MAX(CASE e.MealID WHEN 3 Then '1' ELSE '0' END) AS MorningTeaElevenses
      ,MAX(CASE e.MealID WHEN 2 Then '1' ELSE '0' END) AS Brunch
      ,MAX(CASE e.MealID WHEN 4 Then '1' ELSE '0' END) AS Lunch
      ,MAX(CASE e.MealID WHEN 5 Then '1' ELSE '0' END) AS Dinner
      ,MAX(CASE e.MealID WHEN 6 Then '1' ELSE '0' END) AS AfternoonTea
      ,MAX(CASE e.MealID WHEN 7 Then '1' ELSE '0' END) AS Supper
      ,ISNULL([ItemImage1],'Placeholder-MenuItem.Sm.120x83.png') as ItemImage1
      ,ISNULL([ItemImage2],'Placeholder-MenuItem.Lg.320x183.png') as ItemImage2
      ,ISNULL([ItemImage3],'Placeholder-Thumbnail.35x35.png') as ItemImage3
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ItemPriceB]
      ,CASE WHEN ItemPriceB <> '0' THEN dbo.fs_FormatCurrency(ItemPriceA,2,1) + '/' + dbo.fs_FormatCurrency(ItemPriceB,2,1)
			ELSE dbo.fs_FormatCurrency(ItemPriceA,2,1) END as FmItemPrice
      ,[ComboPrice]
      ,dbo.fs_FormatCurrency(ComboPrice,2,1) as FmComboPrice
      ,[DiscountPrice]
      ,dbo.fs_FormatCurrency(DiscountPrice,2,1) as FmDiscountPrice
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[ChefSpecial]
      ,mit.MenuType as MenuType
      ,mit.MenuTypeId as MenuTypeId
      ,CASE WHEN m.Active = 1 THEN 'UnPublish'
			ELSE 'Publish'
		END AS Publish
	  ,m.Active
  FROM [MenuItems] m
  JOIN [Restaurant] r ON Restaurant = ID
  --JOIN [RestaurantLocation] rl ON m.LocaID = rl.LocaID
  JOIN [MenuItemGroups] mg ON m.MenuGroup = mg.MenuItemGroupID and m.Restaurant = mg.Restaurant
  JOIN [MenuMealTypes] e ON e.MealID IN (SELECT value FROM dbo.ft_Split(m.MealType,','))
  JOIN [MenuItemTypes] mit ON mit.MenuTypeId = m.MenuType
  WHERE m.Restaurant = @RestaurantID
  GROUP BY [MenuItemID]
      ,m.[Restaurant]
      --,m.[LocaID]
      ,[MenuGroup]
      ,[MenuItemGroup]
      ,[MenuItemGroupDesc]
      --,[MealType]
      ,[ItemImage1]
      ,[ItemImage2]
      ,[ItemImage3]
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ItemPriceB]
      ,[ComboPrice]
      ,[DiscountPrice]
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[Veg]
      ,[ChefSpecial]
      ,mit.[MenuType]
      ,mit.[MenuTypeId]
      ,[Active]

/***** Changes to p_gv_UpdateMenuItemsUS ******/

/****** Object:  StoredProcedure [dbo].[p_gv_UpdateMenuItemsUS]    Script Date: 11/26/2012 17:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[p_gv_UpdateMenuItemsUS] --10048,0,0,1,1,0,33,'','','','','','',0
	   @MenuItemID int
	  ,@Breakfast int
	  ,@Brunch int
	  ,@Lunch int
	  ,@Supper int
	  ,@Dinner int
	  ,@MenuGroup int
      ,@ItemImage1 nvarchar(50)
      ,@ItemImage2 nvarchar(50)
      ,@ItemImage3 nvarchar(50)
      ,@Item nvarchar(255)
      ,@ItemDesc nvarchar(500)
      ,@ItemPriceA nchar(10)
      ,@DiscountPrice nchar(10)
      ,@ChefSpecial int
      ,@MenuTypeId int
as

Declare @MealTypes varchar(50)
Declare @DealVal int
Set @MealTypes = ''

If @Breakfast = 1
	Begin
		Set @MealTypes = @MealTypes + '1,'
	End
	
If @Brunch = 1 
	Begin
		Set @MealTypes = @MealTypes + '2,'
	End
	
If @Lunch = 1
	Begin
		Set @MealTypes = @MealTypes + '4,'
	End
	
If @Supper = 1
	Begin
		Set @MealTypes = @MealTypes + '7,'
	End
	
If @Dinner = 1
	Begin
		Set @MealTypes = @MealTypes + '5'
	End
	
If @DiscountPrice IN ('$0.00','0.00')
	BEGIN
		Set @DealVal = 0
	End
Else
	BEGIN
		Set @DealVal = 1
	END
	
--Select @MealTypes

UPDATE [dbo].[MenuItems]
   SET MenuGroup = @MenuGroup
	  ,MealType = @MealTypes
      ,ItemImage1 = @ItemImage1
      ,ItemImage2 = @ItemImage2
      ,ItemImage3 = @ItemImage3
      ,Item = @Item
      ,ItemDesc = @ItemDesc
      ,ItemPriceA = @ItemPriceA
      ,DiscountPrice = @DiscountPrice
      ,ChefSpecial = @ChefSpecial
      ,FeaturedDeal = @DealVal
      ,MenuType = @MenuTypeId
 WHERE MenuItemID = @MenuItemID

 
/***** Changes to p_gv_InsertMenuItemUS *****/


/****** Object:  StoredProcedure [dbo].[p_gv_InsertMenuItemUS]    Script Date: 11/26/2012 17:26:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[p_gv_InsertMenuItemUS]
	   @RestID int
	  ,@Breakfast int
	  ,@Brunch int
	  ,@Lunch int
	  ,@Supper int
	  ,@Dinner int
	  ,@MorningTeaElevenses int
	  ,@AfternoonTea int
	  ,@MenuGroup int
      ,@ItemImage1 nvarchar(50)
      ,@ItemImage2 nvarchar(50)
      ,@ItemImage3 nvarchar(50)
      ,@Item nvarchar(255)
      ,@ItemDesc nvarchar(500)
      ,@ItemPriceA nchar(10)
      ,@DiscountPrice nchar(10)
      ,@ChefSpecial int
      ,@MenuType int
AS

Declare @MealTypes varchar(50)
Set @MealTypes = ''

If @Breakfast = 1
	Begin
		Set @MealTypes = @MealTypes + '1,'
	End
	
If @Brunch = 1 
	Begin
		Set @MealTypes = @MealTypes + '2,'
	End
	
If @Lunch = 1
	Begin
		Set @MealTypes = @MealTypes + '4,'
	End
	
If @Supper = 1
	Begin
		Set @MealTypes = @MealTypes + '7,'
	End
	
If @Dinner = 1
	Begin
		Set @MealTypes = @MealTypes + '5,'
	End
	
If @MorningTeaElevenses = 1
	Begin
		Set @MealTypes = @MealTypes + '3,'
	End
	
If @AfternoonTea = 1
	Begin
		Set @MealTypes = @MealTypes + '6'
	End
	
IF @MealTypes = ''
	Begin
		Set @MealTypes = (Select MealTypesEnabled from Config where Restaurant = @RestID)
	End
	
IF @MenuGroup = 0 
	Begin
		Set @MenuGroup = (Select Top 1 MenuItemGroupID from MenuItemGroups where Restaurant = @RestID)
	End	
	
	INSERT INTO [MenuItems]
           ([Restaurant]
           ,[LocaID]
           ,[MenuGroup]
           ,[GroupCategory]
           ,[MealType]
           ,[ItemImage1]
           ,[ItemImage2]
           ,[ItemImage3]
           ,[Item]
           ,[ItemDesc]
           ,[ItemPriceA]
           ,[ItemPriceB]
           ,[ComboPrice]
           ,[DiscountPrice]
           ,[PriceSchedule]
           ,[Archive]
           ,[ChildsPlate]
           ,[Veg]
           ,[ChefSpecial]
           ,[MenuType])
     VALUES
           (@RestID
           ,0
           ,@MenuGroup
           ,0
           ,@MealTypes
           ,@ItemImage1
           ,@ItemImage2
           ,@ItemImage3
           ,@Item
           ,@ItemDesc
           ,@ItemPriceA
           ,0.00
           ,0.00
           ,@DiscountPrice
           ,1
           ,0
           ,0
           ,0
           ,@ChefSpecial
           ,@MenuType) 
		   
		   
/****** Changes to v_Svc_RestaurantMenus*****/

/****** Object:  View [dbo].[v_Svc_RestaurantMenus]    Script Date: 11/26/2012 17:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Svc_RestaurantMenus]'))
DROP VIEW [dbo].[v_Svc_RestaurantMenus]
GO


CREATE View [dbo].[v_Svc_RestaurantMenus]
AS
SELECT [MenuItemID]
	  ,r.ID	AS RestaurantID
	  ,r.name	AS RestaurantName
      ,g.[MenuItemGroup]
      ,MAX(CASE e.MealID WHEN 1 Then 'Y' ELSE 'N' END) AS Breakfast
      ,MAX(CASE e.MealID WHEN 3 Then 'Y' ELSE 'N' END) AS MorningTeaElevenses
      ,MAX(CASE e.MealID WHEN 2 Then 'Y' ELSE 'N' END) AS Brunch
      ,MAX(CASE e.MealID WHEN 4 Then 'Y' ELSE 'N' END) AS Lunch
      ,MAX(CASE e.MealID WHEN 5 Then 'Y' ELSE 'N' END) AS Dinner
      ,MAX(CASE e.MealID WHEN 6 Then 'Y' ELSE 'N' END) AS AfternoonTea
      ,MAX(CASE e.MealID WHEN 7 Then 'Y' ELSE 'N' END) AS Supper
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ComboPrice]
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[Veg]
      ,ChefSpecial
      ,MenuType
  FROM [dbo].[MenuItems] m
  JOIN Restaurant r ON m.Restaurant = r.id
  JOIN MenuItemGroups g ON m.MenuGroup = g.MenuItemGroupID
  JOIN MenuMealTypes e ON e.MealID IN (SELECT value FROM dbo.ft_Split(m.MealType,',')) AND m.Active=1
  GROUP BY 
	   [MenuItemID]
	  ,r.ID
	  ,r.name
      ,g.[MenuItemGroup]
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ComboPrice]
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[Veg]
      ,ChefSpecial
      ,MenuType



GO

/****** Changed to p_Svc_GetRestaurantMenuItems******/

/****** Object:  StoredProcedure [dbo].[p_Svc_GetRestaurantMenuItems]    Script Date: 11/26/2012 17:41:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[p_Svc_GetRestaurantMenuItems]
	@rid int
AS
SELECT [MenuItemID]
      ,[RestaurantID]
      ,[RestaurantName]
      ,[MenuItemGroup]
      ,[Breakfast]
      ,[MorningTeaElevenses]
      ,[Brunch]
      ,[Lunch]
      ,[Dinner]
      ,[AfternoonTea]
      ,[Supper]
      ,[Item]
      ,[ItemDesc]
      ,[ItemPriceA]
      ,[ComboPrice]
      ,[PriceSchedule]
      ,[Archive]
      ,[ChildsPlate]
      ,[Veg]
      ,[ChefSpecial]
      ,[MenuType]
  FROM [dbo].[v_Svc_RestaurantMenus]
  WHERE RestaurantID = @rid



/****** Changes to p_Svc_GetRestaurantMenuItemsAll******/

/****** Object:  StoredProcedure [dbo].[p_Svc_GetRestaurantMenuItemsAll]    Script Date: 11/26/2012 17:46:56 ******/
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


ALTER proc [dbo].[p_Svc_GetRestaurantMenuItemsAll] --36,0,2,0,0
	@rid int,
	@MealType int = 0,
	@DealType int = 0,
	@MenuType int = 0,
	@Category int = 0
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
			WHERE Active=1 AND Restaurant = ' + cast(@rid as CHAR(3)) + @ML + @DT + @MT + @CT + ';'
			

PRINT @SQL


EXEC(@SQL)