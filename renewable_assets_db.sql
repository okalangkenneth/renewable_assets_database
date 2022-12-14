USE [master]
GO
/****** Object:  Database [renewable_assets]    Script Date: 22/09/2022 17:19:40 ******/
CREATE DATABASE [renewable_assets]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'renewable_assets', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\renewable_assets.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'renewable_assets_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\renewable_assets_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [renewable_assets] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [renewable_assets].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [renewable_assets] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [renewable_assets] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [renewable_assets] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [renewable_assets] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [renewable_assets] SET ARITHABORT OFF 
GO
ALTER DATABASE [renewable_assets] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [renewable_assets] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [renewable_assets] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [renewable_assets] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [renewable_assets] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [renewable_assets] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [renewable_assets] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [renewable_assets] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [renewable_assets] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [renewable_assets] SET  ENABLE_BROKER 
GO
ALTER DATABASE [renewable_assets] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [renewable_assets] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [renewable_assets] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [renewable_assets] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [renewable_assets] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [renewable_assets] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [renewable_assets] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [renewable_assets] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [renewable_assets] SET  MULTI_USER 
GO
ALTER DATABASE [renewable_assets] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [renewable_assets] SET DB_CHAINING OFF 
GO
ALTER DATABASE [renewable_assets] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [renewable_assets] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [renewable_assets] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [renewable_assets] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [renewable_assets] SET QUERY_STORE = OFF
GO
USE [renewable_assets]
GO
/****** Object:  UserDefinedFunction [dbo].[allManagersAndAssets]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[allManagersAndAssets]
(
	-- Add the parameters for the function here
	
)
RETURNS 
@managersAndAssets TABLE 
(
	-- Add the column definitions for the TABLE variable here
	FirstName nvarchar(50),
	LastName nvarchar(50),
	DateRegistered datetime,
	manager_or_asset nvarchar(50)
	
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @managersAndAssets
	SELECT
           [FirstName],
	       [LastName],
           [DateRegistered],
		   'Manager'
    from AssetManagers 
	INSERT INTO @managersAndAssets
	SELECT
           [assetname],
	       [sitename],
           [datecreated],
		   'Asset'
    from Assets 

	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[getHighestReview]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Ken>
-- Create date: <Create Date, 2022-09-21,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getHighestReview]
(
	-- Add the parameters for the function here
	
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @review float

	-- Add the T-SQL statements to compute the return value here
	SELECT @review = max(Review) from AssetRegistrations

	-- Return the result of the function
	RETURN @review

END
GO
/****** Object:  UserDefinedFunction [dbo].[getLocationNameById]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getLocationNameById] 
(
	-- Add the parameters for the function here
	@locationid int
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @name nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @name = county from AssetLocations where Id = @locationid

	-- Return the result of the function
	RETURN @name

END
GO
/****** Object:  UserDefinedFunction [dbo].[getLowestReview]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Ken>
-- Create date: <Create Date, 2020-09-21,>
-- Description:	<Description, Getting the lowest review,>
-- =============================================
CREATE FUNCTION [dbo].[getLowestReview]
(
	-- Add the parameters for the function here
	
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @review float

	-- Add the T-SQL statements to compute the return value here
	SELECT @review = min(review) from AssetRegistrations

	-- Return the result of the function
	RETURN @review

END
GO
/****** Object:  Table [dbo].[AssetLocations]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetLocations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[county] [nvarchar](50) NOT NULL,
	[numberofassets] [int] NULL,
	[countycode] [nvarchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Assets]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[assetname] [nvarchar](50) NOT NULL,
	[sitename] [nvarchar](50) NOT NULL,
	[capacity] [int] NULL,
	[datecreated] [datetime] NOT NULL,
	[revenue] [money] NOT NULL,
 CONSTRAINT [PK__Assets__3213E83FD9E665DE] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssetRegistrations]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetRegistrations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AssetManagersId] [int] NULL,
	[AssetsId] [int] NULL,
	[AssetLocationsId] [int] NULL,
	[Review] [float] NULL,
 CONSTRAINT [PK_Registrations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Asset_Locations]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Asset_Locations]
AS
SELECT        dbo.AssetLocations.county AS County, dbo.AssetLocations.countycode AS [Conty Code], dbo.Assets.assetname AS [Asset Name], dbo.Assets.sitename AS [Site Name]
FROM            dbo.AssetLocations INNER JOIN
                         dbo.Assets ON dbo.AssetLocations.id = dbo.Assets.id INNER JOIN
                         dbo.AssetRegistrations ON dbo.AssetLocations.id = dbo.AssetRegistrations.AssetLocationsId AND dbo.Assets.id = dbo.AssetRegistrations.AssetsId
GO
/****** Object:  Table [dbo].[AssetManagers]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetManagers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nchar](50) NULL,
	[LastName] [nchar](50) NULL,
	[DateRegistered] [date] NULL,
 CONSTRAINT [PK_CEO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Asset_Site_Managers]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Asset_Site_Managers] as


select
m.FirstName[Asset Managers First Name],
m.LastName[Asset Managers Last Name],
a.assetname [Asset Name],
a.sitename[Asset Site Name],
l.county[Asset Location],
l.countycode[County Code]
from AssetRegistrations r

inner join AssetManagers m on m.Id = r.AssetManagersId
inner join Assets a on a.Id = r.AssetsId
inner join AssetLocations l on l.Id = r.AssetLocationsId
GO
/****** Object:  UserDefinedFunction [dbo].[reviewRange]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Function to return reviews between two values
-- =============================================
CREATE FUNCTION [dbo].[reviewRange]
(	
	-- Add the parameters for the function here
	@firstReview float, 
	@secondReview float
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT Review from AssetRegistrations
	where Review Between @firstReview and @secondReview 
)
GO
SET IDENTITY_INSERT [dbo].[AssetLocations] ON 

INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (1, N'Uppsala', 5, N'SW02')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (2, N'Stockholm', 7, N'SP01')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (3, N'Gävle', 1, N'FR02')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (4, N'Köping', 15, N'IT02')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (5, N'Malmö', 2, N'UK02')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (6, N'Finland', 3, N'SW02')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (7, N'NorrKöping', 5, N'NT01')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (8, N'Kiruna', 20, N'KR04')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (9, N'Ystad', 1, N'YT01')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (10, N'Västmannlan', 6, N'YT22')
INSERT [dbo].[AssetLocations] ([id], [county], [numberofassets], [countycode]) VALUES (11, N'Södermanlan', 5, N'ST01')
SET IDENTITY_INSERT [dbo].[AssetLocations] OFF
GO
SET IDENTITY_INSERT [dbo].[AssetManagers] ON 

INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (1, N'Kenneth                                           ', N'Okalang                                           ', CAST(N'2019-03-03' AS Date))
INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (2, N'Björn                                             ', N'Andersson                                         ', CAST(N'2022-02-02' AS Date))
INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (3, N'Alice                                             ', N'Björklund                                         ', CAST(N'1999-03-03' AS Date))
INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (4, N'Ann                                               ', N'Marie                                             ', CAST(N'1983-01-23' AS Date))
INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (5, N'Kacey                                             ', N'Ryan                                              ', CAST(N'2012-04-03' AS Date))
INSERT [dbo].[AssetManagers] ([Id], [FirstName], [LastName], [DateRegistered]) VALUES (6, N'Keisha                                            ', N'Umurungi                                          ', CAST(N'2008-07-29' AS Date))
SET IDENTITY_INSERT [dbo].[AssetManagers] OFF
GO
SET IDENTITY_INSERT [dbo].[AssetRegistrations] ON 

INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (4, 1, 3, 2, 5)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (5, 1, 3, 3, 4)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (13, 3, 4, 1, 10)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (18, 2, 6, 3, 1)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (19, 2, 3, 2, 2)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (20, 2, 4, 2, 5)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (21, 3, 9, 4, 8)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (22, 1, 3, 5, 2)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (23, NULL, 9, 6, NULL)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (24, NULL, 7, 3, NULL)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (25, NULL, 6, 4, NULL)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (26, NULL, 6, 4, NULL)
INSERT [dbo].[AssetRegistrations] ([Id], [AssetManagersId], [AssetsId], [AssetLocationsId], [Review]) VALUES (40, NULL, 4, 5, NULL)
SET IDENTITY_INSERT [dbo].[AssetRegistrations] OFF
GO
SET IDENTITY_INSERT [dbo].[Assets] ON 

INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (3, N'Solar Panels', N'Stockholm', 10, CAST(N'1999-05-30T00:00:00.000' AS DateTime), 970000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (4, N'Hydroelectric', N'Olden', 10, CAST(N'1965-01-15T00:00:00.000' AS DateTime), 654000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (6, N'Wind Turbines', N'Uppsala', 10, CAST(N'1989-01-15T00:00:00.000' AS DateTime), 6000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (7, N'Solar2', N'Kiruna', 10, CAST(N'1985-01-15T00:00:00.000' AS DateTime), 64000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (9, N'Geotherma4', N'Lund', 10, CAST(N'1981-01-15T00:00:00.000' AS DateTime), 54000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (18, N'Wind', N'testSite1', 12, CAST(N'2001-02-03T00:00:00.000' AS DateTime), 6700.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (19, N'Wind', N'testSite2', 50, CAST(N'2000-02-06T00:00:00.000' AS DateTime), 321000.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (20, N'Solar2', N'testSite3', 20, CAST(N'1999-03-04T00:00:00.000' AS DateTime), 2500.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (21, N'Hydroelectric', N'testsite6', 4, CAST(N'2002-03-03T00:00:00.000' AS DateTime), 500.0000)
INSERT [dbo].[Assets] ([id], [assetname], [sitename], [capacity], [datecreated], [revenue]) VALUES (22, N'Solar test', N'Boden', 8, CAST(N'2022-09-21T22:24:04.660' AS DateTime), 65000.0000)
SET IDENTITY_INSERT [dbo].[Assets] OFF
GO
ALTER TABLE [dbo].[AssetRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_Registrations_AssetManager] FOREIGN KEY([AssetManagersId])
REFERENCES [dbo].[AssetManagers] ([Id])
GO
ALTER TABLE [dbo].[AssetRegistrations] CHECK CONSTRAINT [FK_Registrations_AssetManager]
GO
ALTER TABLE [dbo].[AssetRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_Registrations_Assets] FOREIGN KEY([AssetsId])
REFERENCES [dbo].[Assets] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetRegistrations] CHECK CONSTRAINT [FK_Registrations_Assets]
GO
ALTER TABLE [dbo].[AssetRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_Registrations_Locations] FOREIGN KEY([AssetLocationsId])
REFERENCES [dbo].[AssetLocations] ([id])
GO
ALTER TABLE [dbo].[AssetRegistrations] CHECK CONSTRAINT [FK_Registrations_Locations]
GO
/****** Object:  StoredProcedure [dbo].[InsertAsset]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertAsset]
	-- Add the parameters for the stored procedure here
	@assetname nvarchar (50),
	@sitename nvarchar (50),
	@capacity int,
	@revenue money
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Assets (assetname,sitename,capacity,revenue,datecreated)
	VALUES
	(@assetname,@sitename,@capacity,@revenue,getdate())
END
GO
/****** Object:  StoredProcedure [dbo].[SelectAllAssets]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectAllAssets] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Assets;
END
GO
/****** Object:  StoredProcedure [dbo].[SelectAssetById]    Script Date: 22/09/2022 17:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectAssetById]
	-- Add the parameters for the stored procedure here
	 @id int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Assets where id = @id
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AssetLocations"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Assets"
            Begin Extent = 
               Top = 6
               Left = 249
               Bottom = 136
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AssetRegistrations"
            Begin Extent = 
               Top = 6
               Left = 457
               Bottom = 136
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Asset_Locations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Asset_Locations'
GO
USE [master]
GO
ALTER DATABASE [renewable_assets] SET  READ_WRITE 
GO
