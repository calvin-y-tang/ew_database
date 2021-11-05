
-- IMEC-12255 - patch new column for Require DOB
UPDATE tblEWParentCompany SET RequireExamineeDOB = 0 
GO


-- IMEC-12367 - make sure all offices are set to use the OCR process
UPDATE tblOffice SET OCRSystemID = 1
GO


-- ******************** FOR IMECentricMASTER DB **********************
ALTER TABLE EWParentCompany ADD [RequireExamineeDOB] BIT CONSTRAINT [DF_EWParentCompany_RequireExamineeDOB] DEFAULT (0)
GO
UPDATE EWParentCompany SET RequireExamineeDOB = 0 
GO


-- ******************** FOR IMECentricMASTER DB **********************

-- Issue 12310 - queries to add processes to ISSchedule for Compex automated file copy

USE IMECentricMaster
   

-- Copy all files to Working Folder for processing - delete source
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Move to Wrkg Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 1,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\";DstPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";Filename=*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=1')

-----------------------------------------------------------------------------------------------
-- Copy all files to Archive folder
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy all to Archive', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 2,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Archive$$$\";Filename=*.*;DeleteAfterCopy=False;IncludeSubFolder=False;ExistingFileHandle=4')


-----------------------------------------------------------------------------------------------
-- Copy files to File Manager folders folder Based on State Codes (1st 2 digites of file name).  Delete after copy

   -- (1) AK
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy AK to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 3,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=85;Filename=AK*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (2) AL
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy AL to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 4,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=AL*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (3) AR
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy AR to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 5,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=AR*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (4) AZ
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy AZ to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 6,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=16;Filename=AZ*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (5) CA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy CA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 7,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=17;Filename=CA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (6) CO
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy CO to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 8,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=16;Filename=CO*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (7) CT
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy CT to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 9,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=CT*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (8) DC
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy DC to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 10,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=DC*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (9) DE
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy DE to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 11,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=DE*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (10) FL
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy FL to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 12,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=32;Filename=FL*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (11) GA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy GA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 13,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=GA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (12) HI
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy HI to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 14,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=17;Filename=HI*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (13) IA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy IA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 15,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=IA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (14) ID
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy ID to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 16,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=85;Filename=ID*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (15) IL
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy IL to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 17,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=28;Filename=IL*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (16) IN
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy IN to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 18,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=20;Filename=IN*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (17) KS
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy KS to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 19,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=KS*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (18) KY
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy KY to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 20,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=20;Filename=KY*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (19) LA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy LA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 21,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=LA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (20) MA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 22,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=MA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (21) MD
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MD to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 23,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=MD*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (22) ME
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy ME to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 24,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=ME*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (23) MI
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MI to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 25,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=20;Filename=MI*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (24) MN
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MN to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 26,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=MN*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (25) MO
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MO to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 27,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=28;Filename=MO*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (26) MS
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MS to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 28,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=MS*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (27) MT
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy MT to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 29,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=85;Filename=MT*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (28) NC
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NC to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 30,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=NC*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (29) ND
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy ND to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 31,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=ND*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (30) NE
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NE to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 32,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=NE*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (31) NH
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NH to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 33,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=NH*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (32) NJ
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NJ to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 34,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=24;Filename=NJ*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (33) NM
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NM to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 35,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=16;Filename=NM*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (34) NV
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NV to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 36,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=16;Filename=NV*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (35) NY
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy NY to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 37,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=23;Filename=NY*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (36) OH
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy OH to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 38,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=25;Filename=OH*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (37) OK
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy OK to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 39,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=OK*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (38) OR
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy OR to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 40,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=85;Filename=OR*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (39) PA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy PA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 41,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=84;Filename=PA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (40) RI
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy RI to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 42,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=RI*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (41) SC
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy SC to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 43,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=SC*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (42) SD
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy SD to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 44,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=21;Filename=SD*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (43) TN
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy TN to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 45,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=TN*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (44) TX
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy TX to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 46,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=27;Filename=TX*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (45) UT
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy UT to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 47,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=16;Filename=UT*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (46) VA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy VA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 48,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=87;Filename=VA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (47) VT
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy VT to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 49,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=19;Filename=VT*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (48) WA
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy WA to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 50,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=86;Filename=WA*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (49) WI
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy WI to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 51,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=28;Filename=WI*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (50) WV
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy WV to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 52,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=25;Filename=WV*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


   -- (51) WY
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Cpy WY to FM Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 53,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=85;Filename=WY*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')


---------------------------------------------------------------------------------------------

-- Copy any files left to Unknown Office file manager folder
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Mv to Unkwn Off Fldr', 'CopyFiles', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 54,
'SrcPath="\\imecdocs5\ISIntegrations\External\Compex\$$$Working$$$\";DstFolderID=304;Filename=*.*;DeleteAfterCopy=True;IncludeSubFolder=False;ExistingFileHandle=4')

-- Generate email to IS for any files copied to unknown office
INSERT INTO ISSchedule
(Name, Task, Type, Interval, Weekdays, Time, StartDate, GroupNo, SeqNo, Param)
VALUES ('CompexFileCpy Email Errors to IS', 'EmailFolderContent', 'H', 1, '0111110', '1900-01-01 06:00:00', '2020-11-01 00:00:00', 26, 55,
'SrcFolderID=304;EmailTo=ISSupport@examworks.com;Subject=Compex Files - Unknown Office;MinFilesToSend=1')
 
GO




