/****** Object:  Table [dbo].[RegisteredNotificationsStatus]    Script Date: 09/28/2012 11:49:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RegisteredNotificationsStatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[NotificationId] [int] NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
	[APNSStatus] [tinyint] NOT NULL,
	[APPStatus] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RegisteredNotificationsStatus]  WITH CHECK ADD FOREIGN KEY([NotificationId])
REFERENCES [dbo].[RegisteredNotifications] ([id])
GO

ALTER TABLE [dbo].[RegisteredNotificationsStatus] ADD  CONSTRAINT [DF_RegisteredNotificationsStatus_UpdatedTime]  DEFAULT (getdate()) FOR [UpdatedTime]
GO

ALTER TABLE [dbo].[RegisteredNotificationsStatus] ADD  CONSTRAINT [DF_RegisteredNotificationsStatus_APNSStatus]  DEFAULT ((1)) FOR [APNSStatus]
GO

ALTER TABLE [dbo].[RegisteredNotificationsStatus] ADD  CONSTRAINT [DF_RegisteredNotificationsStatus_APPStatus]  DEFAULT ((0)) FOR [APPStatus]
GO


