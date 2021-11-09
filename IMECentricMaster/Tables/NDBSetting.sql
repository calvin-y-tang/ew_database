CREATE TABLE [dbo].[NDBSetting] (
    [NDBSettingID]                           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DrDocFolderID]                          INT          NOT NULL,
    [CountryID]                              INT          NOT NULL,
    [GPContactEmail]                         VARCHAR (70) NULL,
    [EWCompanyAllDB]                         BIT          NOT NULL,
    [EWClientAllDB]                          BIT          NOT NULL,
    [AllowClientMappingFromDifferentCompany] BIT          NOT NULL,
    [EWTimeZoneID]                           INT          CONSTRAINT [DF_NDBSetting_EWTimeZoneID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_NDBSetting] PRIMARY KEY CLUSTERED ([NDBSettingID] ASC)
);

