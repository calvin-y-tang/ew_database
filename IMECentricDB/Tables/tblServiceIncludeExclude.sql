CREATE TABLE [dbo].[tblServiceIncludeExclude]
(
    [Code]        INT          NOT NULL,
    [Type]        VARCHAR (2)  NOT NULL,
    [ServiceCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServiceIncludeExclude] PRIMARY KEY CLUSTERED ([Code] ASC, [Type] ASC, [ServiceCode] ASC)
)
