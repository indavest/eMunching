/****** Object:  StoredProcedure [dbo].[p_gv_Events]    Script Date: 09/28/2012 11:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[p_gv_Events] --5
	@RestID int
as
select * from v_Events where Restaurant = @RestID