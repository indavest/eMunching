/****** Object:  StoredProcedure [dbo].[p_gv_GetCategories]    Script Date: 10/01/2012 11:00:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[p_gv_GetCategories]
	@RestID int
AS
SELECT [MenuItemGroupID]
      ,[Restaurant]
      ,[MenuItemGroup]
      ,ISNULL([MenuItemGroupDesc],' ') as MenuItemGroupDesc
      ,ISNULL([MenuItemGroupImage], 'tacos.png') as MenuItemGroupImage
      ,[Order]
  FROM [MenuItemGroups]
WHERE Restaurant=@RestID


