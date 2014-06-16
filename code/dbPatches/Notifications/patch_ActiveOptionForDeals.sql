ALTER TABLE [dbo].[Deals] ADD [active] [int] NOT NULL DEFAULT ((0))
GO
UPDATE [dbo].[Deals] SET active=1
GO