/****** Object:  View [dbo].[v_CurrentReservations]    Script Date: 11/27/2012 17:00:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[v_CurrentReservations]    Script Date: 12/17/2012 11:11:02 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_CurrentReservations]'))
DROP VIEW [dbo].[v_CurrentReservations]
GO

CREATE VIEW [dbo].[v_CurrentReservations]
AS
SELECT r.[id]						AS ResvID
      ,r.[Name]						AS ResvName
      ,[callBackNumber]				AS ResvCallBackNum
      ,rt.type						AS ResvType
      ,rs.name						AS RestName
      ,rl.Name						AS RestLocaName
      ,FirstName + ' ' + LastName	AS RequestedBy
      ,[NumGuests]					AS ResvNumGuests
      ,[timeSlot]					AS ResvTimeslot
      ,r.[createdTime]				AS ResvCreatedTime
      ,rs.id						AS RestID
      ,rl.LocaID					AS RestLocaID
      ,r.Active						AS Active
  FROM [Reservations] r
  JOIN [ReservationType] rt ON r.[TYPE] = rt.id
  JOIN [Restaurant] rs ON restaurantId = rs.id
  JOIN [RestaurantLocation] rl on r.restaurantLocaId = rl.LocaID
  JOIN [MobileAppUsers] m ON r.memberId = m.Email AND r.restaurantId = m.RestaurantID


GO


/****** Changes to p_gv_SelectRestaurantReservations ******/


/****** Object:  StoredProcedure [dbo].[p_gv_SelectRestaurantReservations]    Script Date: 11/27/2012 17:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[p_gv_SelectRestaurantReservations]
	@RestID int
AS
SELECT [ResvID]
      ,[ResvName]
      ,[ResvCallBackNum]
      ,[ResvType]
      ,[RestName]
      ,[RestLocaName]
      ,[RequestedBy]
      ,[ResvNumGuests]
      ,[ResvTimeslot]
      ,[ResvCreatedTime]
      ,[RestID]
      ,[RestLocaID]
      ,CASE WHEN [Active] = 1 THEN 'Approved'
			ELSE 'Approve'
		END AS Approve
  FROM [v_CurrentReservations]
 WHERE RestID = @RestID
 
 
 /******* Changes to  p_Svc_CreateReservations *******/
 
 /****** Object:  StoredProcedure [dbo].[p_Svc_CreateReservations]    Script Date: 11/27/2012 16:59:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
DECLARE @Result nvarchar(500)
EXEC p_Svc_CreateReservations 'Andrew','13364290805','5','2','andrew.prisk@themobilisgroup.com','2','2011-11-19 20:20:00', @Result=@Result OUTPUT 
*/

ALTER PROC [dbo].[p_Svc_CreateReservations]
	@ResName nvarchar(50),
	@CallBackNumber nvarchar(15),
	@RestaurantID int,
	@RestaurantLocaID int, 
	@UserID nvarchar(150),
	@NumGuests int,
	@TimeSlot datetime,
	@Result nvarchar(500) OUTPUT
AS

/*
	1. Check if the timeslot is available
	2. If available, create reservation and send email
	3. If unavailable, record attempt and then send denial email
*/

SET @Result = ''

DECLARE @CurrentCount int
DECLARE @TblLimit int
declare @restname nvarchar(50)
declare @from nvarchar(50)
declare @MsgBody nvarchar(max)
declare @MsgBody2 nvarchar(max)
declare @subj nvarchar(100)
declare @subj2 nvarchar(100)
declare @Email nvarchar(150)	

SET @CurrentCount	= (select COUNT(*) from Reservations where restaurantId=@RestaurantID and timeSlot = @TimeSlot and restaurantLocaId=@RestaurantLocaID)
SET @TblLimit		= (Select ResvTableThreshold From Config Where Restaurant = @RestaurantID)
Set @Email			= (select Email from MobileAppUsers where ID=@UserID and RestaurantID=@RestaurantID)

IF (select dbo.fn_RegExpMatch(@CallBackNumber,'^(?:(?:[\+]?(?<CountryCode>[\d]{1,3}(?:[ ]+|[\-.])))?[(]?(?<AreaCode>[\d]{3})[\-/)]?(?:[ ]+)?)?(?<Number>[a-zA-Z2-9][a-zA-Z0-9 \-.]{6,})(?:(?:[ ]+|[xX]|(i:ext[\.]?)){1,2}(?<Ext>[\d]{1,5}))?$')) = 0
	BEGIN
		SET @Result = 'Phone Number is not valid.'
	END
	
IF (select distinct RestaurantID From RestaurantLocation where LocaID=@RestaurantLocaID and RestaurantID=@RestaurantID) = @RestaurantID
	BEGIN
		SET @result = ''
	END
Else
	BEGIN
		SET @Result = 'The specified restaurant location does not match the restaurant.'
	END

IF @Result = ''
	BEGIN
		IF (SELECT @CurrentCount) < @TblLimit			
			BEGIN	
				INSERT INTO Reservations(Name,callBackNumber,[Type],restaurantId,restaurantLocaId,isMember,memberId,NumGuests,NumChildren,timeSlot,takenBy,createdTime,lastModified,Active)
					 VALUES (@ResName,@CallBackNumber,1,@RestaurantID,@RestaurantLocaID,1,@UserID,@NumGuests,0,@TimeSlot,999,GETDATE(),GETDATE(),0)
				 
				Set @restname		= (Select name from Restaurant where id = @RestaurantID)
				Set @from			= (select 'reservations@' + @restname + '.eMunching.com')
				Set @MsgBody		= (select REPLACE(MsgBody,'[TIMESLOT]',CAST(@TimeSlot as nvarchar(30))) from ConfigEmailMsgs Where Restaurant = @RestaurantID and ActionName = 'ResvAccept')
				Set @subj			= (select 'RE: ' + @restname + ' Reservation - ACCEPTED')
				--EXEC p_SendEMail3 @UserID, '', '', @subj, @from, @MsgBody, '', 's2smtpout.secureserver.net', '25', '', '', '.\SQLEXPRESS', 'eMunching', 'MenuTrix', '..menutrix01'
				
				
				SET @Result = 'Accepted'
			END
		ELSE
			BEGIN
				
				Set @restname		= (Select name from Restaurant where id = @RestaurantID)
				Set @from			= (select 'reservations@' + @restname + '.eMunching.com')
				Set @MsgBody2		= (select REPLACE(MsgBody,'[TIMESLOT]',CAST(@TimeSlot as nvarchar(30))) from ConfigEmailMsgs Where Restaurant = @RestaurantID and ActionName = 'ResvDecln')
				Set @subj2			= (select 'RE: ' + @restname + ' Reservation - DECLINED')
				--EXEC p_SendEMail3 @UserID, '', '', @subj2, @from, @MsgBody2, '', 's2smtpout.secureserver.net', '25', '', '', '.\SQLEXPRESS', 'eMunching', 'MenuTrix', '..menutrix01'
				
				
				SET @Result = 'Declined'
			END
	END
	
SELECT @Result as Result, @UserID As UserID, '' AS Cc, @subj AS Subj, @MsgBody AS MsgBody, @from AS FromAdd, @restname AS FromName