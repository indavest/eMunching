USE [eMunchingLive]
GO
/****** Object:  StoredProcedure [dbo].[p_gv_InsertMenuItemUS]    Script Date: 10/08/2012 11:01:08 ******/
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
           ,[ChefSpecial])
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
           ,@ChefSpecial)
