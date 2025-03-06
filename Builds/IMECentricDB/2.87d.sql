update tblcontrol set searchresultlimit = 5000;
GO

UPDATE tj 
   SET FolderID = td.FolderID, 
	   SubFolder = RTRIM(YEAR(tj.DateAdded)) 
					+ '-' 
					+ RIGHT('0' + RTRIM(MONTH(tj.DateAdded)), 2) 
					+ '\' 
					+ CONVERT(VARCHAR, tj.TranscriptionJobID)
					+ '\'
  FROM tblTranscriptionJob as tj 
  INNER JOIN tblEWTransDept as td on tj.EWTransDeptID = td.EWTransDeptID
  WHERE tj.FolderID IS NULL
GO

INSERT INTO tblUserFunction VALUES ('AllowManualAck', 'EDI - Allow Manual File Acknowledgement')
GO
INSERT INTO tblGroupFunction VALUES ('6-AcctAdv', 'AllowManualAck')
INSERT INTO tblGroupFunction VALUES ('7-Manager', 'AllowManualAck')
INSERT INTO tblGroupFunction VALUES ('8-CorpAdmin', 'AllowManualAck')
GO

UPDATE tblDoctor SET SchedulePriority = 3 WHERE SchedulePriority IS NULL AND (FirstName IS NOT NULL OR LastName IS NOT NULL)
GO


delete from tblWebEvents where Code = 100
GO
SET IDENTITY_INSERT tblWebEvents ON
INSERT tblWebEvents (Code, Description, DateAdded, UserIdAdded, [Type], PublishOnWeb) VALUES (100, 'File Upload', GETDATE(), 'System', 'FileUpl', 0)
SET IDENTITY_INSERT tblWebEvents OFF
GO
delete from tblWebEventsOverride where WebEventsCode = 100
GO
DECLARE @IMECentricCode int
DECLARE @UserType varchar(10)
DECLARE @SQLUpDate nvarchar(500)

DECLARE IMECentricCodeList CURSOR FOR
	SELECT DISTINCT(IMECentricCode), UserType FROM tblWebEventsOverride

OPEN IMECentricCodeList

FETCH NEXT FROM IMECentricCodeList
INTO @IMECentricCode, @UserType

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @SQLUpDate = 'INSERT INTO tblWebEventsOverride (IMECentricCode, UserType, WebEventsCode,
	Description, Type, PublishOnWeb, DateAdded, UserIdAdded, DateEdited, UserIdEdited)' +
	+ ' VALUES ('
	+ RTRIM(@IMECentricCode) + ', '
	+ '''' + RTRIM(@UserType) + ''', 100, ''File Upload'', ''FileUpl'', 0, '''
	+ RTRIM(CONVERT(varchar(20), GETDATE(), 113)) + ''', '
	+ '''convert'', '''
	+ RTRIM(CONVERT(varchar(20), GETDATE(), 113)) + ''', '
	+ '''convert'')'

	EXEC sp_executesql @SQLUpDate

  FETCH NEXT FROM IMECentricCodeList
    INTO @IMECentricCode, @UserType

END

CLOSE IMECentricCodeList
DEALLOCATE IMECentricCodeList
GO

