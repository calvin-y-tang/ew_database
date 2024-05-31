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



