/****** Object:  StoredProcedure [dbo].[patch_CreateMenuDisplayDefaultOptionForRestaurant]    Script Date: 09/14/2012 13:49:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[patch_CreateMenuDisplayDefaultOptionForRestaurant]
AS
DECLARE @id INT
DECLARE EventCursor CURSOR FOR SELECT id FROM Restaurant

	 OPEN EventCursor
		FETCH NEXT FROM EventCursor INTO @id

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO dbo.MobileAppDisplaySettings (Restaurant, EventDealMenu, Type, CreatedTime, LastModified) VALUES(@id, 'Event', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
			INSERT INTO dbo.MobileAppDisplaySettings (Restaurant, EventDealMenu, Type, CreatedTime, LastModified) VALUES(@id, 'Menu', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
			INSERT INTO dbo.MobileAppDisplaySettings (Restaurant, EventDealMenu, Type, CreatedTime, LastModified) VALUES(@id, 'Deal', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
			FETCH NEXT FROM EventCursor
			INTO @id
		END

	 CLOSE EventCursor
DEALLOCATE EventCursor



GO


