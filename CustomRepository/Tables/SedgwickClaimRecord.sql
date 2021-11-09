CREATE TABLE [dbo].[SedgwickClaimRecord] (
    [Id]                             INT             IDENTITY (1, 1) NOT NULL,
    [ClientNumber]                   INT             NOT NULL,
    [ClaimNumber]                    VARCHAR (32)    NOT NULL,
    [ShortVendorId]                  VARCHAR (8)     NOT NULL,
    [CMSProcessingOffice]            INT             NOT NULL,
    [ClaimUniqueId]                  VARCHAR (32)    NOT NULL,
    [ClaimSystemId]                  VARCHAR (32)    NOT NULL,
    [ShellClaimNumber]               VARCHAR (32)    NULL,
    [DateOfInjury]                   DATETIME        NULL,
    [CompensabilityStatus]           VARCHAR (8)     NULL,
    [ClaimStatus]                    VARCHAR (8)     NULL,
    [LastUpdated]                    DATETIME        NULL,
    [ReportedDate]                   DATETIME        NULL,
    [ClaimantFirstName]              VARCHAR (32)    NULL,
    [ClaimantLastName]               VARCHAR (32)    NULL,
    [ClaimantMiddleName]             CHAR (1)        NULL,
    [ClaimantSSN]                    VARCHAR (12)    NULL,
    [ClaimantClientEEId]             VARCHAR (32)    NULL,
    [ClaimantStateEEId]              VARCHAR (32)    NULL,
    [ClaimantAddress1]               VARCHAR (32)    NULL,
    [ClaimantAddress2]               VARCHAR (32)    NULL,
    [ClaimantCity]                   VARCHAR (32)    NULL,
    [ClaimantState]                  VARCHAR (2)     NULL,
    [ClaimantZip]                    VARCHAR (12)    NULL,
    [ClaimantCounty]                 VARCHAR (32)    NULL,
    [ClaimantCountry]                VARCHAR (8)     NULL,
    [ClaimantDayPhone]               VARCHAR (20)    NULL,
    [ClaimantEveningPhone]           VARCHAR (20)    NULL,
    [ClaimantDOB]                    DATETIME        NULL,
    [ClaimantDateOfDeath]            DATETIME        NULL,
    [ClaimantGender]                 CHAR (1)        NULL,
    [ClaimantMaritalStatus]          CHAR (1)        NULL,
    [ClientAccount]                  INT             NULL,
    [ClientUnit]                     VARCHAR (8)     NULL,
    [DescriptionOfInjury]            VARCHAR (80)    NULL,
    [PartOfBody1]                    VARCHAR (8)     NULL,
    [PartOfBody2]                    VARCHAR (8)     NULL,
    [CauseOfInjury]                  VARCHAR (8)     NULL,
    [NatureOfInjury]                 VARCHAR (8)     NULL,
    [DescriptionOfOccupation]        VARCHAR (65)    NULL,
    [ClaimantJobClassCode]           INT             NULL,
    [ClaimantJobIntensity]           CHAR (1)        NULL,
    [ClaimantHireDate]               DATETIME        NULL,
    [ClaimantTerminationDate]        DATETIME        NULL,
    [EmploymentStatus]               VARCHAR (32)    NULL,
    [AverageWeeklyWage]              NUMERIC (12, 2) NULL,
    [TTDWage]                        NUMERIC (12, 2) NULL,
    [TDInterval]                     VARCHAR (8)     NULL,
    [DisabilityDate]                 DATETIME        NULL,
    [DateLastWorked]                 DATETIME        NULL,
    [SideOfBodyInjured1]             VARCHAR (10)    NULL,
    [SideOfBodyInjured2]             VARCHAR (10)    NULL,
    [PartOfBody]                     VARCHAR (132)   NULL,
    [Adjuster]                       VARCHAR (32)    NULL,
    [SettlementDate]                 DATETIME        NULL,
    [DenialDate]                     DATETIME        NULL,
    [RTWDate]                        DATETIME        NULL,
    [ModifiedDutyAvailable]          CHAR (1)        NULL,
    [AttorneyLegalIndicator]         CHAR (1)        NULL,
    [MHMEligibility]                 CHAR (1)        NULL,
    [DateMHMEligible]                DATETIME        NULL,
    [ClaimType]                      VARCHAR (8)     NULL,
    [StateOfJurisdiction]            VARCHAR (2)     NULL,
    [DMEOnly]                        CHAR (1)        NULL,
    [Nonsubscriber]                  CHAR (1)        NULL,
    [LineOfBusiness]                 VARCHAR (8)     NULL,
    [CarriersNCCI]                   INT             NULL,
    [CarriersFEIN]                   INT             NULL,
    [CarriersName]                   VARCHAR (64)    NULL,
    [CarriersAddress]                VARCHAR (32)    NULL,
    [CarriersCity]                   VARCHAR (32)    NULL,
    [CarriersState]                  VARCHAR (2)     NULL,
    [CarriersZip]                    VARCHAR (16)    NULL,
    [CarriersInsuredIDNumber]        VARCHAR (32)    NULL,
    [ContactName]                    VARCHAR (128)   NULL,
    [AccountName]                    VARCHAR (128)   NULL,
    [UnitName]                       VARCHAR (128)   NULL,
    [EmployerName]                   VARCHAR (128)   NULL,
    [EmployerFEIN]                   INT             NULL,
    [EmployerAddress1]               VARCHAR (32)    NULL,
    [EmployerAddress2]               VARCHAR (32)    NULL,
    [EmployerCity]                   VARCHAR (32)    NULL,
    [EmployerState]                  VARCHAR (2)     NULL,
    [EmployerZip]                    INT             NULL,
    [EmployerCountry]                VARCHAR (4)     NULL,
    [EmployerUniqueID]               VARCHAR (32)    NULL,
    [DiagICD9]                       VARCHAR (12)    NULL,
    [DrAnticipatedRestrictedRTWDate] VARCHAR (8)     NULL,
    [ActualRestrictedRTWDate]        VARCHAR (8)     NULL,
    [DrAnticipatedFullRTWDate]       VARCHAR (8)     NULL,
    [StateClaimNumber]               VARCHAR (32)    NULL,
    [ClaimExaminersOfficeNumber]     VARCHAR (4)     NULL,
    [MLSURClaimIndicator]            VARCHAR (4)     NULL,
    [EventAlertDescription]          VARCHAR (64)    NULL,
    [ClaimantAlertDescription]       VARCHAR (64)    NULL,
    [ClaimAlertDescription]          VARCHAR (64)    NULL,
    [CustomFields]                   VARCHAR (4)     NULL,
    [ClaimantEmail]                  VARCHAR (320)   NULL,
    [SecondaryDiagICD9]              VARCHAR (12)    NULL,
    [BillManagementCode]             CHAR (1)        NULL,
    [BillManagementComments]         VARCHAR (512)   NULL,
    [AppointmentFlag]                CHAR (1)        NULL,
    [AppointmentSetDate]             DATETIME        NULL,
    [AppointmentPercent]             VARCHAR (4)     NULL,
    [CertifiedActivityFlag1]         CHAR (1)        NULL,
    [CertifiedNetworkName1]          VARCHAR (64)    NULL,
    [CertifiedNetworkEligibleBegin1] DATETIME        NULL,
    [CertifiedNetworkEligibleEnd1]   DATETIME        NULL,
    [CertifiedNetworkActiveFlag2]    CHAR (1)        NULL,
    [CertifiedNetworkName2]          VARCHAR (64)    NULL,
    [CertifiedNetworkEligibleBegin2] DATETIME        NULL,
    [CertifiedNetworkEligibleEnd2]   DATETIME        NULL,
    [PharmacyNetworkActiveFlag1]     CHAR (1)        NULL,
    [PharmacyNetworkName1]           VARCHAR (60)    NULL,
    [PharmacyNetworkEligibleBegin1]  DATETIME        NULL,
    [PharmacyNetworkEligibleEnd1]    DATETIME        NULL,
    [PharmacyNetworkActiveFlag2]     CHAR (1)        NULL,
    [PharmacyNetworkName2]           VARCHAR (64)    NULL,
    [PharmacyNetworkEligibleBegin2]  DATETIME        NULL,
    [PharmacyNetworkEligibleEnd2]    DATETIME        NULL,
    [ClaimSubTypeCode]               VARCHAR (32)    NULL,
    [SubrogationFlag]                CHAR (1)        NULL,
    [HeaderRecordId]                 INT             NOT NULL,
    [PackedClaimNumber]              VARCHAR (32)    NULL,
    [ICDFormat]                      INT             NULL,
    [ICDFormatSecondary]             INT             NULL,
    [ClaimID]                        NUMERIC (27, 3) DEFAULT ((0.0)) NOT NULL,
    [AdminClaimNumber]               VARCHAR (25)    NULL,
    [CarriersPlanNumber]             VARCHAR (16)    NULL,
    [CACN]                           VARCHAR (32)    NULL,
    [mbrVendorId]                    VARCHAR (6)     NULL,
    [SensitiveFlag]                  VARCHAR (6)     NULL,
    [SensitiveFlagDateUpdate]        DATETIME        NULL,
    [ClaimVendorId]                  CHAR (6)        NULL,
    CONSTRAINT [PK_SedgwickClaimRecord_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IDX_ClaimUniqueId]
    ON [dbo].[SedgwickClaimRecord]([Id] ASC)
    INCLUDE([ClaimUniqueId]);


GO
CREATE NONCLUSTERED INDEX [IDX_ClaimNumShortVendorId]
    ON [dbo].[SedgwickClaimRecord]([ClaimNumber] ASC, [ShortVendorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_PackedClaimNumber]
    ON [dbo].[SedgwickClaimRecord]([PackedClaimNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ClaimID]
    ON [dbo].[SedgwickClaimRecord]([ClaimID] ASC);


GO
create TRIGGER [dbo].[SedgwickClaimRecord_InsUpd_Trigger] ON [dbo].[SedgwickClaimRecord]
AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	IF UPDATE(ClaimUniqueId)
	BEGIN
		UPDATE SedgwickClaimRecord 
			SET SedgwickClaimRecord.ClaimID = CONVERT(NUMERIC(27,3), Inserted.ClaimUniqueID)
		  FROM Inserted
		  WHERE SedgwickClaimRecord.Id = Inserted.Id
	END
END
GO
CREATE NONCLUSTERED INDEX [IX_SedgwickClaimRecord_DateOfInjuryClaimantDOB]
    ON [dbo].[SedgwickClaimRecord]([DateOfInjury] ASC, [ClaimantDOB] ASC);


GO
CREATE NONCLUSTERED INDEX [ClaimUniqueId_Includes]
    ON [dbo].[SedgwickClaimRecord]([ClaimUniqueId] ASC)
    INCLUDE([ClaimNumber], [ShortVendorId], [DateOfInjury], [ClaimantDOB], [PackedClaimNumber]);

