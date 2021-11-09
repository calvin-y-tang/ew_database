CREATE TABLE [dbo].[EWCompanyDB] (
    [EWCompanyID] INT          NOT NULL,
    [DBID]        INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_EWCompanyDB] PRIMARY KEY CLUSTERED ([EWCompanyID] ASC, [DBID] ASC)
);

