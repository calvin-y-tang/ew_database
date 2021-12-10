CREATE TABLE [dbo].[tblEWFacility] (
    [EWFacilityID]              INT           NOT NULL,
    [FacilityName]              VARCHAR (40)  NULL,
    [LegalName]                 VARCHAR (40)  NULL,
    [SeqNo]                     INT           NULL,
    [DBID]                      INT           NULL,
    [ShortName]                 VARCHAR (20)  NULL,
    [Accting]                   VARCHAR (5)   NULL,
    [GPFacility]                VARCHAR (3)   NULL,
    [Address]                   VARCHAR (50)  NULL,
    [City]                      VARCHAR (20)  NULL,
    [State]                     VARCHAR (3)   NULL,
    [Zip]                       VARCHAR (10)  NULL,
    [Phone]                     VARCHAR (25)  NULL,
    [Fax]                       VARCHAR (25)  NULL,
    [Region]                    VARCHAR (15)  NULL,
    [FedTaxID]                  VARCHAR (20)  NULL,
    [DateAquired]               DATETIME      NULL,
    [DateIMECentric]            DATETIME      NULL,
    [Active]                    BIT           NULL,
    [DateGP]                    DATETIME      NULL,
    [Logo]                      VARCHAR (80)  NULL,
    [ContactOps]                VARCHAR (30)  NULL,
    [ContactAcct]               VARCHAR (30)  NULL,
    [InvRemitEWFacilityID]      INT           NULL,
    [AcctingPhone]              VARCHAR (25)  NULL,
    [AcctingFax]                VARCHAR (25)  NULL,
    [RemitAddress]              VARCHAR (50)  NULL,
    [RemitCity]                 VARCHAR (20)  NULL,
    [RemitState]                VARCHAR (3)   NULL,
    [RemitZip]                  VARCHAR (10)  NULL,
    [Website]                   VARCHAR (40)  NULL,
    [DRDataFeed]                INT           NULL,
    [DRHistory]                 INT           NULL,
    [CountryCode]               VARCHAR (2)   NULL,
    [ParentEWFacilityID]        INT           NULL,
    [MigratingClaimNotifyEmail] VARCHAR (140) NULL,
    [ReferralGroup]             INT           NULL,
    [DateDR]                    DATETIME      NULL,
    [EWServiceTypeID]           INT           NULL,
    [AltDBID]                   INT           NULL,
    [ReportDBID]				INT			  NULL, 
    CONSTRAINT [PK_tblEWFacility] PRIMARY KEY CLUSTERED ([EWFacilityID] ASC)
);

GO

CREATE TRIGGER [dbo].[tblEWFacility_AfterUpdate_TRG]
	ON [dbo].[tblEWFacility] 
AFTER UPDATE
AS 

BEGIN
     -- DEV NOTE: if an address field has changed - Address, City, State, Zip
	 -- delete this facility from tblTaxAddress
SET NOCOUNT ON

DELETE FROM tblTaxAddress 
WHERE TableType = 'OF' AND TableKey IN 
(SELECT DISTINCT inserted.EWFacilityID
   FROM  inserted
   INNER JOIN deleted
   ON inserted.EWFacilityID = deleted.EWFacilityID
   WHERE deleted.Address <> inserted.Address 
   OR deleted.City <> inserted.City 
   OR deleted.State <> inserted.State 
   OR deleted.Zip <> inserted.Zip
)

END
GO




