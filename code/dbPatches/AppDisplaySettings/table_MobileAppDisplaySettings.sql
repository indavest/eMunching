/****** Object:  Table [dbo].[MobileAppDisplaySettings]    Script Date: 09/14/2012 13:46:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MobileAppDisplaySettings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[EventDealMenu] [nvarchar](20) NOT NULL,
	[Type] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MobileAppDisplaySettings]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[MobileAppDisplaySettings]  WITH CHECK ADD FOREIGN KEY([Type])
REFERENCES [dbo].[DisplaySettingOptions] ([id])
GO

ALTER TABLE [dbo].[MobileAppDisplaySettings] ADD  CONSTRAINT [DF_MobileAppDisplaySettings_Type]  DEFAULT ((0)) FOR [Type]
GO


