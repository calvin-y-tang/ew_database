/****** Object:  StoredProcedure [proc_CaseDocument_LoadExprtGridByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseDocument_LoadExprtGridByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr];
GO

CREATE PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT UserIDAdded as 'User', DateAdded as 'Date Added', sfilename as 'File Name', Description 
			FROM tblCaseDocuments WHERE PublishOnWeb = 1 AND casenbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_CaseHistory_LoadExprtGridByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseHistory_LoadExprtGridByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr];
GO

CREATE PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT UserID as 'User', DateAdded as 'Date Added', eventdesc as Description, otherinfo as Info 
		FROM tblCaseHistory WHERE PublishOnWeb = 1 AND casenbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseVerifyAccessNP]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_CaseVerifyAccessNP]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseVerifyAccessNP];
GO

CREATE PROCEDURE [proc_CaseVerifyAccessNP] 

@caseNbr int,
@ewwebuserid int

AS 

SELECT TOP 1 CaseNbr FROM tblCase 
WHERE ClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) 
AND tblCase.PublishOnWeb = 1 
AND tblCase.CaseNbr = @caseNbr

GO

/****** Object:  StoredProcedure [proc_GetCaseAccredidationByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetCaseAccredidationByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetCaseAccredidationByCaseNbr];
GO

CREATE PROCEDURE [proc_GetCaseAccredidationByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseAccredidation 
		INNER JOIN tblEWAccreditation ON tblCaseAccredidation.EWAccreditationID = tblEWAccreditation.EWAccreditationID 
		WHERE caseNbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_GetSpecialtyByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetSpecialtyByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetSpecialtyByCaseNbr];
GO

CREATE PROCEDURE [proc_GetSpecialtyByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseSpecialty 
		INNER JOIN tblSpecialty ON tblCaseSpecialty.specialtyCode = tblSpecialty.specialtyCode 
		WHERE caseNbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
GO



UPDATE tblControl SET DBVersion='2.34'
GO
