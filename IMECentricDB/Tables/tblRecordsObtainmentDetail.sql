CREATE TABLE [dbo].[tblRecordsObtainmentDetail] (
    [RecordsDetailID]        INT          IDENTITY (1, 1) NOT NULL,
    [RecordsID]              INT          NOT NULL,
    [ObtainmentTypeDetailID] INT          NULL,
    [DateOfService]          DATETIME     NULL,
    [DateReceived]           DATETIME     NULL,
    [UserIDAdded]            VARCHAR (50) NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDEdited]           VARCHAR (50) NULL,
    [DateEdited]             DATETIME     NULL,
    [NotAvailable]           BIT          CONSTRAINT [DF_tblRecordsObtainmentDetail_NotAvailable] DEFAULT (0) NULL,
    [DateReturned]           DATETIME     NULL,
    CONSTRAINT [PK_tblRecordsObtainmentDetail] PRIMARY KEY CLUSTERED ([RecordsDetailID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblRecordsObtainmentDetail_RecordsID]
    ON [dbo].[tblRecordsObtainmentDetail]([RecordsID] ASC);

