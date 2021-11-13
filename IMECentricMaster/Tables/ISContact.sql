CREATE TABLE [dbo].[ISContact] (
    [ContactID]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]              TINYINT       NOT NULL,
    [Name]              VARCHAR (128) NOT NULL,
    [Phone]             VARCHAR (10)  NULL,
    [EmailAddress]      VARCHAR (64)  NULL,
    [BusinessUnitName]  VARCHAR (64)  NULL,
    [CustomerID]        INT           NOT NULL,
    [Owner]             TINYINT       NOT NULL,
    [EmailNotification] BIT           NOT NULL,
    [Note]              VARCHAR (MAX) NULL,
    CONSTRAINT [PK_ISContact] PRIMARY KEY CLUSTERED ([ContactID] ASC),
    CONSTRAINT [FK_ISContact_ISCustomer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[ISCustomer] ([CustomerID])
);

