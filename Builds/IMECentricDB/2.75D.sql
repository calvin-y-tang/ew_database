UPDATE tblCase SET ExtCaseNbr=CaseNbr WHERE ExtCaseNbr=0
GO
UPDATE tblTranscriptionJob SET TranscriptionJobNbr=TranscriptionJobID WHERE TranscriptionJobNbr=0
GO

UPDATE tblIMEData SET FeeScheduleSetting=(SELECT TOP 1 FeeScheduleSetting FROM tblControl)
GO

UPDATE C SET
	EmailCapability=I.EmailCapability,
	FaxCapability=I.FaxCapability,
	FaxServerType=I.FaxServerType,
	LabelCapability=i.LabelCapability,
	TranscriptionCapability=I.TranscriptionCapability,
	CountryID=I.CountryID,
	BrqInternalCaseNbr=I.BrqInternalCaseNbr,
	CreateVouchers=I.CreateVouchers,
	CalcTaxOnVouchers=I.CalcTaxOnVouchers,
	RequirePDF=I.RequirePDF,
	AllowICD10=I.AllowICD10,
	UseHCAIInterface=I.UseHCAIInterface,
	blnUseSubCases=I.blnUseSubCases,
	NextInvoiceNbr=I.NextInvoiceNbr,
	NextVoucherNbr=I.NextVoucherNbr,
	NextEDIBatchNbr=I.NextEDIBatchNbr,
	NextBatchNbr=I.NextBatchNbr,
	ATSecurityProfileID=I.ATSecurityProfileID,
	CLSecurityProfileID=I.CLSecurityProfileID,
	DRSecurityProfileID=I.DRSecurityProfileID,
	OPSecurityProfileID=I.OPSecurityProfileID,
	TRSecurityProfileID=I.TRSecurityProfileID,
	ApptDuration=I.ApptDuration,
	MultiPortal=I.MultiPortal,
	IncludeSubCaseOnMaster=I.IncludeSubCaseOnMaster,
	DefaultICDFormat=I.DefaultICDFormat,
	WorkHourStart=I.WorkHourStart,
	WorkHourEnd=I.WorkHourEnd,
	DrDocFolderID=I.DrDocFolderID,
	DirWebQuickReferralFiles=I.DirWebQuickReferralFiles,
	DirTemplate=I.DirTemplate,
	DirDirections=I.DirDirections,
	SourceDirectory=I.SourceDirectory,
	DirVoicePlayer=I.DirVoicePlayer,
	DirIMECentricHelper=I.DirIMECentricHelper
 FROM tblControl AS C
 INNER JOIN tblIMEData AS I ON InstallID=1 AND IMECode=1
GO


INSERT INTO tblDocumentOffice
        ( DocumentID ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT D.SeqNo, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblDocument AS D
 LEFT OUTER JOIN tblOffice AS O ON 1=1
 WHERE D.OfficeCode=-1
GO
INSERT INTO tblDocumentOffice
        ( DocumentID ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT D.SeqNo, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblDocument AS D
 INNER JOIN tblOffice AS O ON O.OfficeCode=D.OfficeCode
 WHERE D.OfficeCode<>-1
GO


INSERT INTO tblLocationOffice
        ( LocationCode ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT L.LocationCode, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblLocation AS L
 LEFT OUTER JOIN tblOffice AS O ON 1=1
GO

INSERT INTO tblFacilityOffice
        ( FacilityID ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT F.FacilityID, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblFacility AS F
 LEFT OUTER JOIN tblOffice AS O ON 1=1
GO

INSERT INTO tblCCAddressOffice
        ( CCCode ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT C.ccCode, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblCCAddress AS C
 LEFT OUTER JOIN tblOffice AS O ON 1=1
GO

INSERT INTO tblCompanyOffice
        ( CompanyCode ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT C.CompanyCode, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblCompany AS C
 LEFT OUTER JOIN tblOffice AS O ON 1=1
GO

INSERT INTO tblClientOffice
        ( ClientCode ,
          OfficeCode ,
          DateAdded ,
          UserIDAdded
        )
SELECT C.ClientCode, CO.OfficeCode, GETDATE(), 'Convert'
 FROM tblCompanyOffice AS CO
 INNER JOIN tblClient AS C ON C.CompanyCode = CO.CompanyCode
GO

UPDATE CO SET CO.IsDefault=1
 FROM tblClient AS C
 INNER JOIN tblClientOffice AS CO ON CO.ClientCode = C.ClientCode AND C.DefOfficeCode=CO.OfficeCode
GO
