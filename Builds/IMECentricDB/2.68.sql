CREATE NONCLUSTERED INDEX [IdxtblDoctorSchedule_BY_CaseNbr1] ON [dbo].[tblDoctorSchedule] ([CaseNbr1])
GO
CREATE NONCLUSTERED INDEX [IdxtblDoctorSchedule_BY_CaseNbr2] ON [dbo].[tblDoctorSchedule] ([CaseNbr2])
GO
CREATE NONCLUSTERED INDEX [IdxtblDoctorSchedule_BY_CaseNbr3] ON [dbo].[tblDoctorSchedule] ([CaseNbr3])
GO



Drop Index IX_tblCase_4 on tblCase
Drop Index IX_tblCase on tblCase
CREATE INDEX [IdxtblCase_BY_OfficeCodeReExamReExamProcessedReExamDateClientCode] ON [tblCase]([OfficeCode],[ReExam],[ReExamProcessed],[ReExamDate],[ClientCode])
GO

CREATE INDEX [IdxtblAcctDetail_BY_DocumentNbrDocumentTypeLineNbr] ON [tblAcctDetail]([DocumentNbr],[DocumentType],[LineNbr])
GO

drop index IX_tblacctingtrans on tblAcctingTrans
GO
CREATE NONCLUSTERED INDEX [IdxtblAcctingTrans_BY_CaseNbrTypeStatusCodeDrOpCode] ON [tblAcctingTrans]([CaseNbr],[Type],[StatusCode],[DrOpCode])
GO
CREATE INDEX [IdxtblAcctingTrans_BY_StatusCode] ON [tblAcctingTrans]([StatusCode])
GO

CREATE INDEX [IdxtblAcctHeader_BY_SeqNo] ON [tblAcctHeader]([SeqNo])
GO
CREATE INDEX [IdxtblAcctHeader_BY_CaseNbr] ON [tblAcctHeader]([CaseNbr])
GO
DROP INDEX IdxtblAcctHeader_BY_EWFacilityIDDocumentTypeDocumentNbr ON tblAcctHeader
GO
CREATE INDEX [IdxtblAcctHeader_BY_DocumentNbrDocumentTypeEWFacilityID] ON [tblAcctHeader]([DocumentNbr],[DocumentType],[EWFacilityID])
GO







UPDATE tblControl SET DBVersion='2.68'
GO
