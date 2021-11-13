CREATE TABLE [dbo].[tblCustomerMapping] (
    [CustomerMappingID] INT           IDENTITY (1, 1) NOT NULL,
    [EntityType]        VARCHAR (2)   NOT NULL,
    [EntityID]          INT           NOT NULL,
    [TableType]         VARCHAR (50)  NOT NULL,
    [TableKey]          INT           NOT NULL,
    [MappingName]       VARCHAR (50)  NOT NULL,
    [MappingValue]      VARCHAR (100) NOT NULL,
    [IsPrimary]         BIT           CONSTRAINT [DF_tblCustomerMapping_IsPrimary] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblCustomerMapping] PRIMARY KEY CLUSTERED ([CustomerMappingID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCustomerMapping_MappingNameTableTypeTableKeyEntityTypeEntityID]
    ON [dbo].[tblCustomerMapping]([MappingName] ASC, [TableType] ASC, [TableKey] ASC, [EntityType] ASC, [EntityID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCustomerMapping_EntityTypeEntityIDTableType]
    ON [dbo].[tblCustomerMapping]([EntityType] ASC, [EntityID] ASC, [TableType] ASC);

