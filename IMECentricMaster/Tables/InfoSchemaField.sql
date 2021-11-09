CREATE TABLE [dbo].[InfoSchemaField] (
    [TableName]          VARCHAR (128) NOT NULL,
    [FieldName]          VARCHAR (128) NOT NULL,
    [FieldPos]           SMALLINT      NULL,
    [DisplayName]        VARCHAR (128) NULL,
    [AliasName]          VARCHAR (128) NULL,
    [Visible]            BIT           NULL,
    [FieldKind]          VARCHAR (10)  NULL,
    [FieldExpression]    VARCHAR (128) NULL,
    [SQLDataType]        INT           NULL,
    [SQLDataTypeName]    VARCHAR (20)  NULL,
    [DelphiDataTypeName] VARCHAR (20)  NULL,
    [FieldSize]          SMALLINT      NULL,
    [Precision]          TINYINT       NULL,
    [Scale]              TINYINT       NULL,
    [PrimaryKey]         BIT           NULL,
    [IsIdentity]         BIT           NULL,
    [AllowNulls]         BIT           NULL,
    CONSTRAINT [PK_InfoSchemaField] PRIMARY KEY CLUSTERED ([TableName] ASC, [FieldName] ASC)
);

