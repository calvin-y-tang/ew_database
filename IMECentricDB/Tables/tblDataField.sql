CREATE TABLE [dbo].[tblDataField] (
    [DataFieldID] INT          NOT NULL,
    [TableName]   VARCHAR (35) NULL,
    [FieldName]   VARCHAR (35) NULL,
    [Descrip]     VARCHAR (70) NULL,
    CONSTRAINT [PK_tblDataField] PRIMARY KEY CLUSTERED ([DataFieldID] ASC)
);



