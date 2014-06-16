/****** Object:  Table [dbo].[DeviceToken]    Script Date: 09/28/2012 17:00:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DeviceToken](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceToken] [nvarchar](200) NOT NULL,
	[Restaurant] [int] NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_DeviceToken] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_DeviceToken] UNIQUE NONCLUSTERED 
(
	[DeviceToken] ASC,
	[Restaurant] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DeviceToken]  WITH CHECK ADD FOREIGN KEY([Restaurant])
REFERENCES [dbo].[Restaurant] ([id])
GO

ALTER TABLE [dbo].[DeviceToken] ADD  CONSTRAINT [DF_DeviceToken_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [dbo].[DeviceToken] ADD  CONSTRAINT [DF_DeviceToken_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO


