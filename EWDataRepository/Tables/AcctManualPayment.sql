CREATE TABLE [dbo].[AcctManualPayment] (
    [ManualPaymentID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]        INT           NULL,
    [PaymentType]     INT           NULL,
    [PaymentNo]       VARCHAR (20)  NULL,
    [PaymentDate]     DATETIME      NULL,
    [ServiceDate]     DATETIME      NULL,
    [EWFacilityID]    INT           NULL,
    [EWLocationID]    INT           NULL,
    [CaseNo]          VARCHAR (15)  NULL,
    [BatchNo]         INT           NULL,
    [TotalAmount]     MONEY         NULL,
    [MonetaryUnit]    INT           NULL,
    [PayeeName]       VARCHAR (100) NULL,
    [GPExportStatus]  INT           NULL,
    CONSTRAINT [PK__AcctManualPayment] PRIMARY KEY CLUSTERED ([ManualPaymentID] ASC)
);

