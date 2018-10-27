PRINT N'Altering [dbo].[tblEWFacility]...';


GO
ALTER TABLE [dbo].[tblEWFacility]
    ADD [EWServiceTypeID] INT NULL,
        [AltDBID]         INT NULL;


GO
PRINT N'Altering [dbo].[tblEWFacilityGroupSummary]...';


GO
ALTER TABLE [dbo].[tblEWFacilityGroupSummary]
    ADD [DivisionGroupID]   INT          NULL,
        [DivisionGroupName] VARCHAR (20) NULL,
        [DivisionSeqNo]     INT          NULL;


GO


PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [AllowNonApptBasedDate] BIT CONSTRAINT [DF_tblServices_AllowNonApptBasedDate] DEFAULT ((0)) NULL;


GO
PRINT N'Altering [dbo].[fnGetTranscriptionDocumentPath]...';


GO
/*
	Table-Valued Function that will return the fully qualified transcription document path,
	EW Folder ID and SubFolder name for the CaseNbr specified

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)

*/
ALTER FUNCTION [dbo].[fnGetTranscriptionDocumentPath]
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
		+ ISNULL(TJ.SubFolder, RTRIM(YEAR(TJ.DateAdded))
								+ '-'
								+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
								+ '\' + CONVERT(VARCHAR, @transJobID)),
		@folderID = FD.FolderID,
		@subFolder = ISNULL(TJ.SubFolder, RTRIM(YEAR(TJ.DateAdded))
											+ '-'
											+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
											+ '\' + CONVERT(VARCHAR, @transJobID) + '\')
		FROM tblTranscriptionJob as TJ
			inner join tblEWTransDept as TD on TJ.EWTransDeptID = TD.EWTransDeptID
			inner join tblEWFolderDef as FD on ISNULL(TJ.FolderID, TD.FolderID) = FD.FolderID
		WHERE TJ.TranscriptionJobID = @transJobID
		  AND TJ.TranscriptionJobID IS NOT NULL

	INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	RETURN

END
GO
UPDATE tblControl SET DBVersion='2.86'
GO