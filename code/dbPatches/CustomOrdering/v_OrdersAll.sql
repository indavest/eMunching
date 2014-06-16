/****** Object:  View [dbo].[v_OrdersAll]    Script Date: 10/22/2012 10:25:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  View [dbo].[v_OrdersAll]    Script Date: 12/17/2012 05:29:52 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_OrdersAll]'))
DROP VIEW [dbo].[v_OrdersAll]
GO


CREATE View [dbo].[v_OrdersAll]
As

SELECT     mao.AppUserId
		,  mao.oId
		,  mao.createdTime
		,  mau.FirstName
		,  mau.LastName
		,  mau.Email
		,  mau.Phone
		,  o.RestID
		,  r.name
		,  rl.Name	as locationName
		,  rl.PhoneNumber as locaphone
		,  ct.Country
		,  reg.Region
		,  ci.City
		,  rl.StreetAddress
		,  ci.Latitude
		,  ci.Longitude
		,  ct.Currency
		,  ct.CurrencyCode
		,  AppUserId + ' _' + REPLACE(REPLACE(o.createdTime,':',''),' ','') AS OrderName
		,  o.createdTime AS OrderTaken
		,  omi.menuitemId
		,  omi.OrderGroupID AS GroupID
		,  omi.CollectionID AS CollectionID
		,  mi.Item
		,  ItemPriceA
		,  mi.ItemPriceB
		,  mi.ComboPrice
		,  mi.Veg
		,  mi.ChefSpecial
		,  mi.ChildsPlate
		,  mi.Archive
		,  mi.PriceSchedule
		,  mig.MenuItemGroup
		,  omi.quantity
		,  mi.MealType
		,  o.Acked
		,  o.Active
FROM       dbo.MobileAppUsersOrders  mao
INNER JOIN dbo.MobileAppUsers mau		ON mao.AppUserId = mau.Email
INNER JOIN dbo.[Order] o				ON mao.oId = o.oid 
INNER JOIN dbo.OrderMenuItem omi		ON o.oid = omi.ordersId 
INNER JOIN dbo.Restaurant r				ON mau.RestaurantID = r.id 
INNER JOIN dbo.RestaurantLocation rl	ON o.AtLoca = rl.LocaID
INNER JOIN dbo.City ci					ON rl.CityID = ci.CityId 
INNER JOIN dbo.Country ct				ON ci.CountryID = ct.CountryId 
INNER JOIN dbo.Region reg				ON ci.RegionID = reg.RegionID AND ct.CountryId = reg.CountryID 
INNER JOIN dbo.MenuItems mi				ON omi.menuitemId = mi.MenuItemID AND r.id = mi.Restaurant 
INNER JOIN dbo.MenuItemGroups mig		ON r.id = mig.Restaurant AND mi.MenuGroup = mig.MenuItemGroupID






GO


