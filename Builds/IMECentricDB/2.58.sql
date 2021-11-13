-- applied to production

ALTER TABLE [tblCompany]
  ADD [DataHandling] INTEGER
GO

ALTER TABLE [tblEWCompany]
  ADD [DataHandling] INTEGER
GO

ALTER TABLE [tblEWParentCompany]
  ADD [DataHandling] INTEGER
GO




-- in cummulativeChanges
CREATE TABLE tblTranscriptionJobDictation
(
TranscriptionJobDictationID int NOT NULL IDENTITY(1, 1),
TranscriptionJobID int NOT NULL,
DateAdded datetime NULL,
DateEdited datetime NULL,
UserIDAdded varchar (20) NULL,
UserIDEdited varchar (20) NULL,
DictationFile varchar (100) NULL,
OriginalFileName varchar (100) NULL,
DictationDownloaded bit NOT NULL,
IntegrationID int NULL,
SeqNo int NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE dbo.tblTranscriptionJobDictation ADD CONSTRAINT PK_tblTranscriptionJobDictation PRIMARY KEY CLUSTERED  (TranscriptionJobDictationID) ON [PRIMARY]
GO

INSERT  INTO tblTranscriptionJobDictation
        ( TranscriptionJobID ,
          DateAdded ,
          DateEdited ,
          UserIDAdded ,
          UserIDEdited ,
          DictationFile ,
          OriginalFileName ,
          DictationDownloaded ,
          IntegrationID ,
          SeqNo
        )
        SELECT  TranscriptionJobID ,
                DateAdded ,
                GETDATE() ,
                '' ,
                'Convert' ,
                DictationFile ,
                OriginalFileName ,
                ISNULL(DictationDownloaded, 0) ,
                IntegrationID ,
                1
        FROM    tblTranscriptionJob
		WHERE DictationFile IS NOT NULL
GO

ALTER TABLE tblTranscriptionJob
 DROP COLUMN DictationFile
GO
ALTER TABLE tblTranscriptionJob
 DROP COLUMN OriginalFileName
GO
ALTER TABLE tblTranscriptionJob
 DROP COLUMN DictationDownloaded
GO
ALTER TABLE tblTranscriptionJob
 DROP COLUMN IntegrationID
GO

UPDATE tblDoctor SET DateLastUsed=
	(SELECT MAX(ISNULL(CASE WHEN apptdate>GETDATE() THEN documentdate ELSE apptdate END, documentdate))
    FROM tblAcctingTrans AS a
    WHERE tblDoctor.doctorcode = a.DrOPCode AND a.type='VO' AND ISNULL(a.result,'')='' AND a.statusCode=20)
    WHERE OPType='OP' AND EWDoctorID IS NULL
GO


UPDATE tblAcctDetail SET GLNaturalAccount=REPLACE(P.INGLAcct, '??', BL.GPGLAcctPart)
 FROM tblAcctHeader AS AH
 INNER JOIN tblAcctDetail AS AD ON AD.DocumentType = AH.DocumentType AND AD.DocumentNbr = AH.DocumentNbr
 INNER JOIN tblProduct AS P ON P.ProdCode = AD.ProdCode
 INNER JOIN tblCase AS C ON C.CaseNbr = AH.CaseNbr
 INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
 INNER JOIN tblEWBusLine AS BL ON BL.EWBusLineID = CT.EWBusLineID
 WHERE AD.GLNaturalAccount IS NULL AND AD.DocumentType='IN'
GO
UPDATE tblAcctDetail SET GLNaturalAccount=REPLACE(P.VOGLAcct, '??', BL.GPGLAcctPart)
 FROM tblAcctHeader AS AH
 INNER JOIN tblAcctDetail AS AD ON AD.DocumentType = AH.DocumentType AND AD.DocumentNbr = AH.DocumentNbr
 INNER JOIN tblProduct AS P ON P.ProdCode = AD.ProdCode
 INNER JOIN tblCase AS C ON C.CaseNbr = AH.CaseNbr
 INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
 INNER JOIN tblEWBusLine AS BL ON BL.EWBusLineID = CT.EWBusLineID
 WHERE AD.GLNaturalAccount IS NULL AND AD.DocumentType='VO'
GO


DELETE FROM tblUserFunction WHERE FunctionCode='CompanySetParentCompany'
GO

-- One Time Manual

UPDATE tblDoctor SET GPVendorID=tblControl.FacilityID+'-'+CAST(DoctorCode AS VARCHAR)
 FROM tblDoctor INNER JOIN tblControl ON 1=1
 WHERE GPVendorID IS NULL AND GPIDMethod=2
GO

DELETE FROM tblGroupFunction
 WHERE GroupCode NOT IN (SELECT GroupCode FROM tblUserGroup)
DELETE FROM tblGroupFunction
 WHERE FunctionCode NOT IN (SELECT FunctionCode FROM tblUserFunction)

DELETE FROM tblUserOfficeFunction
 WHERE UserID NOT IN (SELECT UserID FROM tblUser)
DELETE FROM tblUserOfficeFunction
 WHERE OfficeCode NOT IN (SELECT OfficeCode FROM tblOffice)
DELETE FROM tblUserOfficeFunction
 WHERE FunctionCode NOT IN (SELECT FunctionCode FROM tblUserFunction)


UPDATE tblControl SET DBVersion='2.58'
GO
