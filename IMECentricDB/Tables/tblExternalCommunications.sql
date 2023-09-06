CREATE TABLE [dbo].[tblExternalCommunications]
(
    [CommunicationID]   INT            IDENTITY (1, 1) NOT NULL,
    [DateAdded]         DATETIME       NOT NULL,
    [EventDate]         DATETIME       NOT NULL,
    [CaseNbr]           INT            NULL,
    [ChartNbr]          INT            NULL,
    [CaseHistoryID]     INT            NULL,
    [UserID]            VARCHAR (15)   NULL,
    [DoctorCode]        INT            NULL,
    [DoctorSpecialty]   VARCHAR (500)  NULL,
    [ApptDateTime]      DATETIME       NULL,
    [DateCanceled]      DATETIME       NULL,
    [CaseHistoryType]   VARCHAR (20)   NULL,
    [EWBusLineID]       INT            NULL,
    [EWServiceTypeID]   INT            NULL,
    [OfficeCode]        INT            NULL,
    [ApptLocationCode]  INT            NULL,
    [ClaimNbr]          VARCHAR (50)   NULL,
    [EWFacilityID]      INT            NULL,
    [BusUnitGroupID]    INT            NULL,
    [CommunicationSent] DATETIME       NULL,
    [CommunicationAck]  DATETIME       NULL,
    [LastError]         VARCHAR (1024) NULL,
    [Overridden]        BIT            NULL,
    [TransmitFileName]  VARCHAR (256)  NULL,
    [AckFileName]       VARCHAR (256)  NULL,
    [BulkBillingID]     INT            NULL,
    [EntityType] VARCHAR(32) NULL, 
    [EntityID] VARCHAR(64) NULL, 
    CONSTRAINT [PK_tblExternalCommunications] PRIMARY KEY CLUSTERED ([CommunicationID] ASC)
)

GO

GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_CaseNbrCaseHistoryID]
    ON [dbo].[tblExternalCommunications]([CaseNbr] ASC, [CaseHistoryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_BulkBillingIDCommunicationSent]
    ON [dbo].[tblExternalCommunications]([BulkBillingID] ASC, [CommunicationSent] ASC);

