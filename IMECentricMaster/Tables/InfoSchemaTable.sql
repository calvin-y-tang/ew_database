CREATE TABLE [dbo].[InfoSchemaTable] (
    [TableName]   VARCHAR (128) NOT NULL,
    [DisplayName] VARCHAR (128) NULL,
    [AliasName]   VARCHAR (128) NULL,
    [DBType]      INT           NULL,
    CONSTRAINT [PK_InfoSchemaTable] PRIMARY KEY CLUSTERED ([TableName] ASC)
);

