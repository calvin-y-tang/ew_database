CREATE TABLE [dbo].[tblGPInvoice] (
    [PrimaryKey]  INT      IDENTITY (1, 1) NOT NULL,
    [CompanyCode] INT      CONSTRAINT [DF_tblGPInvoice_CompanyCode] DEFAULT ((0)) NOT NULL,
    [ClientCode]  INT      CONSTRAINT [DF_tblGPInvoice_ClientCode] DEFAULT ((0)) NOT NULL,
    [Exported]    BIT      NULL,
    [ExportDate]  DATETIME NULL,
    [InvHeaderID] INT      NOT NULL,
    CONSTRAINT [PK_tblGPInvoice] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

