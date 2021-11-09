CREATE TABLE [dbo].[GPVendorCheckRequest] (
    [PrimaryKey]    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]      INT          NULL,
    [FormatVersion] INT          NOT NULL,
    [ProcessedFlag] BIT          NOT NULL,
    [ExportDate]    DATETIME     NOT NULL,
    [RequestDate]   DATETIME     NOT NULL,
    [ServiceDate]   DATETIME     NULL,
    [CheckReqNo]    INT          NOT NULL,
    [Comment]       VARCHAR (30) NULL,
    [GPFacilityID]  VARCHAR (3)  NOT NULL,
    [GPLocationID]  VARCHAR (3)  NOT NULL,
    [GPVendorID]    VARCHAR (15) NOT NULL,
    [ClaimNo]       VARCHAR (50) NULL,
    [CaseNo]        VARCHAR (15) NULL,
    [Examinee]      VARCHAR (50) NULL,
    [BatchNo]       VARCHAR (15) NOT NULL,
    [TotalAmount]   MONEY        NOT NULL,
    [EFTPayments]   BIT          NULL,
    CONSTRAINT [PK_GPVendorCheckRequest] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

