ALTER TABLE DeviceToken ADD Email nvarchar(50)
GO

/****** Object:  Table [dbo].[LoyaltyNotifications]    Script Date: 11/15/2012 10:42:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LoyaltyNotifications](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_LoyaltyNotifications] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_LoyaltyNotifications] UNIQUE NONCLUSTERED 
(
	[DeviceToken] ASC,
	[Restaurant] ASC,
	[Email] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LoyaltyNotifications]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[LoyaltyNotifications]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO
ALTER TABLE [dbo].[LoyaltyNotifications] ADD  CONSTRAINT [DF_LoyaltyNotifications_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO

/*** Adding New Notification Type "Loyalty" in dbo.NotificationTypes table ***/
INSERT INTO NotificationTypes (Name) VALUES('Loyalty')
GO
