CREATE TABLE [dbo].[GPManualPayment] (
    [PrimaryKey]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion] INT           NOT NULL,
    [ProcessedFlag] BIT           NOT NULL,
    [ExportDate]    DATETIME      NOT NULL,
    [BatchNo]       VARCHAR (15)  NOT NULL,
    [PaymentType]   INT           NULL,
    [PaymentNo]     VARCHAR (20)  NULL,
    [PaymentDate]   DATETIME      NULL,
    [ServiceDate]   DATETIME      NULL,
    [GPFacilityID]  VARCHAR (3)   NOT NULL,
    [CaseNo]        VARCHAR (15)  NULL,
    [TotalAmount]   MONEY         NULL,
    [PayeeName]     VARCHAR (100) NULL,
    CONSTRAINT [PK_GPManualPayment] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

