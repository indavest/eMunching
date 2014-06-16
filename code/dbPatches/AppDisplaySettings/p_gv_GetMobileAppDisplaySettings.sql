/****** Object:  StoredProcedure [dbo].[p_gv_GetMobileAppDisplaySettings]    Script Date: 09/14/2012 13:50:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[p_gv_GetMobileAppDisplaySettings]
	@RestID int
AS
SELECT MADS.[EventDealMenu],
	   DSO.[Type]
	   FROM [dbo].[MobileAppDisplaySettings] as MADS, [dbo].[DisplaySettingOptions] as DSO WHERE MADS.Type = DSO.id AND
MADS.Restaurant=@RestID




GO


