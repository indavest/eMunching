/****** Object:  Table [dbo].[AdditionalConfig]    Script Date: 10/01/2012 17:27:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AdditionalConfig](
	[Restaurant] [int] NOT NULL,
	[EmailEnabled] [nvarchar](100) NOT NULL,
	[NotificationsEnabled] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_AdditionalConfig] PRIMARY KEY CLUSTERED 
(
	[Restaurant] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AdditionalConfig]  WITH NOCHECK ADD  CONSTRAINT [FK_AdditionalConfig_Restaurant] FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[AdditionalConfig] CHECK CONSTRAINT [FK_AdditionalConfig_Restaurant]
GO

ALTER TABLE [dbo].[AdditionalConfig] ADD  CONSTRAINT [DF__Additiona__Email__26FAA8BE]  DEFAULT (N'1,2,3') FOR [EmailEnabled]
GO

ALTER TABLE [dbo].[AdditionalConfig] ADD  CONSTRAINT [DF_AdditionalConfig_NotificationsEnables]  DEFAULT ((0)) FOR [NotificationsEnabled]
GO

INSERT INTO AdditionalConfig (Restaurant) SELECT id FROM Restaurant
GO
