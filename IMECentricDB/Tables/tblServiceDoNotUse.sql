CREATE TABLE [dbo].[tblServiceDoNotUse]
(
    [Code]        INT          NOT NULL,
    [Type]        VARCHAR (2)  NOT NULL,
    [ServiceCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServiceDoNotUse] PRIMARY KEY CLUSTERED ([Code] ASC, [Type] ASC, [ServiceCode] ASC)
)
