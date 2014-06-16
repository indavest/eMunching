/****** Object:  StoredProcedure [dbo].[p_Svc_CreateOrder]    Script Date: 10/22/2012 10:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- p_Svc_CreateOrder @OrderName,@RestaurantID,@RestaurantLocaID,@UserId,@MenuItems

ALTER PROC [dbo].[p_Svc_CreateOrder] --'Test999','andrew.prisk@themobilisgroup.com',5,3,'100036,1;50,2;54,1;'
	@OrderName varchar(255)
   ,@UserId nvarchar(150)
   ,@RestaurantId int
   ,@RestLocaId int
   ,@MenuItems nvarchar(max)
AS

Declare @OrderId uniqueidentifier
Set @OrderId = NEWID()

-- 1. create order <auto gen id, grab name>
INSERT INTO [Order]
           ([oid]
           ,[name]
           ,RestId
           ,AtLoca
           ,Acked
           ,[createdTime]
           ,Active)
     VALUES
           (@OrderId
           ,@OrderName
           ,@RestaurantId
           ,@RestLocaId
           ,0
           ,GETDATE()
           ,1);

-- 2. create user assoc record with the order id 
INSERT INTO [MobileAppUsersOrders]
           ([AppUserId]
           ,[oId]
           ,[createdTime])
     VALUES
           (@UserId
           ,@OrderId
           ,GETDATE());
           
-- 3. enter in the order details Item = ItemId,Qty|ItemId,Qty|
create table #menutemp (item nvarchar(100))
insert into #menutemp(item)
Select value from ft_Split(@menuitems,';');

DECLARE @count INT 
SET @count = 0 
WHILE (@count < (select COUNT(*) from #menutemp)) 
BEGIN 
   INSERT INTO [OrderMenuItem] ([ordersId],[menuitemId],[quantity],[createdTime],[lastModified],[OrderGroupID],[CollectionID])
   select @OrderId,(SELECT value FROM ft_Split(item,',') WHERE position=1),(SELECT value FROM ft_Split(item,',') WHERE position=2),GETDATE(),GETDATE(),(SELECT value FROM ft_Split(item,',') WHERE position=3),(SELECT value FROM ft_Split(item,',') WHERE position=4) FROM #menutemp
   SET @count = (@count + (select COUNT(*) from #menutemp)) 
END

drop table #menutemp;


-- 4. Send Email to User

	declare @MsgBody nvarchar(max)
	declare @RestLogo nvarchar(500)
	set @RestLogo = (Select '<img src=''' + EmailLogo + ''' border=0>' From Restaurant where id = @RestaurantID)
	Set @MsgBody = (select REPLACE(REPLACE(MsgBody,'[ORDERNAME]',CAST(@OrderName as nvarchar(30))),'[EMAILLOGO]',@RestLogo) from ConfigEmailMsgs Where Restaurant = @RestaurantID and ActionName = 'OrderPending')

	-- lookup the restaurant name for to compose the vanity email address from.
	declare @restname nvarchar(50)
	declare @from nvarchar(50)
	declare @subj nvarchar(100)

	Set @restname = (Select name from Restaurant where id = @RestaurantID)
	Set @from = (select 'orders@' + @restname + '.eMunching.com')
	Set @subj = (select 'RE: ' + @restname + ' Order - ACCEPTED')	   
	-- Send Email
	--set @MsgBody = '<h1>Welcome to the eMunching Test Site!</h1>Your Reservation is confirmed for ' + dbo.fs_FormatDateTime(GETDATE(),'YYYY-MM-DD') + ' ' + CAST(@TimeSlot as nvarchar(8)) + '.'

	declare @cc nvarchar(max)
	Set @cc = (Select OrdersCCAddress FROM Config WHERE Restaurant = @RestaurantId)

	IF @CC = ' '
		BEGIN
			SET @CC = ''
		END

	--Exec p_SendEMail @UserId,@CC,'',@subj,@from,@MsgBody,'','s2smtpout.secureserver.net','',''
	SELECT @UserId AS UserId, @cc AS Cc, @subj AS Subj, @MsgBody AS MsgBody, @from AS FromAdd, @restname AS FromName