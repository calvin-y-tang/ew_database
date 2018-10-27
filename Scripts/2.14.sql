TRUNCATE TABLE tblMessageToken
GO

SET IDENTITY_INSERT [dbo].[tblMessageToken] ON
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (1, '@ExamineeName@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (2, '@ClaimNbr@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (3, '@ClaimNbrWExt@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (4, '@CaseNbr@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (5, '@ClientName@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (6, '@DoctorSpecialty@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (7, '@DoctorName@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (8, '@ApptDate@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (9, '@ApptTime@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (10, '@ExamLocation@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (11, '@ExamLocationExtName@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (12, '@DoctorAddr1@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (13, '@DoctorAddr2@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (14, '@DoctorAddr3@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (15, '@PolicyNumber@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (16, '@Company@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (17, '@Venue@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (18, '@Office@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (19, '@RequestedSpecialty@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (20, '@DParaLegalName@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (21, '@Username@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (22, '@UserPhone@', '')
INSERT INTO [dbo].[tblMessageToken] ([MessageTokenID], [Name], [Description]) VALUES (23, '@UserEmail@', '')

SET IDENTITY_INSERT [dbo].[tblMessageToken] OFF
GO



--Remove duplicate client default documents since logic changed it should only serve as additional to company default documents
DELETE tblClientDefDocument
	FROM tblClientDefDocument AS CLD
	INNER JOIN tblDocument AS D ON CLD.DocumentCode=D.Document
	INNER JOIN tblClient AS CL ON CLD.ClientCode=CL.ClientCode
	INNER JOIN tblCompanyDefDocument AS ComD ON ComD.DocumentCode = CLD.DocumentCode AND ComD.Documentqueue = CLD.DocumentQueue AND ComD.CompanyCode = CL.CompanyCode
GO


--Changes by Gary
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebUserAccount_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebUserAccount_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_WebUserAccount_LoadByPrimaryKey]
(
	@WebUserID int,
	@UserCode int,
	@UserType char(2)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[WebUserID],
		[UserCode],
		[IsUser],
		[DateAdded],
		[IsActive],
		[UserType]
	FROM [tblWebUserAccount]
	WHERE
		([WebUserID] = @WebUserID) AND
		([UserCode] = @UserCode) AND
		([UserType] = @UserType)

	SET @Err = @@Error

	RETURN @Err
END
GO

-- Unknown Company & Client changes
ALTER TABLE [tblEWCompany]
  ADD [IsUnknown] BIT NOT NULL DEFAULT 0
GO
ALTER TABLE [tblCompany]
  ADD [IsUnknown] BIT NOT NULL DEFAULT 0
GO

ALTER TABLE [tblEWClient]
  ADD [IsUnknown] BIT NOT NULL DEFAULT 0
GO
ALTER TABLE [tblClient]
  ADD [IsUnknown] BIT NOT NULL DEFAULT 0
GO



UPDATE tblControl SET DBVersion='2.14'
GO
