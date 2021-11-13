CREATE TABLE [dbo].[SedgwickClaimDataImport] (
    [Id]                        INT           NOT NULL,
    [RecType]                   CHAR (3)      NULL,
    [RecDetail]                 VARCHAR (MAX) NULL,
    [ClientIDorOtherID]         VARCHAR (4)   NULL,
    [ClaimUniqueID]             VARCHAR (30)  NULL,
    [ProcessingUnitRecordID]    VARCHAR (3)   NULL,
    [FailureReasonCode1]        VARCHAR (5)   NULL,
    [FailureReasonDescription1] VARCHAR (512) NULL,
    [FailureReasonCode2]        VARCHAR (5)   NULL,
    [FailureReasonDescription2] VARCHAR (512) NULL,
    [FailureReasonCode3]        VARCHAR (5)   NULL,
    [FailureReasonDescription3] VARCHAR (512) NULL,
    [UpdateInsert]              CHAR (1)      NULL,
    [ClaimRecordID]             INT           NULL,
    [TroubleTime]               CHAR (5)      NULL,
    [IsRecordLoaded]            BIT           NULL,
    [HeaderRecordID]            INT           NULL,
    [ClaimPKeyID]               INT           NULL,
    [ClaimRecordWasWritten]     BIT           NULL,
    [ClaimNumber]               VARCHAR (18)  NULL,
    [ShortVendorID]             VARCHAR (25)  NULL,
    [SystemID]                  VARCHAR (30)  NULL,
    [ClaimID]                   NUMERIC(27, 3) NULL, 
    CONSTRAINT [PK_SedgwickClaimDataImport] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
