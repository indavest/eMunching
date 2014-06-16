/****** Object:  Table [dbo].[EmailOptions]    Script Date: 10/01/2012 13:58:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmailOptions](
	[EmailOptionID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EmailOptions] PRIMARY KEY CLUSTERED 
(
	[EmailOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO EmailOptions (Name) VALUES ('Event'),('Deal'),('Member Registration'),('Reservation')
GO
