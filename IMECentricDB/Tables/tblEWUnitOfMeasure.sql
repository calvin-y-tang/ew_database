CREATE TABLE [dbo].[tblEWUnitOfMeasure] (
    [UnitOfMeasureCode] VARCHAR (5)  NOT NULL,
    [Description]       VARCHAR (50) NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (30) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (30) NULL,
    CONSTRAINT [PK_tblEWUnitOfMeasure] PRIMARY KEY CLUSTERED ([UnitOfMeasureCode] ASC)
);

