/****** Object:  StoredProcedure [dbo].[p_gv_UpdateMenuItemsNonUS]    Script Date: 10/08/2012 11:23:30 ******/
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
 WHERE MenuItemID = @MenuItemID


