CREATE TABLE [dbo].[tblProductOffice] (
    [ProdCode]    INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblProductOffice] PRIMARY KEY CLUSTERED ([ProdCode] ASC, [OfficeCode] ASC)
);

