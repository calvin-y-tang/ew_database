-- Added WCNbr and LicenseNbr to Doctor Export - dml 08/08/12

/****** Object:  View [dbo].[vwDoctorExportColumns]    Script Date: 08/08/2012 09:27:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDoctorExportColumns]
AS
SELECT DISTINCT 
               TOP (100) PERCENT dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctor.middleinitial, dbo.tblDoctor.credentials AS degree, dbo.tblDoctor.prefix, 
               dbo.tblDoctor.status, dbo.tblDoctor.addr1 AS address1, dbo.tblDoctor.addr2 AS address2, dbo.tblDoctor.city, dbo.tblDoctor.state, dbo.tblDoctor.zip, 
               dbo.tblDoctor.phone, dbo.tblDoctor.phoneExt AS Extension, dbo.tblDoctor.faxNbr AS Fax, dbo.tblDoctor.emailAddr AS email, dbo.tblDoctor.OPType, 
               dbo.tblSpecialty.description AS Specialty, dbo.tblOffice.description AS Office, dbo.tblOffice.officecode, dbo.tblDoctor.doctorcode, 
               dbo.tblProviderType.description AS ProviderType, dbo.tblDoctor.usdvarchar1, dbo.tblDoctor.usdvarchar2, dbo.tblDoctor.usddate1, dbo.tblDoctor.usddate2, 
               dbo.tblDoctor.usdint1, dbo.tblDoctor.usdint2, dbo.tblDoctor.usdmoney1, dbo.tblDoctor.usdmoney2, dbo.tblDoctor.usddate3, dbo.tblDoctor.usddate4, 
               dbo.tblDoctor.usdvarchar3, dbo.tblDoctor.usddate5, dbo.tblDoctor.usddate6, dbo.tblDoctor.usddate7, dbo.tblDoctor.licensenbr, dbo.tblDoctor.WCNbr
FROM  dbo.tblDoctor LEFT OUTER JOIN
               dbo.tblProviderType ON dbo.tblDoctor.ProvTypeCode = dbo.tblProviderType.ProvTypeCode LEFT OUTER JOIN
               dbo.tblOffice RIGHT OUTER JOIN
               dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON 
               dbo.tblDoctor.doctorcode = dbo.tblDoctorOffice.doctorcode LEFT OUTER JOIN
               dbo.tblSpecialty INNER JOIN
               dbo.tblDoctorSpecialty ON dbo.tblSpecialty.specialtycode = dbo.tblDoctorSpecialty.specialtycode ON 
               dbo.tblDoctor.doctorcode = dbo.tblDoctorSpecialty.doctorcode
WHERE (dbo.tblDoctor.OPType = 'DR')
ORDER BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, Office, Specialty

GO

/****** Object:  View [dbo].[vwDoctorExport]    Script Date: 08/08/2012 09:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwDoctorExport]'))
DROP VIEW [dbo].[vwDoctorExport]
GO

/****** Object:  View [dbo].[vwDoctorExport]    Script Date: 08/08/2012 09:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwDoctorExport]
AS
SELECT     dbo.vwDoctorExportColumns.*, dbo.tblDoctor.notes, dbo.tblDoctor.usdtext1, dbo.tblDoctor.usdtext2
FROM         dbo.vwDoctorExportColumns INNER JOIN
                      dbo.tblDoctor ON dbo.vwDoctorExportColumns.doctorcode = dbo.tblDoctor.doctorcode

GO



--A new table to log user activity like login success/failure and logout
CREATE TABLE [tblUserActivity] (
  [UserActivityID] INTEGER IDENTITY(1,1) NOT NULL,
  [UserID] VARCHAR(15),
  [ActivityType] VARCHAR(15),
  [DateAdded] DATETIME NOT NULL,
  [WorkstationName] VARCHAR(20),
  [LogDetail] TEXT,
  CONSTRAINT [PK_tblUserActivity] PRIMARY KEY ([UserActivityID])
)
GO





UPDATE tblControl SET DBVersion='1.79'
GO
