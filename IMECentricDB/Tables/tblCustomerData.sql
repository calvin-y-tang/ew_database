CREATE TABLE [dbo].[tblCustomerData] (
    [CustomerDataID] INT            IDENTITY (1, 1) NOT NULL,
    [Version]        INT            NOT NULL,
    [TableType]      VARCHAR (64)   NOT NULL,
    [TableKey]       INT            NOT NULL,
    [Param]          VARCHAR (MAX) NOT NULL,
    [CustomerName]   VARCHAR (64)   NOT NULL,
    CONSTRAINT [PK_tblCustomerData] PRIMARY KEY CLUSTERED ([CustomerDataID] ASC)
);

GO
CREATE INDEX [IX_tblCustomerData_TypeKeyName] ON [dbo].[tblCustomerData] ([TableType] ASC,[TableKey] ASC,[CustomerName] ASC)
