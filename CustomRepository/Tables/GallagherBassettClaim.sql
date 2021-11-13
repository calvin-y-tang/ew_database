CREATE TABLE [dbo].[GallagherBassettClaim] (
    [PrimaryKey]            INT           IDENTITY (1, 1) NOT NULL,
    [RecordType]            CHAR (2)      NOT NULL,
    [ClaimTaxId]            VARCHAR (11)  NULL,
    [CarrierNumber]         CHAR (6)      NULL,
    [GBBranchNumber]        CHAR (3)      NULL,
    [ClientNumAccount]      VARCHAR (15)  NULL,
    [ExternalKey]           VARCHAR (15)  NULL,
    [ClaimantLastName]      VARCHAR (35)  NULL,
    [ClaimantFirstName]     VARCHAR (35)  NULL,
    [ClaimantMidInit]       CHAR (1)      NULL,
    [ClaimAccidentCode]     VARCHAR (12)  NULL,
    [ClaimantSex]           CHAR (1)      NULL,
    [ClaimantDOB]           DATETIME      NULL,
    [ClaimOpenDate]         DATETIME      NULL,
    [ClaimClosedDate]       DATETIME      NULL,
    [ClaimAccidentDate]     DATETIME      NULL,
    [ClaimantAddress1]      VARCHAR (35)  NULL,
    [ClaimantAddress2]      VARCHAR (35)  NULL,
    [ClaimantPhone]         VARCHAR (20)  NULL,
    [ClaimantCity]          VARCHAR (28)  NULL,
    [ClaimantState]         CHAR (2)      NULL,
    [ClaimantZipCode]       CHAR (10)     NULL,
    [BenefitState]          CHAR (2)      NULL,
    [ClaimLastUpdated]      DATETIME      NULL,
    [PPSClaimNumber]        VARCHAR (25)  NULL,
    [PPSWCClaimType]        CHAR (2)      NULL,
    [ReportingUnitOrg]      VARCHAR (64)  NULL,
    [ReportingUnitAddress1] VARCHAR (35)  NULL,
    [ReportingUnitAddress2] VARCHAR (35)  NULL,
    [ReportingUnitCity]     VARCHAR (28)  NULL,
    [ReportingUnitState]    CHAR (2)      NULL,
    [ReportingUnitZipcode]  CHAR (10)     NULL,
    [GBAdjNum]              CHAR (6)      NULL,
    [PPSEmployeeName]       VARCHAR (35)  NULL,
    [AdjEmailAddress]       VARCHAR (254) NULL,
    [PPSClaimLossDesc]      VARCHAR (300) NULL,
    [BodyPartCode]          CHAR (4)      NULL,
    [LossNatureBICode]      CHAR (4)      NULL,
    [PreviousSSN]           CHAR (12)     NULL,
    [PreviousInjuryDate]    DATETIME      NULL,
    [ClaimDateAdded]        DATETIME      NULL,
    [ClaimDateUpdated]      DATETIME      NULL,
    [ClaimFilename]         VARCHAR (255) NULL,
    [ClaimStatus]           CHAR (1)      NULL,
    [RecordOperation]       CHAR (1)      NULL,
    CONSTRAINT [PK_GallagherBassettClaim] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_GallagherBassettClaim_PPSClaimNumber]
    ON [dbo].[GallagherBassettClaim]([PPSClaimNumber] ASC);

