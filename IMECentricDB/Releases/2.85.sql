PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [UseNP] BIT CONSTRAINT [DF_tblControl_UseNP] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblEWTransDept]...';


GO
ALTER TABLE [dbo].[tblEWTransDept]
    ADD [FolderID] INT NULL;


GO
PRINT N'Altering [dbo].[tblTranscriptionJob]...';


GO
ALTER TABLE [dbo].[tblTranscriptionJob]
    ADD [FolderID]  INT          NULL,
        [SubFolder] VARCHAR (32) NULL;


GO
PRINT N'Creating [dbo].[fnGetTranscriptionDocumentPath]...';


GO
/*
	Table-Valued Function that will return the fully qualified transcription document path,
	EW Folder ID and SubFolder name for the CaseNbr specified

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)

*/
CREATE FUNCTION [dbo].[fnGetTranscriptionDocumentPath]
(
	@transJobID INT	
)
RETURNS @documentInfo TABLE
(
	DocumentPath VarChar(500),
	FolderID INT,
	SubFolder VarChar(32)
)
AS
BEGIN
	DECLARE @path VARCHAR(500)	
	DECLARE @folderID INT
	DECLARE @subFolder VARCHAR(32)
	
	SELECT @path = FD.PathName 
		+ RTRIM(YEAR(TJ.DateAdded))
		+ '-'
		+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
		+ '\' + CONVERT(VARCHAR, @transJobID),
		@folderID = FD.FolderID,
		@subFolder = RTRIM(YEAR(TJ.DateAdded))
		+ '-'
		+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
		+ '\' + CONVERT(VARCHAR, @transJobID) + '\'		
		FROM tblTranscriptionJob as TJ
			inner join tblEWTransDept as TD on TJ.EWTransDeptID = TD.EWTransDeptID
			inner join tblEWFolderDef as FD on TD.FolderID = FD.FolderID
		WHERE TJ.TranscriptionJobID = @transJobID
		  AND TJ.TranscriptionJobID IS NOT NULL

	INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	RETURN

END
GO
PRINT N'Altering [dbo].[proc_CaseDocument_LoadExprtGridByCaseNbr]...';


GO
ALTER PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT tblCaseDocuments.UserIDAdded as 'User', tblPublishOnWeb.PublishAsPDF, tblCaseDocuments.DateAdded as 'Date Added', sfilename as 'File Name', Description
		FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
			AND (casenbr = @CaseNbr)
			AND (tblCaseDocuments.PublishOnWeb = 1)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetReferralSearch]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetReferralSearch]

@WebUserID int = 0

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode,
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.DoctorName AS provider,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty,
		tblServices.shortdesc AS service,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblExaminee.lastname,
		tblExaminee.firstname,
		tblWebQueues.description AS WebStatus,
		tblQueues.WebStatusCode,
		tblWebQueues.statuscode,
		tblCase.claimnbr,
		tblWebUserAccount.WebUserID,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType

	WHERE tblWebUserAccount.WebUserID = COALESCE(@WebUserID,tblWebUserAccount.WebUserID)

SET @Err = @@Error
RETURN @Err
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount]...';


GO
CREATE PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount]

@WebUserID int = NULL,
@LastLoginDate datetime

AS

SELECT DISTINCT COUNT(tblCaseDocuments.seqno)
	FROM tblCaseDocuments
	INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode IN
			(SELECT UserCode
				FROM tblWebUserAccount
				WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
				AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
		AND (tblCaseDocuments.PublishOnWeb = 1)
WHERE tblCaseDocuments.DateAdded > @LastLoginDate
GO
PRINT N'Creating [dbo].[proc_CaseHistory_LoadByWebUserIDAndLastLoginDateCount]...';


GO
CREATE PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndLastLoginDateCount]

@WebUserID int = NULL,
@LastLoginDate datetime

AS

SELECT DISTINCT COUNT(tblCaseHistory.id)
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory'
	AND (tblPublishOnWeb.PublishOnWeb = 1)
	AND (tblPublishOnWeb.UserCode IN
		(SELECT UserCode
			FROM tblWebUserAccount
			WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
	WHERE tblCaseHistory.EventDate > @LastLoginDate
GO
PRINT N'Creating [dbo].[proc_GetReferralSummarySinceLastLoginDateCount]...';


GO
CREATE PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDateCount]

@WebUserID int,
@LastLoginDate datetime

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(casenbr)
		FROM tblCase
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.dateadded > @LastLoginDate)
		AND (tblCase.status <> 0)

	SET @Err = @@Error

	RETURN @Err
END
GO



UPDATE tblControl SET DBVersion='2.85'
GO