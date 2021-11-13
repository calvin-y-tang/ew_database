CREATE TABLE [dbo].[tblCodes] (
    [CodeID]      INT           IDENTITY (1, 1) NOT NULL,
    [Category]    VARCHAR (50)  NULL,
    [SubCategory] VARCHAR (100) NULL,
    [Value]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tblCodes] PRIMARY KEY CLUSTERED ([CodeID] ASC)
);

