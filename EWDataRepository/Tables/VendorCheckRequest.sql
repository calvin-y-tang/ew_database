CREATE TABLE [dbo].[VendorCheckRequest] (
    [CheckRequestID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]       INT             NULL,
    [CheckReqNo]     INT             NULL,
    [RequestDate]    DATETIME        NULL,
    [ServiceDate]    DATETIME        NULL,
    [Comment]        VARCHAR (30)    NULL,
    [EWFacilityID]   INT             NULL,
    [EWLocationID]   INT             NULL,
    [DoctorID]       INT             NULL,
    [ClaimNo]        VARCHAR (50)    NULL,
    [CaseNo]         VARCHAR (15)    NULL,
    [Examinee]       VARCHAR (50)    NULL,
    [BatchNo]        INT             NULL,
    [TotalAmount]    MONEY           NULL,
    [MonetaryUnit]   INT             NULL,
    [ExchangeRate]   DECIMAL (15, 7) NULL,
    [TotalAmountUS]  MONEY           NULL,
    [User]           VARCHAR (25)    NULL,
    [Office]         VARCHAR (15)    NULL,
    [GPExportStatus] INT             NULL,
    CONSTRAINT [PK_VendorCheckRequest] PRIMARY KEY CLUSTERED ([CheckRequestID] ASC)
);

