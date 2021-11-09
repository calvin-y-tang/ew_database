CREATE TABLE [dbo].[ISEncryptionKey] (
    [EncryptionKeyID] INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]            TINYINT          NOT NULL,
    [Value]           VARBINARY (8000) NOT NULL,
    [Active]          BIT              NOT NULL,
    [CustomerID]      INT              NOT NULL,
    [PEKDescription]  VARCHAR (64)     CONSTRAINT [DF_ISEncryptionKey_PEKDescription] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_ISEncryptionKey] PRIMARY KEY CLUSTERED ([EncryptionKeyID] ASC),
    CONSTRAINT [FK_ISEncryptionKeys_ISCustomer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[ISCustomer] ([CustomerID])
);

