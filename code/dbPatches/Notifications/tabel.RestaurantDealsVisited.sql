/****** Object:  Table [dbo].[RestaurantDealsVisited]    Script Date: 10/09/2012 12:13:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RestaurantDealsVisited](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[DealID] [int] NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_RestaurantDealsVisited] UNIQUE NONCLUSTERED 
(
	[DealID] ASC,
	[DeviceToken] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RestaurantDealsVisited]  WITH CHECK ADD  CONSTRAINT [FK__Restauran__DealI__19A0ADA0] FOREIGN KEY([DealID])
REFERENCES [dbo].[Deals] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RestaurantDealsVisited] CHECK CONSTRAINT [FK__Restauran__DealI__19A0ADA0]
GO

ALTER TABLE [dbo].[RestaurantDealsVisited]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[RestaurantDealsVisited] ADD  CONSTRAINT [DF_RestaurantDealsVisited_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO


