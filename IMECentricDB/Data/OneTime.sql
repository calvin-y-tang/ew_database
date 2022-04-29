
-- Sprint 83

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : ISSchedule
-- Issue   : IMEC-12701 Entry into ISSchedule for the new CRN data RunSQL task
use [IMECentricMaster]

-- entry into ISSchedule for the new CRN data RunSQL task
INSERT INTO [dbo].[ISSchedule] ([Name],[Task],[Type],[Interval],[WeekDays],[Time],[StartDate],[EndDate],[RunTimeStart],[RunTimeEnd],[Param],[GroupNo],[SeqNo])
VALUES
('Refresh CRN Hartford Data Daily','RunSQL','d',1,'1111111','1900-01-01 06:00:00','2022-05-02 06:00:00',null,'2022-05-02 06:00:00',null,'SQLFile=E:\EWIntegrationServer\SQLScripts\CRNHartfordDataDaily.sql;DBIDs="23;";Subject="Refresh CRN Hartford Data Daily";EmailAlways=True;Recipients="doug.troy@examworks.com;william.cecil@examworks.com"',null,null)
go