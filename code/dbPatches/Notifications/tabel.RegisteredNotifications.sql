/****** Object:  Table [dbo].[RegisteredNotifications]    Script Date: 09/28/2012 11:48:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RegisteredNotifications](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[ActionType] [nvarchar](20) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RegisteredNotifications]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO


