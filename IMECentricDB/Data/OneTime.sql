-- Sprint 99

-- IMEC-13215 - new source record for Ducore
INSERT INTO EWDataRepository.dbo.Source
(
    SourceID,
    Descrip,
    EWFacilityID,
    Contact_Email
)
VALUES
(   
	140,    -- SourceID - int
    'Ducore Daily Feed', -- Descrip - varchar(40)
    91, -- EWFacilityID - int
    NULL  -- Contact_Email - varchar(200)
)
GO


-- *** PRODUCTION *** --- IMEC-13215 - new integration record for Ducore
INSERT INTO IMECentricMaster.dbo.ISIntegration
(
IntegrationID,
	Name,
	Active,
	Type,
	ToGP,
	FromGP,     
	DRVersion,
	DRInterval,
	FromGPNextBatchNo,
	FromGPFacilityIDs,
	CountryCode,
	GPEntityPrefix,
	UseDataFeedIDForGP,
	ManageIMECentricID,
	NextCompanyID,
	NextClientID,
	NextDoctorID,
	FolderPath,
	UseSFTP,
	SFTPPath,
	Email,
	OffsetHours,
	FromGPExcludeInvNoStart,
	FromGPExcludeInvNoEnd,
	FromGPExcludeVoNoStart,
	FromGPExcludeVoNoEnd,
	GPDBID,
	ExportMarketer
)
VALUES
(		
	575,		-- IntegrationID - int
	'Ducore',	-- Name - varchar(15)
	1,			-- Active - bit
	'DR',		-- Type - varchar(10)
	1,			-- ToGP - bit
	0,			-- FromGP - bit   
	10,			-- DRVersion - int
	1440,		-- DRInterval - int
	1,			-- FromGPNextBatchNo - int
	NULL,		-- FromGPFacilityIDs - varchar(70)
	'CA',		-- CountryCode - varchar(2) --**** would this be CA or US, how is this related to the data
	575,		-- GPEntityPrefix - varchar(3)
	1,			-- UseDataFeedIDForGP - bit --- **** check code
	1,			-- ManageIMECentricID - bit
	1,			-- NextCompanyID - int --**** ????
	1,			-- NextClientID - int --**** ????
	1,			-- NextDoctorID - int --**** ????
	'\\IMECDocs5\ISIntegrations\EWRepository\575\',    -- FolderPath - varchar(60)
	1,			-- UseSFTP
	'/IS/Internal/RepositoryFeeds/Ducore/Prod/',    -- SFTPPath - varchar(60) 
	'Jim.Harris@examworks.com',    -- Email - varchar(200)
	NULL,		-- OffsetHours - int
	NULL,		-- FromGPExcludeInvNoStart - int
	NULL,		-- FromGPExcludeInvNoEnd - int
	NULL,		-- FromGPExcludeVoNoStart - int
	NULL,		-- FromGPExcludeVoNoEnd - int
	NULL,		-- GPDBID - int
	0			-- ExportMarketer - bit
)
go





