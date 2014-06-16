USE [eMunchingDev]
GO

/****** Object:  Table [dbo].[RestaurantEventsVisited]    Script Date: 10/09/2012 12:14:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RestaurantEventsVisited](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_RestaurantEventsVisited] UNIQUE NONCLUSTERED 
(
	[EventID] ASC,
	[DeviceToken] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RestaurantEventsVisited]  WITH CHECK ADD  CONSTRAINT [FK__Restauran__Event__13E7D44A] FOREIGN KEY([EventID])
REFERENCES [dbo].[RestaurantEvents] ([EventID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RestaurantEventsVisited] CHECK CONSTRAINT [FK__Restauran__Event__13E7D44A]
GO

ALTER TABLE [dbo].[RestaurantEventsVisited]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[RestaurantEventsVisited]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[RestaurantEventsVisited] ADD  CONSTRAINT [DF_RestaurantEventsVisited_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO


