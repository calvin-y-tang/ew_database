CREATE TABLE [dbo].[tblGPInvoiceEDIStatus] (
    [PrimaryKey]        INT           IDENTITY (1, 1) NOT NULL,
    [ExportDate]        DATETIME      NULL,
    [EDIStatus]         VARCHAR (15)  NULL,
    [EDINote]           VARCHAR (250) NULL,
    [ClientContractNbr] INT           NULL,
    [ClientName]        VARCHAR (100) NULL,
    [ICN]               VARCHAR (32)  NULL,
    [InvHeaderID]       INT           NOT NULL,
    CONSTRAINT [PK_tblGPInvoiceEDIStatus] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

