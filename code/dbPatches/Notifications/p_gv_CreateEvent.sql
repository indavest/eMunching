/****** Object:  StoredProcedure [dbo].[p_gv_CreateEvent]    Script Date: 09/28/2012 11:57:20 ******/
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
	@time char(10)
AS
INSERT INTO [RestaurantEvents]
           ([Restaurant]
           ,[Loca]
           ,[Name]
           ,[Description]
           ,[Date]
           ,[Time])
     VALUES
           (@Restaurant
           ,@RestLoca
           ,@EventName
           ,@Desc
           ,@Date
           ,@time)


DECLARE @subj nvarchar(500)
DECLARE @from nvarchar(100)
DECLARE @MsgBody nvarchar(max)

declare @restname nvarchar(50)

	Set @restname = (Select name from Restaurant where id = @Restaurant)
	Set @from = (select 'Events@' + @restname + '.eMunching.com')
	Set @subj = (select 'RE: New Event Alert from ' + @restname + '!')	

Set @MsgBody = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@desc, '&lt;','<'),'&gt;','>'),'&quot;','"'),'&amp;','&'),'&#39;','')

DECLARE @UserEmail nvarchar(50)
DECLARE EventCursor CURSOR FOR SELECT ID FROM MobileAppUsers WHERE ID NOT LIKE '%call.in%' AND RestaurantID = @Restaurant

	 OPEN EventCursor
		FETCH NEXT FROM EventCursor INTO @UserEmail

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Exec p_SendEMail3 @UserEmail,'','',@subj,@from,@MsgBody,'','s2smtpout.secureserver.net','',''
			--EXEC p_SendEMail3 @recipients		= @UserEmail
			--				, @CC				= ''
			--				, @BCC				= ''
			--				, @subject			= @subj
			--				, @from				= @from
			--				, @body				= @MsgBody 
			--				, @strAttachments	= ''
			--				, @strSMTPServer	= 's2smtpout.secureserver.net'
			--				, @strSMTPServerPort= '25'
			--				, @strSMTPServerUser= ''
			--				, @strSMTPServerPwd	= ''
			--				, @LoggingDBServer	= '.\SQLEXPRESS'
			--				, @LoggingDB		= 'eMunching'
			--				, @LoggingDBUser	= 'MenuTrix'
			--				, @LoggingDBPass	= '..menutrix01'
			FETCH NEXT FROM EventCursor
			INTO @UserEmail
		END

	 CLOSE EventCursor
DEALLOCATE EventCursor

SELECT @UserEmail AS UserEmail, '' AS Cc, @subj AS Subj, @MsgBody AS MsgBody, @from AS FromAdd,@restname AS FromName

