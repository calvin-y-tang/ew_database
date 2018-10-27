CREATE TABLE [dbo].[SedgwickClaimContactInformationRecord] (
    [Id]                            INT             IDENTITY (1, 1) NOT NULL,
    [ClientNumber]                  INT             NOT NULL,
    [ClaimNumber]                   VARCHAR (32)    NOT NULL,
    [ShortVendorId]                 VARCHAR (8)     NOT NULL,
    [CMSProcessingOffice]           INT             NOT NULL,
    [ClaimUniqueId]                 VARCHAR (32)    NOT NULL,
    [ClaimSystemId]                 VARCHAR (32)    NOT NULL,
    [TransactionType]               VARCHAR (8)     NULL,
    [NameType]                      CHAR (1)        NULL,
    [Facility]                      VARCHAR (64)    NULL,
    [Title]                         VARCHAR (10)    NULL,
    [FirstName]                     VARCHAR (32)    NULL,
    [LastName]                      VARCHAR (64)    NULL,
    [Speciality]                    VARCHAR (32)    NULL,
    [Address1]                      VARCHAR (32)    NULL,
    [Address2]                      VARCHAR (32)    NULL,
    [City]                          VARCHAR (20)    NULL,
    [State]                         CHAR (2)        NULL,
    [Zip]                           VARCHAR (18)    NULL,
    [Country]                       CHAR (3)        NULL,
    [Phone1]                        VARCHAR (18)    NULL,
    [PhoneExt1]                     INT             NULL,
    [Phone2]                        VARCHAR (18)    NULL,
    [PhoneExt2]                     INT             NULL,
    [FaxNumber]                     VARCHAR (18)    NULL,
    [BestContactDate]               DATETIME        NULL,
    [BestContractTime]              DATETIME        NULL,
    [FederalTaxID]                  INT             NULL,
    [FederalTaxIDSub]               CHAR (3)        NULL,
    [Comment]                       VARCHAR (50)    NULL,
    [Authorize]                     CHAR (1)        NULL,
    [AuthorizationBeginDate]        DATETIME        NULL,
    [AuthorizationEndDate]          DATETIME        NULL,
    [AddressRecordInternalUniqueID] VARCHAR (20)    NULL,
    [EmailAddress]                  VARCHAR (320)   NULL,
    [ClaimRecordId]                 INT             NOT NULL,
    [ClaimID]                       NUMERIC (27, 3) DEFAULT ((0.0)) NOT NULL,
    CONSTRAINT [PK_SedgwickClaimContactInformationRecord] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClaimNumberShortVendorId]
    ON [dbo].[SedgwickClaimContactInformationRecord]([ClaimNumber] ASC, [ShortVendorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ClaimID]
    ON [dbo].[SedgwickClaimContactInformationRecord]([ClaimID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ClaimUniqueId]
    ON [dbo].[SedgwickClaimContactInformationRecord]([ClaimUniqueId] ASC);


GO

CREATE TRIGGER [dbo].[SedgwickClaimContactInformationRecord_InsUpd_Trigger]
    ON [dbo].[SedgwickClaimContactInformationRecord]
    AFTER INSERT, UPDATE
    AS 
    BEGIN
		SET NOCOUNT ON;
		IF UPDATE(ClaimUniqueId)
		BEGIN
			UPDATE SedgwickClaimContactInformationRecord 
				SET SedgwickClaimContactInformationRecord.ClaimID = CONVERT(NUMERIC(27,3), Inserted.ClaimUniqueID)
			FROM Inserted
			WHERE SedgwickClaimContactInformationRecord.Id = Inserted.Id
		END
    END
    