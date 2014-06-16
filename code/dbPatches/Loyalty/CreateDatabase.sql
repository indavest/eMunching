IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'LoyaltyType'
))
BEGIN
	CREATE TABLE [dbo].[LoyaltyType] (
		[ID]             	INT           NOT NULL PRIMARY KEY,
		[LoyaltyType] 		NVARCHAR (50) NOT NULL
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'Restaurant'
))
BEGIN
	CREATE TABLE [dbo].[Restaurant] (
		[ID]             INT           NOT NULL PRIMARY KEY,
		[RestaurantName] NVARCHAR (50) NOT NULL,
		[LoyaltyID] INT NOT NULL,
		CONSTRAINT	[FK_Restaurant_ToLoyaltyType] FOREIGN KEY ([LoyaltyID]) REFERENCES [LoyaltyType]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'Generated_UniqueCode'
))
BEGIN
	CREATE TABLE [dbo].[Generated_UniqueCode] (
		[UniqueCode]   NVARCHAR (20)      NOT NULL PRIMARY KEY,
		[DateCreated]  DATETIME NOT NULL,
		[RestaurantId] INT      NOT NULL,
		[IsValidated] BIT 		NOT NULL,
		[DateValidated] DATETIME NULL,
		CONSTRAINT [FK_Generated_UniqueCodes_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END


IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'UniqueCode_Archive'
))
BEGIN
	CREATE TABLE [dbo].[UniqueCode_Archive](
		[UniqueCode] NVARCHAR(20) NOT NULL PRIMARY KEY,
		[DateCreated]  DATETIME NOT NULL,
		[RestaurantId] INT NOT NULL,
		[DateValidated] DATETIME NULL,
		CONSTRAINT [FK_UniqueCode_Archive_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'CreateNotifier_UniqueCodes'
))
BEGIN
	CREATE TABLE [dbo].[CreateNotifier_UniqueCodes](
		[Id] INT NOT NULL PRIMARY KEY,
		[RestaurantId] INT NOT NULL, 
		[IsCreateNewCodes] BIT NOT NULL,
		[NumberofCodesToGenerate] INT NOT NULL,
		[IsServiced] BIT NOT NULL,
		CONSTRAINT [FK_CreateNotifier_UniqueCodes_ToRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurant] ([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'Generated_CouponCode'
))
BEGIN
	CREATE TABLE [dbo].[Generated_CouponCode] (
		[CouponCode]   NVARCHAR (20) NOT NULL PRIMARY KEY,
		[RestaurantId] INT           NOT NULL,
		[EmailAddress] NVARCHAR (50) NOT NULL,
		[IsAssigned]   BIT           NOT NULL,
		[IsRedeemed]   BIT           NOT NULL,
		[DateCreated]  DATETIME      NOT NULL,
		[DateRedeemed] DATETIME      NULL,
		CONSTRAINT [FK_Generated_CouponCode_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'CouponCode_UniqueCodeMapping'
))
BEGIN
	CREATE TABLE [dbo].[CouponCode_UniqueCodeMapping](
		[ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		[CouponCode] NVARCHAR(20) NOT NULL , 
		[UniqueCode] NVARCHAR(20) NOT NULL
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'ItemCode'
))
BEGIN
	CREATE TABLE [dbo].[ItemCode](
		[ItemCode] INT NOT NULL, 
		[RestaurantId] INT NOT NULL,
		[ItemName] NVARCHAR(256) NOT NULL, 
		[LoyaltyEnabled] BIT NOT NULL, 
		[LoyaltyPoints] INT NOT NULL, 
		[LoyaltyMultiplier] INT NOT NULL, 
		[BonusPoints] INT NOT NULL, 
		[DateCreated] DATETIME NOT NULL, 
		[DateModified] DATETIME NOT NULL, 
		PRIMARY KEY ([ItemCode], [RestaurantId]),
		CONSTRAINT [FK_ItemCode_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'SettlementInfo'
))
BEGIN
	CREATE TABLE [dbo].[SettlementInfo] (
		[BillNumber]   NVARCHAR (50) NOT NULL,
		[RestaurantId] INT           NOT NULL,
		[UniqueCode]   NVARCHAR (20) NOT NULL,
		[EmailAddress] NVARCHAR (50) NULL,
		[IsServiced]   BIT           NOT NULL,
		[DateCreated]  DATETIME      NOT NULL,
		[DateModified] DATETIME      NOT NULL,
		[SettlementDate]	DATE	 NOT NULL,
		PRIMARY KEY ([BillNumber], [RestaurantId]),
		CONSTRAINT [FK_SettlementInfo_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'SettlementInfo_Archive'
))
BEGIN
	CREATE TABLE [dbo].[SettlementInfo_Archive] (
		[BillNumber]   NVARCHAR (50) NOT NULL,
		[RestaurantId] INT           NOT NULL,
		[UniqueCode]   NVARCHAR (20) NOT NULL,
		[EmailAddress] NVARCHAR (50) NOT NULL,
		[IsServiced]   BIT           NOT NULL,
		[DateCreated]  DATETIME      NOT NULL,
		[DateModified] DATETIME      NOT NULL,
		[SettlementDate]	DATE	 NOT NULL,
		PRIMARY KEY ([BillNumber], [RestaurantId]),
		CONSTRAINT [FK_SettlementInfo_Archive_ToRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurant] ([ID]),
		CONSTRAINT [FK_SettlementInfo_Archive_ToGenerated_UniqueCode] FOREIGN KEY ([UniqueCode]) REFERENCES [dbo].[Generated_UniqueCode] ([UniqueCode])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'OrderDetail'
))
BEGIN
	CREATE TABLE [dbo].[OrderDetail](
		[Id] INT NOT NULL PRIMARY KEY IDENTITY,
		[BillNumber] NVARCHAR(50) NOT NULL, 
		[ItemCode] INT NOT NULL, 
		[RestaurantId] INT NOT NULL,
		[Quantity] INT NOT NULL,  
		CONSTRAINT [FK_OrderDetail_ToSettlementInfo] FOREIGN KEY ([BillNumber], [RestaurantId]) REFERENCES [SettlementInfo]([BillNumber], [RestaurantId]), 
		CONSTRAINT [FK_OrderDetail_ToItemCode] FOREIGN KEY ([ItemCode], [RestaurantId]) REFERENCES [ItemCode]([ItemCode], [RestaurantId]), 
		CONSTRAINT [FK_OrderDetail_ToRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurant] ([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'OrderDetail_Archive'
))
BEGIN
	CREATE TABLE [dbo].[OrderDetail_Archive](
		[Id] INT NOT NULL PRIMARY KEY IDENTITY,
		[BillNumber] NVARCHAR(50) NOT NULL, 
		[ItemCode] INT NOT NULL, 
		[RestaurantId] INT NOT NULL,
		[Quantity] INT NOT NULL, 
		CONSTRAINT [FK_OrderDetail_Archive_ToSettlementInfo] FOREIGN KEY ([BillNumber], [RestaurantId]) REFERENCES [SettlementInfo]([BillNumber], [RestaurantId]),
		CONSTRAINT [FK_OrderDetail_Archive_ToItemCode] FOREIGN KEY ([ItemCode], [RestaurantId]) REFERENCES [ItemCode]([ItemCode], [RestaurantId]), 
		CONSTRAINT [FK_OrderDetail_Archive_ToRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurant] ([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'RunningCount'
))
BEGIN
	CREATE TABLE [dbo].[RunningCount](
		[EmailAddress] NVARCHAR(50) NOT NULL,
		[RestaurantId] INT NOT NULL,
		[RunningCount] INT NOT NULL, 
		[DateCreated] DATETIME NOT NULL, 
		[DateModified] DATETIME NOT NULL, 
		[UpdateCount] INT NOT NULL, 
		[LastRunningCount] INT NOT NULL,
		PRIMARY KEY ([EmailAddress], [RestaurantId]),
		CONSTRAINT [FK_RunningCount_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);
END

IF (NOT EXISTS (
	SELECT *
	FROM information_schema.tables
	WHERE table_schema = 'dbo'
	AND table_name = 'UniqueCode_UserMapping'
))
BEGIN
	CREATE TABLE [dbo].[UniqueCode_UserMapping](
		[UniqueCode] NVARCHAR(20) NOT NULL PRIMARY KEY, 
		[EmailAddress] NVARCHAR(50) NOT NULL, 
		[RestaurantId] INT NOT NULL, 
		[DateCreated] DATETIME NOT NULL, 
		CONSTRAINT [FK_UniqueCode_UserMapping_ToTableRestaurant] FOREIGN KEY ([RestaurantId]) REFERENCES [Restaurant]([ID])
	);

END
