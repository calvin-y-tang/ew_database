-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 136

-- // IMEC-14268 - ISIntegration entry to handle new process for Cyclone
USE IMECentricMaster
GO

insert into ISIntegration (
    IntegrationID,Name,Active,Type,ToGP,FromGP,DBID,
    LastDateEditedCompany,LastDateEditedClient,LastDateEditedDoctor,
    DRVersion,DRInterval,DRWeekend,
    FromGPNextBatchNo,FromGPFacilityIDs,CountryCode,GPEntityPrefix,
    UseDataFeedIDForGP,ManageIMECentricID,NextCompanyID,NextClientID,NextDoctorID,
    FolderPath,
    UseSFTP,
    SFTPPath,
    Email,
    OffsetHours,FromGPExcludeInvNoStart,FromGPExcludeInvNoEnd,FromGPExcludeVoNoStart,FromGPExcludeVoNoEnd,GPDBID,ExportMarketer
) values (
    580,'Cyclone',0,'DR',1,0,null,
    null,null,null,
    10,1440,null,
    1,null,'CA',580,
    1,1,1,1,1,
    '\\IMECDocs5\ISIntegrations\EWRepository\580\',
    1, 
    '/IS/Internal/RepositoryFeeds/Cyclone/Prod/',
    'Jim.Harris@examworks.com',
    null,null,null,null,null,null,0
)
GO

-- IMEC-14028 - increase size of columns that store file/Path to support FQDN
ALTER TABLE ISSchedule ALTER COLUMN Param VARCHAR(8000) NULL
GO
ALTER TABLE ISQueue ALTER COLUMN Param VARCHAR(8000) NULL
GO
ALTER TABLE ISIntegration ALTER COLUMN FolderPath VARCHAR(256) NULL
GO
ALTER TABLE ISExtIntegration ALTER COLUMN SrcPath VARCHAR(256) NULL
ALTER TABLE ISExtIntegration ALTER COLUMN DestPath VARCHAR(256) NULL
GO
ALTER TABLE InfoLauncher ALTER COLUMN NewVersionDir VARCHAR(256) NULL
GO
ALTER TABLE InfoIssueDoc ALTER COLUMN CheckedOutFolder VARCHAR(256) NULL
GO
ALTER TABLE GPDB ALTER COLUMN SQLInstance VARCHAR(256) NULL
GO
ALTER TABLE EWFacility ALTER COLUMN Logo VARCHAR(256) NULL
GO
ALTER TABLE EWDoctorDocument ALTER COLUMN OriginalFilePath VARCHAR(256) NULL
GO
ALTER TABLE DB ALTER COLUMN SQLInstance VARCHAR(256) NULL
GO

