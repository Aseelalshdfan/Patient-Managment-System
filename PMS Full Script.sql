USE [master]
GO
/****** Object:  Database [PatientManagementSystem]    Script Date: 2/5/2023 8:47:43 PM ******/
CREATE DATABASE [PatientManagementSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PatientManagmentSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PatientManagmentSystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PatientManagmentSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\PatientManagmentSystem_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PatientManagementSystem] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PatientManagementSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PatientManagementSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PatientManagementSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PatientManagementSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PatientManagementSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PatientManagementSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET RECOVERY FULL 
GO
ALTER DATABASE [PatientManagementSystem] SET  MULTI_USER 
GO
ALTER DATABASE [PatientManagementSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PatientManagementSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PatientManagementSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PatientManagementSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PatientManagementSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PatientManagementSystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PatientManagementSystem', N'ON'
GO
ALTER DATABASE [PatientManagementSystem] SET QUERY_STORE = OFF
GO
USE [PatientManagementSystem]
GO
/****** Object:  User [patientuser]    Script Date: 2/5/2023 8:47:44 PM ******/
CREATE USER [patientuser] FOR LOGIN [patientuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [patientuser]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GeneratePatientRegNo]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[fn_GeneratePatientRegNo]
(@FirstName varchar(30), @LastName VARCHAR(30) , @DOB DATETIME) 
RETURNS VARCHAR(30)
AS
BEGIN
		DECLARE @RegNumber VARCHAR(30)

		SET @RegNumber = CONCAT(
								LTRIM(RTRIM(LEFT(@FirstName,3))),
								LTRIM(RTRIM(RIGHT(@LastName,3))),
								CAST(DATEPART(MM,@DOB) AS VARCHAR(2)),
								CAST(DATEPART(DD,@DOB) AS VARCHAR(2))
								
								)
		RETURN @RegNumber
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetMedcineCost]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GetMedcineCost]
(
	@MedicineId INT
)
RETURNS DECIMAL(8,3)
AS
BEGIN
	DECLARE @Amount DECIMAL(8,3)
	SELECT @Amount = ( CASE WHEN MedicineDesc = 'Erthromycin' THEN 5.4
							WHEN MedicineDesc = 'Panadol Advance' THEN 2.5
							WHEN MedicineDesc = 'Decongestants' THEN 6
							WHEN MedicineDesc = 'Ibuprofen' THEN 11.25
							WHEN MedicineDesc = 'Doxydar' THEN 2.5
							WHEN MedicineDesc = 'differin' THEN 4.75
							WHEN MedicineDesc = 'adot suppstories vaccine ' THEN 5
							WHEN MedicineDesc = 'pethadine I.V ' THEN 10
							WHEN MedicineDesc = 'Voltarine' THEN 3.5
							WHEN MedicineDesc = 'Nexium' THEN 4
							WHEN MedicineDesc = 'Loratan' THEN 4.5
							WHEN MedicineDesc = 'Ibrix' THEN 10
							WHEN MedicineDesc = 'EPICOCILLIN VIAL 500MG' THEN 14
							WHEN MedicineDesc = 'Neosporin' THEN 7.641
							WHEN MedicineDesc = 'Clear Eyes' THEN 4.206
							WHEN MedicineDesc = 'Artemisinin' THEN 52.97
							WHEN MedicineDesc = 'GLUCAGON 10MG' THEN 15.47
							ELSE 0.00
							END)
	FROM dbo.Medicine
	WHERE MedicineId = @MedicineId

	RETURN @Amount

END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetStaffRole]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetStaffRole]
(@StaffID INT)
RETURNS VARCHAR(20)
AS
BEGIN
	 DECLARE @RoleDesc VARCHAR(20)

		SET @RoleDesc =  ( SELECT TOP 1 b.UserTypeDesc as RoleDesc 
				 FROM HospitalStaffs A 
				 JOIN UserType B 
					ON A.UserTypeId = B.UserTypeId
				 WHERE A.StaffId = @StaffID
				)
		RETURN @RoleDesc
END
GO
/****** Object:  Table [dbo].[HospitalStaffs]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HospitalStaffs](
	[StaffId] [int] IDENTITY(1,1) NOT NULL,
	[StaffAFullName] [nvarchar](200) NOT NULL,
	[StaffEFullName] [varchar](200) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[ContactNo] [char](12) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[DOB] [date] NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [char](1) NOT NULL,
	[SSN] [char](9) NOT NULL,
	[Salary] [decimal](15, 3) NOT NULL,
	[HireDate] [date] NOT NULL,
	[ClinicId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[UserTypeId] [int] NULL,
	[TrPlaceId] [int] NULL,
 CONSTRAINT [PK_HospitalStaffs_1] PRIMARY KEY CLUSTERED 
(
	[StaffId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[UserAFullName] [nvarchar](200) NOT NULL,
	[UserEFullName] [varchar](200) NOT NULL,
	[StaffId] [int] NULL,
	[UserTypeId] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitType]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitType](
	[VisitTypeId] [int] IDENTITY(1,1) NOT NULL,
	[VisitTypeDesc] [varchar](20) NOT NULL,
 CONSTRAINT [PK_VisitType] PRIMARY KEY CLUSTERED 
(
	[VisitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitDetails]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitDetails](
	[VisitId] [int] IDENTITY(1,1) NOT NULL,
	[VisitTypeId] [int] NULL,
	[VisitCreated] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NULL,
	[PatientId] [int] NULL,
	[VisitCreatedBy] [int] NULL,
	[StaffId] [int] NULL,
	[VisitRateId] [int] NULL,
	[ScheduleDay] [int] NULL,
	[VisitStatus] [int] NULL,
	[IsCome] [char](1) NULL,
 CONSTRAINT [PK_VisitDetails] PRIMARY KEY CLUSTERED 
(
	[VisitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clinics]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clinics](
	[ClinicId] [int] IDENTITY(1,1) NOT NULL,
	[ClinicDesc] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Clinics] PRIMARY KEY CLUSTERED 
(
	[ClinicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitRate]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitRate](
	[ViistRate] [int] NOT NULL,
	[VisitRateDesc] [nchar](10) NOT NULL,
 CONSTRAINT [PK_VisitRate] PRIMARY KEY CLUSTERED 
(
	[ViistRate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserType]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserType](
	[UserTypeId] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeDesc] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserType] PRIMARY KEY CLUSTERED 
(
	[UserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TreatmentPlace]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TreatmentPlace](
	[TrPlaceId] [int] IDENTITY(1,1) NOT NULL,
	[TrPlaceDesc] [varchar](50) NOT NULL,
	[PhoneNo] [char](12) NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_TreatmentPlace] PRIMARY KEY CLUSTERED 
(
	[TrPlaceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Diagnosis]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Diagnosis](
	[DiagnosisId] [int] IDENTITY(1,1) NOT NULL,
	[DiagDesc] [nvarchar](max) NOT NULL,
	[DiagDate] [date] NOT NULL,
	[DiagAmount] [decimal](5, 3) NULL,
	[VisitId] [int] NULL,
	[StaffId] [int] NULL,
 CONSTRAINT [PK_Diagnosis] PRIMARY KEY CLUSTERED 
(
	[DiagnosisId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[PatientId] [int] IDENTITY(1,1) NOT NULL,
	[PatientAFullName] [nvarchar](100) NOT NULL,
	[PatientEFullName] [varchar](100) NOT NULL,
	[CreatedBy] [int] NULL,
	[Address] [nvarchar](200) NOT NULL,
	[ContactNo] [char](12) NOT NULL,
	[DOB] [date] NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [char](1) NOT NULL,
	[NationalNo] [char](10) NOT NULL,
	[BloodGroup] [char](3) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[RelativeFullName] [nvarchar](100) NOT NULL,
	[RelativeContact] [char](12) NOT NULL,
	[MaritialStatus] [char](10) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED 
(
	[PatientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DoctorSchedule]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorSchedule](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[DoctorSDate] [date] NOT NULL,
	[DocSDays] [varchar](50) NOT NULL,
	[DocSStartTime] [datetime] NOT NULL,
	[DocSEndTime] [datetime] NOT NULL,
	[AvgCounsultingTime] [int] NOT NULL,
	[StaffId] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DoctorSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViistDetailsView]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[ViistDetailsView]
as
 select  p.PatientEFullName  as PatientName,
         u.UserEFullName  as UserName  ,
		 h.StaffEFullName  as DoctorName,
 v.VisitId,p.patientid,c.ClinicDesc,s.DocSDays,
 vt.VisitTypeDesc,vr.VisitRateDesc,p.Age,d.DiagDesc,tr.TrPlaceDesc , ut.UserTypeDesc
 from VisitDetails v 
left join VisitType vt on v.VisitTypeId = vt.VisitTypeId
left join VisitRate vr on v.VisitRateId = vr.ViistRate
left join patients p on v.PatientId = p.PatientId
left join HospitalStaffs h on v.StaffId = h.StaffId
left join Diagnosis d on d.VisitId = v.VisitId
left join TreatmentPlace tr on tr.TrPlaceId = h.TrPlaceId
left join Users u on u.UserId = v.VisitCreatedBy
left join UserType ut on u.UserTypeId = ut.UserTypeId
left join DoctorSchedule s on v.ScheduleDay = s.ScheduleId
left join Clinics c on c.ClinicId = h.ClinicId

 
 
GO
/****** Object:  View [dbo].[PatientDetailsView]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PatientDetailsView]
	as
	select p.PatientId , 
    p.PatientEFullName  as PatientName,
    u.UserEFullName  as 'Created By'  ,
    ut.UserTypeDesc,
   Address,ContactNo,DOB,Age,IIf(Gender = 'M','Male','Female') Gender,NationalNo,BloodGroup,Email,RelativeFullName,
   RelativeContact,MaritialStatus,p.IsActive
   from Patients p
   inner join Users u on p.CreatedBy = u.UserId
   inner join UserType ut on u.UserTypeId = ut.UserTypeId
GO
/****** Object:  Table [dbo].[DoctorSlot]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorSlot](
	[SlotId] [int] IDENTITY(1,1) NOT NULL,
	[StaffId] [int] NOT NULL,
	[StartSlot] [time](7) NOT NULL,
	[EndSlot] [time](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__DoctorSl__9C4B6B2B7B1B5B85] PRIMARY KEY CLUSTERED 
(
	[SlotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DoctorSloTAvailableTime]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create view [dbo].[DoctorSloTAvailableTime]
 as

 select staffEfullname,c.ClinicDesc,u.UserTypeDesc,Startslot, Endslot , d.staffid,d.IsActive
 from DoctorSlot d
 inner join HospitalStaffs h on h.StaffId = d.staffid 
 inner join clinics c on h.ClinicId = c.ClinicId
 inner join UserType u on u.UserTypeId = h.UserTypeId
 where d.IsActive = 1
GO
/****** Object:  View [dbo].[ScheduleDoctorListView]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[ScheduleDoctorListView]
as

select * 
from DoctorSchedule
GO
/****** Object:  Table [dbo].[ActionType]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionType](
	[ActionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ActionTypeDesc] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ActionType] PRIMARY KEY CLUSTERED 
(
	[ActionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArchiveVisitDetails]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArchiveVisitDetails](
	[VisitId] [int] NOT NULL,
	[VisitTypeId] [int] NULL,
	[VisitCreated] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NULL,
	[PatientId] [int] NULL,
	[VisitCreatedBy] [int] NULL,
	[StaffId] [int] NULL,
	[VisitRateId] [int] NULL,
	[ScheduleDay] [int] NULL,
	[VisitStatus] [int] NULL,
	[IsCome] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditTrailLog]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTrailLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditDescription] [varchar](max) NULL,
	[UserId] [int] NOT NULL,
	[AuditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AuditTrailLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[BillId] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[PayTypeId] [int] NULL,
	[VisitId] [int] NULL,
	[BillAmount] [decimal](10, 3) NOT NULL,
	[BillDate] [date] NOT NULL,
	[CreatedBy] [int] NULL,
 CONSTRAINT [PK_Bill] PRIMARY KEY CLUSTERED 
(
	[BillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataLog]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[RowId] [int] NOT NULL,
	[OldValue] [varchar](max) NULL,
	[NewValue] [varchar](max) NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionBy] [int] NOT NULL,
	[ActionTypeId] [int] NULL,
 CONSTRAINT [PK_DataLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeletedPatients]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletedPatients](
	[PatientId] [int] NOT NULL,
	[PatientAFullName] [nvarchar](100) NOT NULL,
	[PatientEFullName] [varchar](100) NOT NULL,
	[CreatedBy] [int] NULL,
	[Address] [nvarchar](200) NOT NULL,
	[ContactNo] [char](12) NOT NULL,
	[DOB] [date] NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [char](1) NOT NULL,
	[NationalNo] [char](10) NOT NULL,
	[BloodGroup] [char](3) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[RelativeFullName] [nvarchar](100) NOT NULL,
	[RelativeContact] [char](12) NOT NULL,
	[MaritialStatus] [char](10) NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeletedPatientsHistory]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletedPatientsHistory](
	[PatientId] [int] NULL,
	[PHistoryDesc] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorLocation] [varchar](max) NOT NULL,
	[ErrorDate] [datetime] NOT NULL,
	[ErrorUser] [int] NOT NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medication]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medication](
	[DiagnosisId] [int] NULL,
	[MedicineId] [int] NULL,
	[Quantity] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medicine]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicine](
	[MedicineId] [int] IDENTITY(1,1) NOT NULL,
	[MedicineDesc] [varchar](100) NOT NULL,
	[UnitPrice] [decimal](10, 3) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED 
(
	[MedicineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientHistory]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientHistory](
	[PatientId] [int] NULL,
	[PHistoryDesc] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentType]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentType](
	[PayTypeId] [int] IDENTITY(1,1) NOT NULL,
	[PayTypeDesc] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED 
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitStatus]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitStatus](
	[StatusId] [int] NOT NULL,
	[StatusDesc] [varchar](50) NULL,
 CONSTRAINT [PK_Visit Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_Patients] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patients] ([PatientId])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_Patients]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_PaymentType] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PaymentType] ([PayTypeId])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_PaymentType]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_Users]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_VisitDetails] FOREIGN KEY([VisitId])
REFERENCES [dbo].[VisitDetails] ([VisitId])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_VisitDetails]
GO
ALTER TABLE [dbo].[DataLog]  WITH CHECK ADD  CONSTRAINT [FK_DataLog_ActionType] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[DataLog] CHECK CONSTRAINT [FK_DataLog_ActionType]
GO
ALTER TABLE [dbo].[Diagnosis]  WITH CHECK ADD  CONSTRAINT [FK_Diagnosis_HospitalStaffs] FOREIGN KEY([StaffId])
REFERENCES [dbo].[HospitalStaffs] ([StaffId])
GO
ALTER TABLE [dbo].[Diagnosis] CHECK CONSTRAINT [FK_Diagnosis_HospitalStaffs]
GO
ALTER TABLE [dbo].[Diagnosis]  WITH CHECK ADD  CONSTRAINT [FK_Diagnosis_VisitDetails] FOREIGN KEY([VisitId])
REFERENCES [dbo].[VisitDetails] ([VisitId])
GO
ALTER TABLE [dbo].[Diagnosis] CHECK CONSTRAINT [FK_Diagnosis_VisitDetails]
GO
ALTER TABLE [dbo].[DoctorSlot]  WITH CHECK ADD  CONSTRAINT [FK_DoctorSlot_HospitalStaffs] FOREIGN KEY([StaffId])
REFERENCES [dbo].[HospitalStaffs] ([StaffId])
GO
ALTER TABLE [dbo].[DoctorSlot] CHECK CONSTRAINT [FK_DoctorSlot_HospitalStaffs]
GO
ALTER TABLE [dbo].[HospitalStaffs]  WITH CHECK ADD  CONSTRAINT [FK_HospitalStaffs_Clinics] FOREIGN KEY([ClinicId])
REFERENCES [dbo].[Clinics] ([ClinicId])
GO
ALTER TABLE [dbo].[HospitalStaffs] CHECK CONSTRAINT [FK_HospitalStaffs_Clinics]
GO
ALTER TABLE [dbo].[HospitalStaffs]  WITH CHECK ADD  CONSTRAINT [FK_HospitalStaffs_TreatmentPlace] FOREIGN KEY([TrPlaceId])
REFERENCES [dbo].[TreatmentPlace] ([TrPlaceId])
GO
ALTER TABLE [dbo].[HospitalStaffs] CHECK CONSTRAINT [FK_HospitalStaffs_TreatmentPlace]
GO
ALTER TABLE [dbo].[HospitalStaffs]  WITH CHECK ADD  CONSTRAINT [FK_HospitalStaffs_UserType] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[HospitalStaffs] CHECK CONSTRAINT [FK_HospitalStaffs_UserType]
GO
ALTER TABLE [dbo].[HospitalStaffs]  WITH CHECK ADD  CONSTRAINT [FK_HospitalStaffs_UserType1] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[HospitalStaffs] CHECK CONSTRAINT [FK_HospitalStaffs_UserType1]
GO
ALTER TABLE [dbo].[Medication]  WITH CHECK ADD  CONSTRAINT [FK_Medication_Diagnosis] FOREIGN KEY([DiagnosisId])
REFERENCES [dbo].[Diagnosis] ([DiagnosisId])
GO
ALTER TABLE [dbo].[Medication] CHECK CONSTRAINT [FK_Medication_Diagnosis]
GO
ALTER TABLE [dbo].[Medication]  WITH CHECK ADD  CONSTRAINT [FK_Medication_Medicine] FOREIGN KEY([MedicineId])
REFERENCES [dbo].[Medicine] ([MedicineId])
GO
ALTER TABLE [dbo].[Medication] CHECK CONSTRAINT [FK_Medication_Medicine]
GO
ALTER TABLE [dbo].[PatientHistory]  WITH CHECK ADD  CONSTRAINT [FK_PatientHistory_Patients] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patients] ([PatientId])
GO
ALTER TABLE [dbo].[PatientHistory] CHECK CONSTRAINT [FK_PatientHistory_Patients]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD  CONSTRAINT [FK_Patients_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Patients] CHECK CONSTRAINT [FK_Patients_Users]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_HospitalStaffs] FOREIGN KEY([StaffId])
REFERENCES [dbo].[HospitalStaffs] ([StaffId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_HospitalStaffs]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserType] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserType]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_DoctorSchedule] FOREIGN KEY([ScheduleDay])
REFERENCES [dbo].[DoctorSchedule] ([ScheduleId])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_DoctorSchedule]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_Patients] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patients] ([PatientId])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_Patients]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_Users] FOREIGN KEY([VisitCreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_Users]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_Visit Status] FOREIGN KEY([VisitStatus])
REFERENCES [dbo].[VisitStatus] ([StatusId])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_Visit Status]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_VisitRate] FOREIGN KEY([VisitRateId])
REFERENCES [dbo].[VisitRate] ([ViistRate])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_VisitRate]
GO
ALTER TABLE [dbo].[VisitDetails]  WITH CHECK ADD  CONSTRAINT [FK_VisitDetails_VisitType] FOREIGN KEY([VisitTypeId])
REFERENCES [dbo].[VisitType] ([VisitTypeId])
GO
ALTER TABLE [dbo].[VisitDetails] CHECK CONSTRAINT [FK_VisitDetails_VisitType]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [cannotEndAfter1600] CHECK  ((datepart(hour,dateadd(second,(1),[docsstarttime]))<(16)))
GO
ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [cannotEndAfter1600]
GO
ALTER TABLE [dbo].[DoctorSchedule]  WITH CHECK ADD  CONSTRAINT [cannotStartBefore0900] CHECK  ((datepart(hour,[docsstarttime])>=(9)))
GO
ALTER TABLE [dbo].[DoctorSchedule] CHECK CONSTRAINT [cannotStartBefore0900]
GO
/****** Object:  StoredProcedure [dbo].[DeactiveHospitalStaff]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeactiveHospitalStaff]
	@staffid int
	as
	begin
	
	    update HospitalStaffs
		set  IsActive= 0
		where StaffId = @staffid
		end 
GO
/****** Object:  StoredProcedure [dbo].[DeactiveScheduleDoctor]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeactiveScheduleDoctor]
	@SchedId int
	as
	begin
	
	    update DoctorSchedule
		set  IsActive= 0
		where ScheduleId = @SchedId
		end 
GO
/****** Object:  StoredProcedure [dbo].[DeactiveUser]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[DeactiveUser]
	@UserId int
	as
	begin
	
	    update Users
		set  IsActive= 0
		where userid = @UserId
		end 
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddTimeSlot]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_AddTimeSlot]
@scheduleid int,
@userid int,
@errormessage varchar(max) out
AS
begin
begin transaction
begin try
declare @StartSlot datetime, @EndSlot datetime, @NumberOfSlots int, @AvgConsultationTime int,@StaffId int, @I int

select @staffid = staffid from DoctorSchedule where ScheduleId = @scheduleid
select @StartSlot = docsstarttime from DoctorSchedule where ScheduleId = @scheduleid
select @EndSlot = docsendtime from DoctorSchedule where ScheduleId = @scheduleid
select @AvgConsultationTime = AvgCounsultingTime  from DoctorSchedule where ScheduleId = @scheduleid

set @NumberOfSlots = convert(int,(DATEDIFF(MINUTE,@StartSlot , @EndSlot) )) / @AvgConsultationTime

set @I = 0
while @i< @NumberOfSlots
begin

 set @EndSlot = convert(int,dateadd(minute,@AvgConsultationTime,@StartSlot))
     insert into DoctorSlot (startslot,endslot,staffid,IsActive)
	 values (@StartSlot,@EndSlot,@StaffId,1)
	 set @StartSlot = @EndSlot
	 set @I = @I +1
	 end
	  commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_ArchiveVisitDetails]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_ArchiveVisitDetails]
@visitid int ,
@userid int,
@errormessage varchar(max) out
as
begin

    begin transaction
        begin try

            -- insert into data log
            insert into DataLog
            (TableName,RowID,ActionBy,ActionDate,ActionTypeId)
            select 
			'VisitDetails',visitid,
            0,GETDATE(),4
            from VisitDetails
            where VisitId = @visitid
			

            insert into ArchiveVisitDetails (VisitId,VisitTypeId,VisitCreated,StartTime,EndTime,PatientId,VisitCreatedBy,StaffId,VisitRateId,ScheduleDay,visitstatus,IsCome)
            SELECT VisitId,VisitTypeId,VisitCreated,StartTime,EndTime,PatientId,VisitCreatedBy,StaffId,VisitRateId,ScheduleDay,VisitStatus,IsCome
            from VisitDetails
            where visitid = @visitid


            delete from VisitDetails
              where visitid = @visitid

            -- insert into Audit trail log
            insert into AuditTrailLog
            (AuditDescription,AuditDate,UserID)             
            select 'Archive visit ID= '+cast(VisitId as nvarchar), GETDATE(),0
            from VisitDetails
             where visitid = @visitid

            commit transaction
        end try
        begin catch

            rollback transaction

            insert into ErrorLog
            (ErrorLocation,ErrorMessage,ErrorDate,ErrorUser)
            values
            (ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE(),0)

        end catch

end
GO
/****** Object:  StoredProcedure [dbo].[SP_AvailableDocSlot]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AvailableDocSlot]

@staffid int
as
begin

select startslot,endslot,IsActive
from DoctorSlot
where IsActive = 1 and staffid = @staffid
end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteAllCancelVisits]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_DeleteAllCancelVisits]
 @userid int,
 @ErrorMessage varchar(max) out

 as
 begin

begin transaction
begin try


   insert into DataLog
    (TableName,RowId,ActionBy,ActionDate,ActionTypeId)
    values
    ('VisitDetails',0,@UserId,GETDATE(),3)


    delete from VisitDetails
    where VisitStatus = 2


   insert into AuditTrailLog
    (AuditDescription,AuditDate,UserId)
    values
    ('Delete Cancel Visits from Visit details table ', GETDATE(),@UserId)

   commit transaction;
   end try

begin catch
    rollback ;
    
    insert into ErrorLog
    (ErrorLocation,ErrorMessage,ErrorDate,ErrorUser)
    values
    (ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE(),@UserId)

   set @ErrorMessage = ERROR_MESSAGE()

  end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeletePatients]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_DeletePatients]
@Patientid int,
@UserId int,
@ErrorMessage varchar(max)
as
begin

begin transaction
begin try

   insert into DeletedPatients
    select * from Patients
    where PatientId = @Patientid

   insert into DeletedPatientsHistory
    select * from PatientHistory
    where PatientId = @Patientid

   insert into DataLog
    (TableName,RowId,ActionBy,ActionDate,ActionTypeId)
    values
    ('PatientHistory',@Patientid,@UserId,GETDATE(),3)

   insert into DataLog
    (TableName,RowId,ActionBy,ActionDate,ActionTypeId)
    values
    ('Patients',@Patientid,@UserId,GETDATE(),3)

    delete from PatientHistory
    where PatientId = @Patientid

    delete from Patients
        where PatientId = @Patientid


   insert into AuditTrailLog
    (AuditDescription,AuditDate,UserId)
    values
    ('Delete Transaction from transactions table with ID: '+ CAST(@Patientid as varchar(5)),
    GETDATE(),@UserId)

   commit transaction;
   end try

begin catch
    rollback ;
    
    insert into ErrorLog
    (ErrorLocation,ErrorMessage,ErrorDate,ErrorUser)
    values
    (ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE(),@UserId)

   set @ErrorMessage = ERROR_MESSAGE()

  end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllPatientsHistory]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE Procedure [dbo].[SP_GetAllPatientsHistory]

   @LangIndicator char(2)
   as
   begin
   select p.PatientId , 
   case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
      case when @LangIndicator = 'AR' then h.StaffAFullName when @LangIndicator = 'EN' then h.StaffEFullName END as DoctorName,
   p.Age,IIf(p.Gender = 'M','Male','Female') Gender,d.DiagDesc,c.ClinicDesc
   from VisitDetails v 
left join VisitType vt on v.VisitTypeId = vt.VisitTypeId
left join VisitRate vr on v.VisitRateId = vr.ViistRate
left join patients p on v.PatientId = p.PatientId
left join HospitalStaffs h on v.StaffId = h.StaffId
left join Diagnosis d on d.VisitId = v.VisitId
left join TreatmentPlace tr on tr.TrPlaceId = h.TrPlaceId
left join Users u on u.UserId = v.VisitCreatedBy
left join DoctorSchedule s on v.ScheduleDay = s.ScheduleId
left join Clinics c on c.ClinicId = h.ClinicId
 order by p.PatientId   
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllPatientsInfo]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllPatientsInfo]

  @LangIndicator char(2)
   as
   begin

   select p.PatientId , 
   case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
   case when @LangIndicator = 'AR' then u.UserAFullName when @LangIndicator = 'EN' then u.UserEFullName END as 'Created By'  ,
   ut.UserTypeDesc,
   Address,ContactNo,DOB,Age,IIf(Gender = 'M','Male','Female') Gender,NationalNo,BloodGroup,Email,RelativeFullName,
   RelativeContact,MaritialStatus,p.IsActive
   from Patients p
   inner join Users u on p.CreatedBy = u.UserId
   inner join UserType ut on u.UserTypeId = ut.UserTypeId

   End
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllPatientsInfoHistory]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllPatientsInfoHistory] 

  @LangIndicator char(2)
   as
   begin
   
   select p.PatientId , 
   case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
   case when @LangIndicator = 'AR' then u.UserAFullName when @LangIndicator = 'EN' then u.UserEFullName END as UserName  ,
   ut.UserTypeDesc,ph.phistorydesc,
   Address,ContactNo,DOB,Age,IIf(Gender = 'M','Male','Female') Gender,NationalNo,BloodGroup,Email,RelativeFullName,
   RelativeContact,MaritialStatus,p.IsActive
   from Patients p
   inner join patienthistory ph on p.patientid = ph.patientid
  inner join Users u on p.CreatedBy = u.UserId
  inner join UserType ut on u.UserTypeId = ut.UserTypeId
  order by p.patientid
 
  
 
   End
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllPatientsInfoHistorybyID]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetAllPatientsInfoHistorybyID] 
  @patientId int,
  @LangIndicator char(2)
   as
   begin
   
   select p.PatientId , 
   case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
   case when @LangIndicator = 'AR' then u.UserAFullName when @LangIndicator = 'EN' then u.UserEFullName END as UserName  ,
   ut.UserTypeDesc,ph.phistorydesc,p.IsActive
   from Patients p
   inner join patienthistory ph on p.patientid = ph.patientid
  inner join Users u on p.CreatedBy = u.UserId
  inner join UserType ut on u.UserTypeId = ut.UserTypeId
  where p.patientid = @patientid
  order by p.patientid
 
  
   End
GO
/****** Object:  StoredProcedure [dbo].[SP_GetHighestPatBill]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create procedure [dbo].[SP_GetHighestPatBill]
 as
 begin
 select  sum (billamount) amount ,p.PatientAFullName,v.PatientId,VisitTypeId
 from bill b 
 inner join visitdetails v on v.visitid = b.visitid
 inner join patients p on b.patientid = p.patientid
 where v.VisitTypeId = 2
 group by p.PatientAFullName,v.PatientId,VisitTypeId
having sum (billamount) = 
 (select top 1 sum (billamount) amount
 from bill b
 inner join visitdetails v on v.visitid = b.visitid
 where VisitTypeId = 2
 group by v.PatientId
 order by 1 desc)

 union

 select  sum (billamount) amount ,p.PatientAFullName,v.PatientId,VisitTypeId
 from bill b 
 inner join visitdetails v on v.visitid = b.visitid
 inner join patients p on b.patientid = p.patientid
 where v.VisitTypeId = 1
 group by p.PatientAFullName,v.PatientId,VisitTypeId
having sum (billamount) = 
 (select top 1 sum (billamount) amount
 from bill b
 inner join visitdetails v on v.visitid = b.visitid
 where VisitTypeId = 1
 group by v.PatientId
 order by 1 desc)
 end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPatientCntByRange]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetPatientCntByRange]
as
begin
 SELECT count(*) as PatientCNT, * 
 FROM 
(
select 
  case
  when age  between 1 and 10 then '1-10'
  when age  between 11 and 18 then '11-18'
  when age  between 19 and 25 then '19-25'
  when  age  between 26 and 36 then '26-36'
  when  age  between 37 and 48 then '37-48'
  when  age  between 49 and 60 then '49-60'
  when  age > 60 then 'Upper 60'
 END as Agerange 

 from Patients
) t
group by Agerange 
order by Agerange

end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPatientHistoryByPatId]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetPatientHistoryByPatId]
@patientid int,
@LangIndicator char(2)
as
begin

 select case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
        case when @LangIndicator = 'AR' then u.UserAFullName when @LangIndicator = 'EN' then u.UserEFullName END as UserName  ,
		case when @LangIndicator = 'AR' then h.StaffAFullName when @LangIndicator = 'EN' then h.StaffEFullName END as DoctorName,
 v.VisitId,p.patientid,c.ClinicDesc,isnull(s.DocSDays,'-') DocSDays,
 vt.VisitTypeDesc,vr.VisitRateDesc,isnull(vs.StatusDesc,'-') StatusDesc ,p.Age,d.DiagDesc,tr.TrPlaceDesc , ut.UserTypeDesc,
 v.StartTime,v.EndTime,
 v.VisitCreated
 from VisitDetails v 
left join VisitStatus vs on v.VisitStatus = vs.StatusId 
left join VisitType vt on v.VisitTypeId = vt.VisitTypeId
left join VisitRate vr on v.VisitRateId = vr.ViistRate
left join patients p on v.PatientId = p.PatientId
left join HospitalStaffs h on v.StaffId = h.StaffId
left join Diagnosis d on d.VisitId = v.VisitId
left join TreatmentPlace tr on tr.TrPlaceId = h.TrPlaceId
left join Users u on u.UserId = v.VisitCreatedBy
left join UserType ut on u.UserTypeId = ut.UserTypeId
left join DoctorSchedule s on v.ScheduleDay = s.ScheduleId
left join Clinics c on c.ClinicId = h.ClinicId
where v.PatientId = @patientid 
 order by p.PatientId        
 end

GO
/****** Object:  StoredProcedure [dbo].[SP_GetPatientsVisitDetails]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetPatientsVisitDetails]

@LangIndicator char(2)
as
begin

 select case when @LangIndicator = 'AR' then p.PatientAFullName when @LangIndicator = 'EN' then p.PatientEFullName END as PatientName,
        case when @LangIndicator = 'AR' then u.UserAFullName when @LangIndicator = 'EN' then u.UserEFullName END as UserName  ,
		case when @LangIndicator = 'AR' then h.StaffAFullName when @LangIndicator = 'EN' then h.StaffEFullName END as DoctorName,
 v.VisitId,p.patientid,c.ClinicDesc,s.DocSDays,
 vt.VisitTypeDesc,vr.VisitRateDesc,v.visitstatus,p.Age,d.DiagDesc,d.History,tr.TrPlaceDesc , ut.UserTypeDesc
 from VisitDetails v 
-- left join [Visit Status]
left join VisitType vt on v.VisitTypeId = vt.VisitTypeId
left join VisitRate vr on v.VisitRateId = vr.ViistRate
left join patients p on v.PatientId = p.PatientId
left join HospitalStaffs h on v.StaffId = h.StaffId
left join Diagnosis d on d.VisitId = v.VisitId
left join TreatmentPlace tr on tr.TrPlaceId = h.TrPlaceId
left join Users u on u.UserId = v.VisitCreatedBy
left join UserType ut on u.UserTypeId = ut.UserTypeId
left join DoctorSchedule s on v.ScheduleDay = s.ScheduleId
left join Clinics c on c.ClinicId = h.ClinicId
 order by p.PatientId        

 end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTotalMedcinePrice]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_GetTotalMedcinePrice]
		as
		begin

		select v.PatientId , sum(e.Quantity * m.UnitPrice ) totalprice
		from Medication e
		inner join Medicine m  on m.MedicineId = e.MedicineId 
		inner join Diagnosis d on d.DiagnosisId = e.DiagnosisId
		inner join VisitDetails v on d.VisitId = v.VisitId
		group by v.PatientId 
		end
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTotalMedcinePriceByPatID]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_GetTotalMedcinePriceByPatID]
		@patientid int
		as
		begin

		select v.PatientId , sum(e.Quantity * m.UnitPrice ) TotalPrice
		from Medication e
		inner join Medicine m  on m.MedicineId = e.MedicineId 
		inner join Diagnosis d on d.DiagnosisId = e.DiagnosisId
		inner join VisitDetails v on d.VisitId = v.VisitId
		where v.PatientId = @patientid
		group by v.PatientId 
		end
GO
/****** Object:  StoredProcedure [dbo].[SP_InserNewStaff]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE procedure [dbo].[SP_InserNewStaff]
	@StaffAFullName nvarchar(200),
	@StaffEFullName varchar(200),
	@Email varchar(200),
	@ContactNo char(12),
	@Address nvarchar(200),
	@DOB date,
	@Age int,
	@Gender char(1),
	@SSN char(9),
	@Salary decimal(15,3),
	@ClinicId int = null,
	@UserTypeId int,
	@TrPlaceid int,
	@UserId int = null,
	@ErrorMessage varchar(max) out
	as
	begin
	begin transaction
	begin try

	insert into HospitalStaffs (StaffAFullName,StaffEFullName,Email,ContactNo,Address,DOB,Age,Gender,SSN,Salary,HireDate,ClinicId,UserTypeId,
	                            TrPlaceId,IsActive)
                     values (@StaffAFullName,@StaffEFullName,@Email,@ContactNo,@Address,@DOB,@Age,@Gender,@SSN,@Salary,getdate(),@ClinicId,
					         @UserTypeId,@TrPlaceid,1)

insert into DataLog (TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
values ('HospitalStaffs',IDENT_CURRENT('HospitalStaffs'),'','StaffAFullName:'+@StaffAFullName+',StaffEFullName:'+@StaffEFullName
 +'Email:'+@Email+',ContactNo:'+@ContactNo+',Address:'+@Address+',DOB:'+cast(@DOB as varchar(10))+',Age:'+cast(@Age as varchar(5))+',
 Gender:'+@Gender+',SSN:'+@SSN+',salary:'+cast(@Salary as varchar(15))+',ClinicId:'+cast(@clinicid as varchar(5))+',	
 UserTypeId:'+cast(@usertypeid as varchar(5))+',TrPlaceId:'+cast(@TrPlaceid as varchar(5))+',IsActive:1',GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new Staff with Id:' + cast(IDENT_CURRENT('HospitalStaffs') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[Sp_InsertDoctorSchedule]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create procedure [dbo].[Sp_InsertDoctorSchedule]
	 @DocSDays varchar(50),
     @DocSStartTime varchar(100),
	 @DocSEndTime varchar(100),
	 @AvgConsultingTime int,
	 @StaffId int,
	 @UserId int,
	 @ErrorMessage varchar(max) out
	as 
	begin
	begin transaction
	begin try


            insert into DoctorSchedule (DoctorSDate,DocSDays,DocSStartTime,DocSEndTime,AvgCounsultingTime,StaffId,IsActive)
			            values ( getdate(),@DocSDays,@DocSStartTime,@DocSEndTime,@AvgConsultingTime,@StaffId,1)

		   insert into DataLog (TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('DoctorSchedule',IDENT_CURRENT('DoctorSchedule'),'','DocSDays:'+@DocSDays+',DocSStartTime:'+@DocSStartTime+',
		   DocSEndTime:'+@DocSEndTime+', AvgConsultingTime:'+cast (@AvgConsultingTime as varchar(10))+',
		   StaffId:'+cast(@StaffId as varchar(5)),GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new DoctorSchedule with Id:' + cast(IDENT_CURRENT('DoctorSchedule') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewBill]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewBill]
     
	 @PatientId int,
	 @PayTypeId int,
	 @VisitId int,
	 @BillAmount decimal(15,3),
	 @CreatedBy int,
	 @UserId int,
	 @ErrorMessage varchar(max) out 
	as 
	begin
	begin transaction
	begin try


            insert into Bill (PatientId,PayTypeId,VisitId,BillAmount,BillDate,CreatedBy)
			values (@PatientId,@PayTypeId,@VisitId,@BillAmount,Getdate(),@CreatedBy)

		   insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('Bill',IDENT_CURRENT('Bill'),'','PatientId:'+cast(@patientid as varchar(5))+',
		   PayTypeId:'+cast(@PayTypeId as varchar(5))+',VisitId:'+cast(@VisitId as varchar(5))+'
		  BillAmount:'+cast(@BillAmount as varchar(15))+'CreatedBy:'+cast(@createdby as varchar(5)),GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new Bill with Id:' + cast(IDENT_CURRENT('Bill') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewDiagnosis]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewDiagnosis]
	@DiagDesc nvarchar(500),
	@history varchar(max),
	@DiagAmount decimal (15,3) = null,
	@visitId int,
	@StaffId int,
	@Userid int,
	@ErrorMessage varchar(max)  out 

	as 
	begin
	begin transaction
	begin try


            insert into Diagnosis (DiagDesc,History,DiagDate,DiagAmount,VisitId,StaffId)
			values (@DiagDesc,@history,getdate(),@DiagAmount,@visitId,@StaffId)

		   insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('Diagnosis',IDENT_CURRENT('Diagnosis'),'','DiagDesc:'+@DiagDesc+',DiagAmount:'+
		   cast (@DiagAmount as varchar(15))+',VisitId:'+cast(@visitid as varchar(5))+',StaffId:'+cast(@StaffId as varchar(5))+',
		   history:'+@history,
		   GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new Diagnosis with Id:' + cast(IDENT_CURRENT('Diagnosis') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewMediciation]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_InsertNewMediciation]
     @DiagnosisId int ,
	 @MedicineId int,
	 @Quantity int,
	 @UserId int,
	 @ErrorMessage varchar(max) out

	 as 
	begin
	begin transaction
	begin try


            insert into Medication (DiagnosisId,MedicineId,Quantity)
			values (@DiagnosisId,@MedicineId,@Quantity)

		   insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           select 'Medication',@DiagnosisId,'','DiagnosisId:'+cast( @DiagnosisId as varchar(5))+'MedicineId:'+cast( @MedicineId as varchar(5))+'
		   ,Quantity:'+cast(@Quantity as varchar(5)) ,GETDATE(),1,@UserId
		   from Diagnosis
		   where DiagnosisId = @DiagnosisId

           insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
           select 'Insert new Medication for Diagnosis with id :'+cast( @DiagnosisId as varchar(5)) ,GETDATE(),@UserId
	       from Diagnosis
	       where DiagnosisId = @DiagnosisId

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewMedicine]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewMedicine]

	   @MedicineDesc varchar(500),
	   @UnitPrice decimal (10,3),
	   @UserId int,
	   @ErrorMessage varchar(max) out 
	   
	as
	begin
	begin transaction
	begin try
	         

			 insert into Medicine ( MedicineDesc,UnitPrice,IsActive)
			 values (@MedicineDesc,@UnitPrice,1)


			 insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('Medicine',IDENT_CURRENT('Medicine'),'','MedicineDesc:'+@MedicineDesc+',UnitPrice:'+cast(@UnitPrice as varchar(15)),
		   GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new Medcine with Id:' + cast(IDENT_CURRENT('Medcine') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewPatient]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewPatient]
	@PatientAFullName nvarchar(200),
	@PatientEFullName varchar(200),
	@Address nvarchar(500),
	@ContactNo char(12),
	@DOB date,
	@Age int,
	@Gender char(1),
	@NationalNo char(10),
	@BloodGroup char(3),
	@Email varchar(200),
	@RelativeFullName nvarchar(200),
	@RelativeContact char(12),
	@MaritialStatus char(10),
	@CreatedBy int ,
	@userid int,
	@ErrorMessage varchar(max) out

	as
	begin
	begin transaction
	begin try

	insert into Patients (PatientAFullName,PatientEFullName,[Address],ContactNo,DOB,Age,Gender,NationalNo,BloodGroup,Email,RelativeFullName,
	                       RelativeContact,MaritialStatus,createdby,IsActive)
                values ( @PatientAFullName,@PatientEFullName,@Address,@ContactNo,@DOB,@Age,@Gender,@NationalNo,@BloodGroup,@Email,
				        @RelativeFullName,@RelativeContact,@MaritialStatus,@CreatedBy,1)

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('Patients',IDENT_CURRENT('Patients'),'','PatientAFullName: '+@PatientAFullName+',PatientEFullName:'+@PatientEFullName
		   +'Address:'+@Address+',ContactNo:'+@ContactNo+',DOB:'+cast(@DOB as varchar(10))+',Age:'+cast(@Age as varchar(5))+', Gender:'+@Gender+'
		  ,NationalNo:'+@NationalNo+',BloodGroup:'+@BloodGroup+',Email:'+@Email+', RelativeFullName:'+@RelativeFullName+',RelativeContact:
		  '+@RelativeContact+',MaritialStatus:'+@MaritialStatus+',CreatedBy:'+cast(@CreatedBy as varchar(5))
		   ,GETDATE(),1,@userid)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new Patient with Id:' + cast(IDENT_CURRENT('Patients') as varchar(5)),GETDATE(),@userid)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewUser]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewUser]
@UserName varchar(50),
@Password varchar(50),
@UserAFullName nvarchar(200),
@UserEFullName varchar(200),
@StaffId int = null,
@UserTypeId int,
@UserId int = null,
@ErrorMessage varchar(max) out
as
begin
begin transaction
begin try

    insert into Users(UserName,Password,UserAFullName,UserEFullName,StaffId,UserTypeId,IsActive)
                   values(@UserName,@Password,@UserAFullName,@UserEFullName,@StaffId,@UserTypeId,1)

    insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('Users',IDENT_CURRENT('Users'),'','UserName: '+@UserName+',Password:'+@Password+',
		   UserAFullName: '+@UserAFullName+'  ,UserEFullName: '+@UserEFullName+' ,StaffId: '+cast(@StaffId as varchar(5))+',
		   UserTypeId: '+cast(@UserTypeId as varchar(5)),GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new User with Id:' + cast(IDENT_CURRENT('Users') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertNewVisit]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_InsertNewVisit]


	@StartTime time,
	@EndTime time = null,
	@PatientId int,
	@VisitTypeId int,
	@StaffId int ,
	@VisitRateId int,
	@VisitCreatedBy int,
	@Scheduleday int = null,
	@visitstatus int = null,
	@UserId int,
	@ErrorMessage varchar(max) out 

	
	as 
	begin
	begin transaction
	begin try


            insert into VisitDetails (VisitCreated,StartTime,EndTime,PatientId,VisitTypeId,VisitCreatedBy,StaffId,VisitRateId,Scheduleday,VisitStatus)
			values (Getdate(),@StartTime,@EndTime,@PatientId,@VisitTypeId,@visitcreatedby,@StaffId,@VisitRateId,@Scheduleday,@visitstatus)

		   insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('VisitDetails',IDENT_CURRENT('VisitDetails'),'','
		   StartTime:'+cast(@StartTime as varchar(15))+',EndTime:'+cast(@EndTime as varchar(15))+',PatientId:'+cast(@PatientId as varchar(5))+'
		   VisitTypeId:'+cast(@visittypeid as varchar(5))+',StaffId:'+cast(@StaffId as varchar(5))+',
		   VisitCreatedBy:'+cast(@VisitCreatedBy as varchar(5))+',
		   VisitRateId:'+cast(@VisitRateId as varchar (5))+',Scheduleday:'+ cast (@Scheduleday as varchar(5))+',visitstatus:'+ cast (@visitstatus as varchar(5))	
		   ,GETDATE(),1,@UserId)

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    values ('Insert new visit with Id:' + cast(IDENT_CURRENT('VisitDetails') as varchar(5)),GETDATE(),@UserId)

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[Sp_InsertPatientHistory]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create procedure [dbo].[Sp_InsertPatientHistory]
	 @PatientId int,
	 @PHistoryDesc nvarchar(max),
	 @UserId int,
	 @ErrorMessage varchar(max) out
	as 
	begin
	begin transaction
	begin try


            insert into PatientHistory(PatientId,PHistoryDesc)
			select @PatientId, @PHistoryDesc
			from Patients
			where PatientId = @PatientId

		   insert into DataLog (TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
        select 'PatientHistory',IDENT_CURRENT('patients'),'','PatientId:'+cast(@PatientId as varchar(5))+',PHistoryDesc:'+@PHistoryDesc,
		GETDATE(),1,@UserId
		from Patients
		where PatientId = @PatientId

    insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
    select 'Insert PatientHistory with Id:' + cast(IDENT_CURRENT('Patients') as varchar(5)),GETDATE(),@UserId
	from Patients
    where PatientId = @PatientId

	 commit transaction;
	 end try

	 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_MakeTimeSlotAvailableAgain]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_MakeTimeSlotAvailableAgain]
		@staffid int,
		@starttime time,
		@userid int,
		@errormessage varchar(max) out
		as
		begin
		begin transaction 
        begin try
		if ((select top 1 iscome from VisitDetails where StartTime = @starttime and VisitTypeId = 2 and staffid = @staffid) ='Y')
         begin
		update DoctorSlot
		set IsActive = 1
		where startslot = @starttime and staffid = @staffid
		end 
		else 
		begin
		select ' The Patient did not complete his visit yet' as Message
		end
        commit transaction
        end try
     begin catch
	 rollback;
	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();
	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_MostFrequenTPatientCNT]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_MostFrequenTPatientCNT]
  as
  begin

  select  count (*) as CNT ,v.PatientId,p.PatientEFullName,vt.VisitTypeDesc
				  from VisitDetails v
				  inner join VisitType vt on v.VisitTypeId = vt.VisitTypeId
				  inner join Patients p on  p.PatientId = v.PatientId
				  where v.VisitTypeId =1
				  group by v.PatientId,p.PatientEFullName,vt.VisitTypeDesc
		having 	count (*) = 	  
		 (select top 1 count (*) 
				  from VisitDetails 
				  where VisitTypeId =1
				  group by PatientId
				  order by 1 desc)

union

select  count (*) as CNT ,v.PatientId,p.PatientEFullName,vt.VisitTypeDesc
				  from VisitDetails v
				  inner join VisitType vt on v.VisitTypeId = vt.VisitTypeId
				  inner join Patients p on  p.PatientId = v.PatientId
				  where v.VisitTypeId =2
				  group by v.PatientId,p.PatientEFullName,vt.VisitTypeDesc
		having 	count (*) = 	  
		 (select top 1 count (*) 
				  from VisitDetails 
				  where VisitTypeId =2
				  group by PatientId
				  order by 1 desc)

 end 
GO
/****** Object:  StoredProcedure [dbo].[SP_OutPatVisitBook]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_OutPatVisitBook]
@Starttime time,
@patientid int,
@visitcreatedby int,
@scheduleday int ,
@visitrate int = null,
@visitstatus int,
@staffid int,
@userid int,
@errormessage varchar(max) out
as
begin
begin transaction 
begin try
if ((select top 1 IsActive from DoctorSlot where startslot = @Starttime  ) = 1)
begin

 insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
           values('VisitDetails',IDENT_CURRENT('VisitDetails'),'','
		   StartTime:'+cast(@StartTime as varchar(15))+',PatientId:'+cast(@PatientId as varchar(5))+'
		   ,StaffId:'+cast(@StaffId as varchar(5))+',
		   VisitCreatedBy:'+cast(@VisitCreatedBy as varchar(5))+',
		   VisitRateId:'+cast(@visitrate as varchar (5))+',Scheduleday:'+ cast (@Scheduleday as varchar(5))+',visitstatus:'+ cast (@visitstatus as varchar(5))	
		   ,GETDATE(),1,@UserId)

insert into visitdetails (StartTime,StaffId,VisitTypeId,EndTime,PatientId,VisitCreatedBy,ScheduleDay,VisitRateId,VisitStatus,VisitCreated)
values( @Starttime,@staffid,2,null,@patientid,@visitcreatedby,@scheduleday,@visitrate,@visitstatus,getdate())

update DoctorSlot 
set IsActive = 0
where startslot =@Starttime and @staffid = staffid

end
else 
begin

select 'Doctor Time Slot is already booked' as error
end
commit transaction
end try
 begin catch
	 rollback;

	 insert into ErrorLog (ErrorMessage,ErrorDate,ErrorLocation,ErrorUser)
	 values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)
	 select @ErrorMessage = ERROR_MESSAGE();

	end catch
    end
GO
/****** Object:  StoredProcedure [dbo].[SP_PatientToDoctorReviews]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_PatientToDoctorReviews]
 as
begin
 select patientefullname , staffEfullname,ClinicDesc ,VisitRateDesc
 from visitdetails  v
  inner join visitrate r on r.ViistRate = v.visitrateid
 inner join HospitalStaffs h on h.staffid = v.staffid
 inner join Clinics c on c.ClinicId = h.ClinicId
 inner join patients p on v.patientid = p.patientid
 order by ClinicDesc

 end
GO
/****** Object:  StoredProcedure [dbo].[SP_ReturnPatientsFromDeleted]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_ReturnPatientsFromDeleted]
@Patientid int,
@UserId int,
@ErrorMessage varchar(max)
as
begin

begin transaction
begin try

--1
 insert into DataLog
    (TableName,RowId,ActionBy,ActionDate,ActionTypeId)
    values
    ('DeletedPatients',@Patientid,@UserId,GETDATE(),5)
	select * from Patients
	 
--2
SET identity_insert patients ON
    insert into Patients(PatientId,PatientAFullName,PatientEFullName,CreatedBy,Address,ContactNo,DOB,Age,Gender,NationalNo,BloodGroup,Email
	,RelativeFullName,RelativeContact,MaritialStatus,IsActive)
    select PatientId,PatientAFullName,PatientEFullName,CreatedBy,Address,ContactNo,DOB,Age,Gender,NationalNo,BloodGroup,Email
	,RelativeFullName,RelativeContact,MaritialStatus,IsActive
	from DeletedPatients
    where Patientid = @Patientid
SET identity_insert patients OFF


  insert into PatientHistory (PatientId,PHistoryDesc)
  select PatientId,PHistoryDesc from DeletedPatientsHistory
    where Patientid = @Patientid
  

	delete from DeletedPatients
    where Patientid = @Patientid

	delete from DeletedPatientsHistory
    where Patientid = @Patientid


   insert into AuditTrailLog
    (AuditDescription,AuditDate,UserId)
    values
    ('Retrive Transaction data with ID: '+ CAST(@Patientid as varchar(5)), GETDATE(),@UserId)
   commit transaction;
   end try

   begin catch
    rollback ;
    
    insert into ErrorLog
    (ErrorLocation,ErrorMessage,ErrorDate,ErrorUser)
    values
    (ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE(),@UserId)

   set @ErrorMessage = ERROR_MESSAGE()

  end catch
  end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateBills]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateBills]

@BillId int,
@patientid int,
@PayTypeid int,
@visitid int,
@BillAmount decimal(15,3),
@UserId int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'Bill',@BillId,'PatientId:'+cast(patientid as varchar(5))+',PayTypeid:'+cast(PayTypeid as varchar(5))+',
	        visitid:'+cast(visitid as varchar(5))+',BillAmount:'+cast(BillAmount as varchar(15)),
			'PatientId:'+cast(@patientid as varchar(5))+',PayTypeid:'+cast(@PayTypeid as varchar(5))+',
	        visitid:'+cast(@visitid as varchar(5))+',BillAmount:'+cast(@BillAmount as varchar(15))
			,GETDATE(),2, @UserId                        
      from Bill
      where billid = @BillId



     Update Bill
   set Patientid = isnull(@patientid,patientid),
       PayTypeid = isnull(@PayTypeid,PayTypeid),
	   VisitId = isnull(@visitid,visitid),
	   BillAmount = isnull(@BillAmount,BillAmount)
    where billid = @BillId


 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update bill with Id:' +cast(@billid as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
    
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDoctorSchedule]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE procedure [dbo].[SP_UpdateDoctorSchedule]
@Scheduleid int,
@DocSDays varchar(50),
@DocSStartTime varchar(50),
@DocSEndTime varchar(50),
@AvgConsulting int,
@staffid int,
@userid int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'DoctorSchedule',@Scheduleid,'DocSDays:'+DocSDays+',DocSStartTime:'+DocSStartTime+',DocSEndTime:'+DocSEndTime+',
	        AvgConsulting:'+cast(AvgCounsultingTime as varchar(5))+', StaffId:'+cast(StaffId as varchar(5)),
		   'DocSDays:'+@DocSDays+',DocSStartTime:'+@DocSStartTime+',DocSEndTime:'+@DocSEndTime+',
	        AvgConsulting:'+cast(@avgconsulting as varchar(5))+', StaffId:'+cast(@StaffId as varchar(5))
			,GETDATE(),2, @UserId                        
      from DoctorSchedule
      where Scheduleid = @Scheduleid

     Update DoctorSchedule
   set DocSDays = isnull(@DocSDays,DocSDays),
       DocSStartTime = isnull(@DocSStartTime,DocSStartTime),
	   DocSEndTime = isnull(@DocSEndTime,DocSEndTime),
	   AvgCounsultingTime = isnull(@AvgConsulting,AvgCounsultingTime),
	   StaffId =isnull( @staffid,staffid)
   where Scheduleid = @Scheduleid


 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update Schedule with Id:' +cast(@Scheduleid as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateMedicine]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   	   Create procedure [dbo].[SP_UpdateMedicine]
@Medicineid int,
@UnitPrice decimal(15,3),
@UserId int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'Medicine',@Medicineid,'UnitPrice:'+cast(UnitPrice as varchar(15)), 'UnitPrice:'+cast(@UnitPrice as varchar(15))
			,GETDATE(),2, @UserId                        
      from Medicine
      where MedicineId = @Medicineid

     Update Medicine
   set UnitPrice = @UnitPrice
     where MedicineId = @Medicineid

 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update Medicine with Id:' +cast(@medicineid as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdatePatients]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdatePatients]
@PatientId int,
@Email varchar(100),
@ContactNo char(12),
@Address nvarchar(200),
@RelativeFullName nvarchar(200),
@RelativeContact char(12),
@UserId int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'Patients',@PatientId,'Email: '+Email+',ContactNo:'+contactno+',Address:'+[Address]+',RelativeFullName:'+RelativeFullName+',
	       RelativeContact:'+RelativeContact,
	      'Email: '+@Email+',ContactNo:'+@contactno+',Address:'+@Address+',RelativeFullName:'+@RelativeFullName+',
	       RelativeContact:'+@RelativeContact,GETDATE(),2, @UserId                        
      from Patients
      where PatientId = @PatientId

     Update Patients
   set Email = isnull(@Email,email),
    ContactNo = isnull(@ContactNo,contactno),
	[Address] = isnull(@Address,[Address]),
	RelativeFullName = isnull(@RelativeFullName,RelativeFullName),
	RelativeContact = isnull(@RelativeContact,RelativeContact)
    where PatientId = @PatientId

 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update patient with Id:' +cast(@PatientId as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateStaffs]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateStaffs]
@StaffId int,
@Email varchar(100),
@ContactNo char(12),
@Address nvarchar(200),
@salary decimal(15,3),
@ClinicId int,
@TrPlaceId int,
@UserTypeId int,
@UserId int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'HospitalStaffs',@staffid,'Email: '+Email+',ContactNo:'+contactno+',Address:'+[Address]+',Salary: '+cast(salary as varchar(5))+'
	       ClinicId:'+cast(ClinicId as varchar(5))+' ,TrPlaceId:'+cast(TrPlaceId as varchar(5))+',UserTypeId: '+cast(UserTypeId as varchar(5)),
	      'Email: '+@Email+',ContactNo:'+@ContactNo+',Address:'+@Address+',Salary: '+cast(@salary as varchar(5))+'
	       ClinicId:'+cast(@ClinicId as varchar(5))+' ,TrPlaceId:'+cast(@TrPlaceId as varchar(5))+',UserTypeId: 
		   '+cast(@UserTypeId as varchar(5)),GETDATE(),2, @UserId                        
      from HospitalStaffs
      where StaffId = @StaffId

Update HospitalStaffs
set Email = isnull(@Email,email),
    ContactNo = isnull(@ContactNo,ContactNo),
	[Address] = isnull(@Address,[Address]),
	Salary = isnull(@salary,salary),
	ClinicId = isnull(@ClinicId,ClinicId),
	TrPlaceId = isnull(@TrPlaceId,TrPlaceId),
	UserTypeId = isnull(@UserTypeId,UserTypeId)
    where StaffId = @StaffId

 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update Staff with Id:' +cast(@StaffId as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateUsers]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateUsers]
@StaffId int,
@UserTypeId int,
@UserId int,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'Users',@UserId,'StaffId: '+cast(StaffId as varchar(5))+' ,UserTypeId: '+cast(UserTypeId as varchar(5)),
	 'StaffId: '+cast(@StaffId as varchar(5))+' , UserTypeId: '+cast(@UserTypeId as varchar(5)),GETDATE(),2, @UserId                        
      from Users
      where UserId = @UserId

Update Users
set StaffId= isnull(@StaffId,StaffId),
    UserTypeId= isnull(@UserTypeId,UserTypeId)
    where UserId = @UserId

 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update users with Id:' +cast(@UserId as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
  
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateVisit]    Script Date: 2/5/2023 8:47:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateVisit]

@VisitId int,
@StartTime time,
@EndTime time,
@Patientid decimal(15,3),
@visittypeid int,
@staffid int,
@visitcreatedby int,
@UserId int,
@VisitRateid int,
@visitstatus int = null,
@ErrorMessage varchar(max) out 

as
begin
begin transaction
begin try

insert into DataLog(TableName,RowId,OldValue,NewValue,ActionDate,ActionTypeId,ActionBy)
     select'VisitDetails',@VisitId,'PatientId:'+cast(patientid as varchar(5))+',staffid:'+cast(staffid as varchar(5))+',
	        starttime:'+cast(StartTime as varchar(10))+', EndTime:'+cast(EndTime as varchar(10))+',
	        visitcreatedby:'+cast(visitcreatedby as varchar(5))+',visittypeid:'+cast(VisitTypeId as varchar(5))+',
			,rateid:'+cast(VisitRateId as varchar(5))+',visitstatus:'+cast(VisitStatus as varchar(5)),
			'PatientId:'+cast(@Patientid as varchar(5))+',staffid:'+cast(@staffid as varchar(5))+',
	        starttime:'+cast(@StartTime as varchar(10))+', EndTime:'+cast(@EndTime as varchar(10))+',
	        visitcreatedby:'+cast(@visitcreatedby as varchar(5))+',visittypeid:'+cast(@visittypeid as varchar(5))+',
			,rateid:'+cast(@VisitRateid as varchar(5))+',visitstatus:'+cast(@visitstatus as varchar(5)),GETDATE(),2, @UserId                        
      from VisitDetails
      where VisitId = @VisitId

     Update VisitDetails
   set Patientid = isnull(@patientid,patientid),
       staffid = isnull(@staffid,staffid),
	   StartTime = isnull(@StartTime,StartTime),
	   EndTime = isnull(@EndTime,EndTime),
	   VisitCreatedBy = isnull(@UserId,VisitCreatedBy),
	   VisitTypeId =isnull( @visittypeid,visittypeid),
	   VisitRateId = isnull(@VisitRateid,VisitRateId)
      where VisitId = @VisitId

 insert into AuditTrailLog (AuditDescription,AuditDate,UserId)
 values ('Update visit with Id:' +cast(@visitid as varchar(5)),GETDATE(),@UserId)
   commit transaction;  
   end try

   begin catch 
   rollback;

  insert into ErrorLog (errormessage,errordate,errorlocation,erroruser) 
  values ( ERROR_MESSAGE(),GETDATE(),ERROR_PROCEDURE(),@userid)   
  set @errormessage = ERROR_MESSAGE();
   end catch
   end
GO
USE [master]
GO
ALTER DATABASE [PatientManagementSystem] SET  READ_WRITE 
GO
