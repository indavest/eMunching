/****** Object:  StoredProcedure [dbo].[p_gv_UpdateRestaurantConfig]    Script Date: 10/08/2012 11:56:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[p_gv_UpdateRestaurantConfig] --3,'TMG Cafe','','','',254,'',1,1,1,0,0
	@RestID int,
	@Name varchar(50),
	@WebSite nvarchar(500),
	@FacebookUrl nvarchar(500),
	@TwitterHandle nvarchar(500),
	@MainEmailContact nvarchar(250),
	@Breakfast int,
	@Brunch int,
	@Lunch int,
	@Dinner int,
	@Supper int,
	@MorningTeaElevenses int,
	@AfternoonTea int
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


UPDATE [Restaurant]
   SET [name] = @Name
      ,[lastModified] = GETDATE()
      ,[WebSite] = @WebSite
      ,[FacebookUrl] = @FacebookUrl
      ,[TwitterHandle] = @TwitterHandle
      ,[MainEmailContact] = @MainEmailContact
 WHERE id = @RestID
 
 
 UPDATE Config SET MealTypesEnabled = @MealTypes WHERE Restaurant = @RestID