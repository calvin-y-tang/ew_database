CREATE TABLE [dbo].[tblInvoiceAttachments] (
    [InvAttachID] INT         IDENTITY (1, 1) NOT NULL,
    [SeqNo]       INT         NULL,
    [AttachType]  VARCHAR (5) NULL,
    [InvHeaderID] INT         NULL,
    CONSTRAINT [PK_tblInvoiceAttachments] PRIMARY KEY CLUSTERED ([InvAttachID] ASC)
);
