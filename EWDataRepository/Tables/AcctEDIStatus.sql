CREATE TABLE [dbo].[AcctEDIStatus] (
    [EDIStatusID]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]         INT           NULL,
    [DocumentType]     VARCHAR (2)   NULL,
    [DocumentNo]       VARCHAR (15)  NULL,
    [EDIStatus]        VARCHAR (15)  NULL,
    [EDINote]          VARCHAR (250) NULL,
    [ClientContractNo] INT           NULL,
    [ClientName]       VARCHAR (100) NULL,
    [EWFacilityID]     INT           NULL,
    [EWLocationID]     INT           NULL,
    [CompanyID]        INT           NULL,
    [ClientID]         INT           NULL,
    [ClaimNo]          VARCHAR (50)  NULL,
    [CaseNo]           VARCHAR (15)  NULL,
    [BatchNo]          INT           NULL,
    [GPExportStatus]   INT           NULL,
    PRIMARY KEY CLUSTERED ([EDIStatusID] ASC)
);

