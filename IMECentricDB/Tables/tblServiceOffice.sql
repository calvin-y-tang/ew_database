CREATE TABLE [dbo].[tblServiceOffice] (
    [ServiceCode] INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServiceOffice] PRIMARY KEY CLUSTERED ([ServiceCode] ASC, [OfficeCode] ASC)
);

