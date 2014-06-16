/****** Object:  View [dbo].[v_Events]    Script Date: 10/03/2012 12:14:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[v_Events]
as
SELECT [EventID]
      ,[Restaurant]
      ,Loca
      ,r.name			RestName
      ,l.Name			LocaName
      ,e.Name			EventName
      ,[Description]
      ,[Date]
      ,[Time]	EventTime
      ,CASE WHEN Active = 1 THEN 'Published'
			ELSE 'Publish'
		END AS Publish
	  ,Active				
  FROM RestaurantEvents e
  JOIN Restaurant r ON e.Restaurant = r.id
  JOIN RestaurantLocation l on e.Loca = l.locaID


GO


