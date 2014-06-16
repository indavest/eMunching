/****** Object:  StoredProcedure [dbo].[p_gv_GetDeals]    Script Date: 09/28/2012 11:56:14 ******/
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
  FROM [Deals]
 WHERE Restaurant = @RestID