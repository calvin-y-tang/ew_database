CREATE TABLE [dbo].[GallagherBassettClaimSupplemental] (
    [PrimaryKey]              INT          IDENTITY (1, 1) NOT NULL,
    [VendorID]                CHAR (2)     NULL,
    [ClaimNumber]             VARCHAR (32) NOT NULL,
    [InsurerCode]             CHAR (10)    NULL,
    [InsurerName]             VARCHAR (40) NULL,
    [InsurerFEIN]             VARCHAR (12) NULL,
    [InsurerZip]              CHAR (10)    NULL,
    [EmployerName]            VARCHAR (64) NULL,
    [EmployerAddr1]           VARCHAR (35) NULL,
    [EmployerAddr2]           VARCHAR (35) NULL,
    [EmployerCity]            VARCHAR (28) NULL,
    [EmployerState]           CHAR (2)     NULL,
    [EmployerZip]             CHAR (10)    NULL,
    [BenefitState]            CHAR (2)     NULL,
    [MPNFlag]                 CHAR (1)     NULL,
    [MPNDate]                 DATETIME     NULL,
    [JurisdictionClaimNumber] VARCHAR (32) NULL,
    [EmployerFEIN]            VARCHAR (16) NULL,
    [ReportingLocation]       CHAR (11)    NULL,
    [NCCIPartOfBody]          CHAR (4)     NULL,
    [NCCINatureOfInjury]      CHAR (4)     NULL,
    [GBBranchNum]             CHAR (6)     NULL,
    [ReportToState]           CHAR (1)     NULL,
    [ClaimantIDType]          CHAR (1)     NULL,
    [ClaimantID]              VARCHAR (20) NULL,
    [PolicyNumber]            VARCHAR (30) NULL,
    [DOB]                     DATETIME     NULL,
    [Gender]                  CHAR (1)     NULL,
    [ClaimAdminName]          VARCHAR (40) NULL,
    [ClaimAdminFEIN]          VARCHAR (12) NULL,
    [OrgID]                   CHAR (9)     NULL,
    [StateRptType]            CHAR (1)     NULL,
    [ClaimantPhone]           VARCHAR (20) NULL,
    [ClaimAdminZip]           CHAR (10)    NULL,
    [ClaimAdminID]            VARCHAR (20) NULL,
    [ClaimantCountryCode]     CHAR (5)     NULL,
    [EmployerCountryCode]     CHAR (5)     NULL,
    [TreatingPhyName]         VARCHAR (64) NULL,
    [TreatingPhyLicense]      VARCHAR (30) NULL,
    [TreatingPhyNPI]          VARCHAR (30) NULL,
    [InsurerAddr1]            VARCHAR (35) NULL,
    [InsurerAddr2]            VARCHAR (35) NULL,
    [InsurerAddr3]            VARCHAR (35) NULL,
    [InsurerCity]             VARCHAR (28) NULL,
    [InsurerState]            CHAR (2)     NULL,
    [ClaimPK]                 INT          NOT NULL,
    CONSTRAINT [PK_GallagherBassettClaimSupplemental] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_GallagherBassettClaimSupplemental_ClaimPK]
    ON [dbo].[GallagherBassettClaimSupplemental]([ClaimPK] ASC);

