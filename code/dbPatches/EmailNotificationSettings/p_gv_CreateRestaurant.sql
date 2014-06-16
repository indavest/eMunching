/****** Object:  StoredProcedure [dbo].[p_gv_CreateRestaurant]    Script Date: 10/03/2012 10:15:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[p_gv_CreateRestaurant]
	@Name varchar(50),
	@Website nvarchar(500),
	@FacebookUrl nvarchar(500),
	@TwitterHandle nvarchar(500),
	@PrimaryCountry int,
	@MainEmailContact nvarchar(250),
	@Breakfast int,
	@Brunch int,
	@Lunch int,
	@Dinner int,
	@Supper int,
	@Roles nvarchar(500)
AS

DECLARE @bURL nvarchar(500)
DECLARE @cURL nvarchar(500)

SET @bURL = 'http://www.eMunching.com/Restaurants/'+@Name+'/ArtWork/MenuItems/'
SET @cURL = 'http://www.eMunching.com/Restaurants/'+@Name+'/ArtWork/CategoryIcons/'

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
		Set @MealTypes = @MealTypes + '7'
	End
	
If @Dinner = 1
	Begin
		Set @MealTypes = @MealTypes + '5,'
	End
	
-- Step 1: Create the restaurant
INSERT INTO [dbo].[Restaurant]
           ([name]
           ,[createdTime]
           ,[lastModified]
           ,[baseUrl]
           ,[baseUrlCat]
           ,[WebSite]
           ,[FacebookUrl]
           ,[TwitterHandle]
           ,[EmailLogo]
           ,[PrimaryCountry]
           ,[AboutUs]
           ,[MainEmailContact]
           ,[HoursOfOperation])
     VALUES
           (@Name
           ,GETDATE()
           ,GETDATE()
           ,@bURL
           ,@cURL
           ,@Website
           ,@FacebookUrl
           ,@TwitterHandle
           ,''
           ,@PrimaryCountry
           ,''
           ,@MainEmailContact
           ,'')
           
-- Step 2: Create the config record
DECLARE @RestID int
SET @RestID = (Select ID from Restaurant where name = @Name)
           
INSERT INTO [Config]
           ([Restaurant]
           ,[ResvEnabled]
           ,[ResvWeeksInAdvance]
           ,[ResvWeekDayStart]
           ,[ResvWeekDayStop]
           ,[ResvStartTime]
           ,[ResvStopTime]
           ,[ResvInterval]
           ,[ResvTableThreshold]
           ,[OrdersEnabled]
           ,[OrdersTimeFrame]
           ,[MealTypesEnabled])
     VALUES
           (@RestID
           ,1
           ,2
           ,'Monday'
           ,'Sunday'
           ,'16:00:00'
           ,'21:00:00'
           ,'00:20:00'
           ,10
           ,1
           ,'20'
           ,@MealTypes)
           
-- Step 3: Create the Role to Restaurant Mapping

DECLARE @ReDiPath nvarchar(500)
SET @ReDiPath = '~/Restaurants/' + @Name + '/Admin/default.aspx'

insert into RestaurantRoles (RoleName,Restaurant,Path)
select value,@RestID,@ReDiPath from dbo.ft_Split(@Roles,',')

update RestaurantRoles Set Path = REPLACE(Path,'Admin','Orders') Where RoleName Like '%Orders%'
update RestaurantRoles Set Path = REPLACE(Path,'Admin','Reservations') Where RoleName Like '%Resv%' or RoleName Like '%Reservations%'

-- Step 4: Create Additional Config with deafault settings
INSERT INTO AdditionalConfig (Restaurant) VALUES(@RestID)
/*
Create Restaurant Folder(s)
Copy files to folders from template folder

* DB Scripts
create placeholder location
create placeholder menu group
create placeholder menuitem
create (copy) email messages
Set baseURL's
Set session redirects for restaurant landing page
create config placeholder and update mealtypes
*/


