/****** Object:  StoredProcedure [dbo].[p_gv_UpdateMobileAppDisplaySettings]    Script Date: 09/14/2012 13:51:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[p_gv_UpdateMobileAppDisplaySettings]
	@RestID int,
	@EventDealMenu nvarchar(20),
	@Type nvarchar(50)
AS

UPDATE dbo.MobileAppDisplaySettings SET Type = (SELECT id FROM dbo.DisplaySettingOptions WHERE Type = @Type) WHERE EventDealMenu=@EventDealMenu AND Restaurant=@RestID

GO


