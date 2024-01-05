-- Sprint 127

-- IMEC-13994 - RPA LibertyiCase updates - add entry for documents
USE [IMECentricMaster]
UPDATE IMECentricMaster.dbo.ISSchedule SET SeqNo = 6 WHERE ScheduleID = 381
UPDATE IMECentricMaster.dbo.ISSchedule SET SeqNo = 5 WHERE ScheduleID = 372

INSERT INTO ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate, Param, GroupNo, SeqNo)
VALUES ('RPA Ext Doc - Liberty', 'ExtDocIntake', 'm', 5, '1111111', '1900-01-01 01:00:00', '2024-01-01 00:00:00', 
'IntakeFolderID=332;FileNameFormat=dbid-intrnlCaseNbr-keyword-datetime-casedoctypename-status;CreateCaseDocumentFolders=true;DefaultUserID=RPA;FileMask=*LibertyiCase*.PDF;EventDesc="Document Uploaded";CaseDocTypeID=7;CaseHistoryType="Records";DocumentDescription="Meds Uploaded";AdditionalActions="RPA=UpdateCaseForRPA;Email1=EmailForCaseNbrErr;"',
560, 4)


GO
