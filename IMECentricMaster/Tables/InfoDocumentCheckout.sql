CREATE TABLE [dbo].[InfoDocumentCheckout] (
    [CheckoutID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DocumentID]   INT           NULL,
    [UserID]       INT           NULL,
    [CheckoutDate] DATETIME      NULL,
    [CheckoutDir]  VARCHAR (250) NULL,
    CONSTRAINT [PK_InfoDocumentCheckout] PRIMARY KEY CLUSTERED ([CheckoutID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoDocumentCheckout_DocumentID]
    ON [dbo].[InfoDocumentCheckout]([DocumentID] ASC);

