CREATE TABLE [dbo].[tblCustomerMapping] (
    [CustomerMappingID]   INT          IDENTITY (1, 1) NOT NULL,
    [EntityType]          VARCHAR (2)  NOT NULL,
    [EntityID]            INT          NOT NULL,
    [TableType]           VARCHAR (50) NOT NULL,
    [TableKey]            INT          NOT NULL,
    [MappingName]         VARCHAR (50) NOT NULL,
    [MappingValue]        VARCHAR (50) NOT NULL,
    [IsPrimary]           BIT          NOT NULL CONSTRAINT [DF_tblCustomerMapping_IsPrimary] DEFAULT 0,
    CONSTRAINT [PK_tblCustomerMapping] PRIMARY KEY CLUSTERED ([CustomerMappingID] ASC)
);

