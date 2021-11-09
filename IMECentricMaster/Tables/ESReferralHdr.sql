CREATE TABLE [dbo].[ESReferralHdr] (
    [ESReferralHdrID]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FileProcessed]        VARCHAR (256) NULL,
    [ProcessedOn]          DATETIME      NULL,
    [ParentCompanyID]      INT           NULL,
    [TotalGood]            INT           NULL,
    [TotalMissingClient]   INT           NULL,
    [TotalMissingOffice]   INT           NULL,
    [TotalMissingExaminee] INT           NULL,
    CONSTRAINT [PK_ESReferralHdr] PRIMARY KEY CLUSTERED ([ESReferralHdrID] ASC)
);

