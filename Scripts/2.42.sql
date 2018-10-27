INSERT into tblMessageToken (Name)
 SELECT '@ClientPhone@'
 WHERE NOT EXISTS (SELECT Name FROM tblMessageToken WHERE Name='@ClientPhone@')
INSERT into tblMessageToken (Name)
 SELECT '@ForecastDate@'
 WHERE NOT EXISTS (SELECT Name FROM tblMessageToken WHERE Name='@ForecastDate@')
INSERT into tblMessageToken (Name)
 SELECT '@ExternalDueDate@'
 WHERE NOT EXISTS (SELECT Name FROM tblMessageToken WHERE Name='@ExternalDueDate@')
GO

insert into tbluserfunction (functioncode, functiondesc)
 select 'CompanySetCoverLetter', 'Company - Set Cover Letter'
 where not exists (select functionCode from tblUserFunction where functionCode='CompanySetCoverLetter')

GO
/****** Object:  StoredProcedure [proc_Company_LoadByEWCompanyID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Company_LoadByEWCompanyID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Company_LoadByEWCompanyID];
GO

CREATE PROCEDURE [proc_Company_LoadByEWCompanyID]
(
	@EWCompanyID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCompany]
	WHERE
		([EWCompanyID] = @EWCompanyID)

	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_EWCoverLetter_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetter_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetter_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_EWCoverLetter_LoadByPrimaryKey]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetter]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID];
GO

CREATE PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterClientSpecData]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWCoverLetterClientSpecData_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetterClientSpecData_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_EWCoverLetterClientSpecData_LoadByPrimaryKey]

@EWCoverLetterClientSpecDataID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterClientSpecData]
	WHERE
		([EWCoverLetterClientSpecDataID] = @EWCoverLetterClientSpecDataID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID];
GO

CREATE PROCEDURE [proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterCompanyName]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWCoverLetterQuestion_LoadByEWCoverLetterID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetterQuestion_LoadByEWCoverLetterID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetterQuestion_LoadByEWCoverLetterID];
GO

CREATE PROCEDURE [proc_EWCoverLetterQuestion_LoadByEWCoverLetterID]

@EWCoverLetterID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterQuestion]
	WHERE
		([EWCoverLetterID] = @EWCoverLetterID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWCoverLetterQuestion_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWCoverLetterQuestion_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWCoverLetterQuestion_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_EWCoverLetterQuestion_LoadByPrimaryKey]

@EWCoverLetterQuestionID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *
	FROM [tblEWCoverLetterQuestion]
	WHERE
		([EWCoverLetterQuestionID] = @EWCoverLetterQuestionID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_EWFolderDef_LoadByName]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWFolderDef_LoadByName]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWFolderDef_LoadByName];
GO

CREATE PROCEDURE [proc_EWFolderDef_LoadByName]

@Name varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblEWFolderDef WHERE Name = @Name

	SET @Err = @@Error

	RETURN @Err
END
GO
/****** Object:  StoredProcedure [proc_GetEWCoverLetterComboItems    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetEWCoverLetterComboItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetEWCoverLetterComboItems];
GO

CREATE PROCEDURE [proc_GetEWCoverLetterComboItems]

@CompanyCode int,
@CaseTypeCode int,
@StateCode char(2)

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


SELECT DISTINCT tblEWCoverLetter.ExternalName, tblEWCoverLetter.EWCoverLetterID 
FROM tblEWCoverLetter 
	INNER JOIN tblCompanyCoverLetter ON (tblEWCoverLetter.EWCoverLetterID = tblCompanyCoverLetter.EWCoverLetterID) 
	INNER JOIN tblEWCoverLetterBusLine ON (tblEWCoverLetter.EWCoverLetterID = tblEWCoverLetterBusLine.EWCoverLetterID) 
	INNER JOIN tblCaseType ON (tblEWCoverLetterBusLine.EWBusLineID = tblCaseType.EWBusLineID OR tblEWCoverLetterBusLine.EWBusLineID = -1) 
	INNER JOIN tblEWCoverLetterState ON (tblEWCoverLetter.EWCoverLetterID = tblEWCoverLetterState.EWCoverLetterID) 
	WHERE (tblEWCoverLetter.Active = 1)
	AND (tblCaseType.Code = @CaseTypeCode OR tblEWCoverLetterBusLine.EWBusLineID = -1)
	AND (tblCompanyCoverLetter.CompanyCode = @CompanyCode OR tblCompanyCoverLetter.CompanyCode = -1)
	AND (tblEWCoverLetterState.StateCode = @StateCode OR tblEWCoverLetterState.StateCode = '-1')
	ORDER BY ExternalName

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_GetMostRecentCoverLetterRecord]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetMostRecentCoverLetterRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetMostRecentCoverLetterRecord];
GO

CREATE PROCEDURE [proc_GetMostRecentCoverLetterRecord] 

@CaseNbr int

AS

SELECT TOP 1 * FROM tblCaseDocuments 
	WHERE casenbr = @CaseNbr 
		AND DESCRIPTION = 'Cover Letter' 
			ORDER BY dateadded DESC

GO


UPDATE tblControl SET DBVersion='2.42'
GO
