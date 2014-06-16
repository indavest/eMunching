/****** Object:  Table [dbo].[NotificationsSentToAPNS]    Script Date: 10/04/2012 17:09:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NotificationsSentToAPNS](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[Count] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
	[ActionType] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[NotificationsSentToAPNS]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[NotificationsSentToAPNS] ADD  CONSTRAINT [DF_NotificationsSentToAPNS_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO

ALTER TABLE [dbo].[NotificationsSentToAPNS] ADD  CONSTRAINT [DF_NotificationsSentToAPNS_UpdatedTime]  DEFAULT (getdate()) FOR [UpdatedTime]
GO


