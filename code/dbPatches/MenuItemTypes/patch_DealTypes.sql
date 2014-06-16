ALTER TABLE [dbo].[Deals] ADD [DealType] [int] NOT NULL DEFAULT ((1))
GO

ALTER TABLE [dbo].[Deals]  WITH CHECK ADD FOREIGN KEY([DealType])
REFERENCES [dbo].[MenuItemTypes] ([MenuTypeId])
GO

/***** Changes to p_gv_GetDeals *****/


/****** Object:  StoredProcedure [dbo].[p_gv_GetDeals]    Script Date: 12/03/2012 14:09:30 ******/
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
  FROM [Deals]
  JOIN MenuItemTypes mit on Deals.DealType = mit.MenuTypeId
  WHERE Restaurant = @RestID
  
  
  /***** Changes to p_CreateDeal*****/
  

  /****** Object:  StoredProcedure [dbo].[p_CreateDeal]    Script Date: 12/03/2012 14:45:04 ******/
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
	@DealType int
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
           ,[DealType])
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
           ,@DealType)

DECLARE @subj nvarchar(500)
DECLARE @from nvarchar(100)
DECLARE @MsgBody nvarchar(max)
DECLARE @RestName nvarchar(50)

Set @restname = (Select name from Restaurant where id = @RestID)
Set @from = (select 'Deals@' + @restname + '.eMunching.com')
Set @subj = (select 'RE: New Deal Alert from ' + @restname + '!')

Set @MsgBody = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@desc, '&lt;','<'),'&gt;','>'),'&quot;','"'),'&amp;','&'),'&#39;','')


DECLARE @UserEmail nvarchar(50)
DECLARE DealCursor CURSOR FOR SELECT ID FROM MobileAppUsers WHERE ID NOT LIKE '%call.in%' AND RestaurantID = @RestID 

	 OPEN DealCursor
		FETCH NEXT FROM DealCursor INTO @UserEmail

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
			FETCH NEXT FROM DealCursor
			INTO @UserEmail
		END

	 CLOSE DealCursor
DEALLOCATE DealCursor

SELECT @UserEmail AS UserEmail, '' AS Cc, @subj AS Subj, @MsgBody AS MsgBody, @from AS FromAdd, @RestName AS FromName

/***** Changes to p_Svc_GetDeals *****/


/****** Object:  StoredProcedure [dbo].[p_Svc_GetDeals]    Script Date: 12/03/2012 14:51:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[p_Svc_GetDeals] --5
	@RestID int
As
SELECT d.[id]
      ,r.name
      ,[title]
      ,[description]
      ,Case thumbnail
			when '' Then 'http://www.emunching.com/Restaurants/Besito/ArtWork/DealImages/noimage-thumb.png'
			else 'http://www.emunching.com/Restaurants/Besito/ArtWork/DealImages/' + [thumbnail]
	   end as thumbnail
      ,Case [image]
			when '' Then 'http://www.emunching.com/Restaurants/Besito/ArtWork/DealImages/noimage-image.png'
			else 'http://www.emunching.com/Restaurants/Besito/ArtWork/DealImages/' + [image]
	   end as [image]
      ,[type]
      ,[value]
      ,[expiresOn]
      ,[startsFrom]
      ,[DealType]
  FROM [Deals] d
  JOIN Restaurant r ON d.Restaurant = r.ID
  WHERE d.Restaurant = @RestID ORDER BY d.createdTime DESC
  
  /******* p_sv_UpdateDeals *****/
  
  
  /****** Object:  StoredProcedure [dbo].[p_gv_UpdateDeals]    Script Date: 12/17/2012 11:57:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[p_gv_UpdateDeals]
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


GO
