CREATE TABLE [dbo].[SedgwickCodes] (
    [CodeID]          VARCHAR (8)   NOT NULL,
    [CodeType]        VARCHAR (16)  NOT NULL,
    [CodeDescription] VARCHAR (128) NULL,
    CONSTRAINT [PK_SedgwickCodes] PRIMARY KEY CLUSTERED ([CodeID] ASC, [CodeType] ASC)
);

