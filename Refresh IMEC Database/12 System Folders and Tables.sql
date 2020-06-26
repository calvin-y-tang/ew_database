/*
1. Make sure the script run against the target database
*/





DECLARE @dbID INT
DECLARE @dbName VARCHAR(100)
DECLARE @docServer VARCHAR(100)
DECLARE @docFolder VARCHAR(200)
DECLARE @countryID INT
DECLARE @isTestSystem BIT

DECLARE @caseDocFolderID INT
DECLARE @acctDocFolderID INT
DECLARE @tranDocFolderID INT


--Auto Set Additional Variables
SELECT @dbID = DBID, @isTestSystem = IsTestSystem, @countryID = CountryID FROM tblControl
SELECT @dbName = Name FROM IMECentricMaster.dbo.DB WHERE DBID = @dbID

IF @isTestSystem = 1
	IF @countryID = 1
		SET @docServer = 'Dev4'
	ELSE
		SET @docServer = 'IMECDocs4'
ELSE
	IF @countryID = 1
		SET @docServer = 'IMECDocs2'
	ELSE
		SET @docServer = 'IMECDocs4'

SET @docFolder = '\\' + @docServer + '\IMECentricDocs\' + @dbName + '\'


--Set Document Path
UPDATE tblControl SET
 DirDirections       = @docFolder + 'DirectionDocs\',
 DirTemplate         = @docFolder + 'Templates\',
 DirVoicePlayer      = '\\EWISApp1\Deploy\VoicePlayer\',
 SourceDirectory     = @docFolder + 'NewVersion\'

UPDATE tblIMEData SET
 DirImport           = @docFolder + 'Import\'



--Test System Only
IF @isTestSystem = 1
BEGIN
	SET @caseDocFolderID = 9000001 + @dbID * 10
	SET @acctDocFolderID = 9000002 + @dbID * 10
	SET @tranDocFolderID = 9000003 + @dbID * 10


	DELETE FROM IMECentricMaster.[dbo].[EWFolderDef] WHERE FolderID IN (@caseDocFolderID, @acctDocFolderID, @tranDocFolderID)
	INSERT INTO IMECentricMaster.[dbo].[EWFolderDef] ([FolderID], [Name], [FolderType], [PathName], [SortBy], [SortOrder], [FunctionCode], [FunctionDesc], [InfoSecurityTokenID], [MoveSource], [MoveTarget], [FolderGroup], [GroupCode], [GroupDesc], [ArchiveType], [ArchiveAge], [ArchiveFolder], [AutoCreate], [AddFilesEnabled], [AddFilesAcceptFolder], [AddFilesCopyOperation]) VALUES (@caseDocFolderID, 'Case Doc Storage (%DBName%)',          800, '\\%DocServer%\IMECentricDocs\%DBName%\Docs\',           NULL, NULL, 'CSCaseDocStorageTest', 'CaseDocStor -Case Doc Storage (Test)',   NULL, 0, 0, '', '', '', 0, NULL, '', 0, 0, 0, NULL)
	INSERT INTO IMECentricMaster.[dbo].[EWFolderDef] ([FolderID], [Name], [FolderType], [PathName], [SortBy], [SortOrder], [FunctionCode], [FunctionDesc], [InfoSecurityTokenID], [MoveSource], [MoveTarget], [FolderGroup], [GroupCode], [GroupDesc], [ArchiveType], [ArchiveAge], [ArchiveFolder], [AutoCreate], [AddFilesEnabled], [AddFilesAcceptFolder], [AddFilesCopyOperation]) VALUES (@acctDocFolderID, 'Accounting Doc Storage (%DBName%)',    850, '\\%DocServer%\IMECentricDocs\%DBName%\AcctDocs\',       NULL, NULL, 'ASAcctDocStorageTest', 'AcctDocStor -Acct Doc Storage (Test)',   NULL, 0, 0, '', '', '', 0, NULL, '', 0, 0, 0, NULL)
	INSERT INTO IMECentricMaster.[dbo].[EWFolderDef] ([FolderID], [Name], [FolderType], [PathName], [SortBy], [SortOrder], [FunctionCode], [FunctionDesc], [InfoSecurityTokenID], [MoveSource], [MoveTarget], [FolderGroup], [GroupCode], [GroupDesc], [ArchiveType], [ArchiveAge], [ArchiveFolder], [AutoCreate], [AddFilesEnabled], [AddFilesAcceptFolder], [AddFilesCopyOperation]) VALUES (@tranDocFolderID, 'Transcription Doc Storage (%DBName%)', 930, '\\%DocServer%\IMECentricDocs\%DBName%\Transcriptions\', NULL, NULL, 'TSTranDocStorageTest', 'TranStor -Transcription Storage (Test)', NULL, 0, 0, '', '', '', 0, NULL, '', 0, 0, 0, NULL)

	UPDATE F SET
	F.Name = REPLACE(F.Name, '%DBName%', @dbName),
	F.PathName = REPLACE(REPLACE(F.PathName, '%DBName%', @dbName), '%DocServer%', @docServer)
	FROM IMECentricMaster.dbo.EWFolderDef AS F
	WHERE F.FolderID IN (@caseDocFolderID, @acctDocFolderID, @tranDocFolderID)


	DELETE FROM IMECentricMaster.dbo.EWTransDept WHERE EWTransDeptID = @tranDocFolderID
	INSERT INTO IMECentricMaster.dbo.EWTransDept
	VALUES (@tranDocFolderID, '%DBName%', @dbID, '\\%DocServer%\ISIntegrations\Dictation\%DBName%\', 1, @tranDocFolderID, 15, @tranDocFolderID, NULL)
	UPDATE F SET
	F.Name = REPLACE(F.Name, '%DBName%', @dbName),
	F.FolderPath = REPLACE(REPLACE(F.FolderPath, '%DBName%', @dbName), '%DocServer%', @docServer)
	FROM IMECentricMaster.dbo.EWTransDept AS F
	WHERE F.FolderID IN (@tranDocFolderID)


	UPDATE tblIMEData SET CaseDocFolderID=@caseDocFolderID, AcctDocFolderID=@acctDocFolderID
	UPDATE tblOffice SET EWTransDeptID=@tranDocFolderID
END


--Set System Tables
TRUNCATE TABLE tblEWTransDept
INSERT INTO tblEWTransDept SELECT * FROM IMECentricMaster.dbo.EWTransDept

TRUNCATE TABLE tblEWFolderDef
INSERT INTO tblEWFolderDef SELECT * FROM IMECentricMaster.dbo.EWFolderDef

TRUNCATE TABLE tblEWParentCompany
INSERT INTO tblEWParentCompany SELECT * FROM IMECentricMaster.dbo.EWParentCompany

