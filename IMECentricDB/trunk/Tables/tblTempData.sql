CREATE TABLE [dbo].[tblTempData] (
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT NULL,
    [SessionID]      VARCHAR (50)  NOT NULL,
    [ModuleName]     VARCHAR (50)  NOT NULL,
    [DateAdded]      DATETIME      NULL,
    [UserID]         VARCHAR (50)  NULL,
    [IntValue1]      INT           NULL,
    [BitValue1]      BIT           NULL,
    [IntValue2]      INT           NULL,
    [VarCharValue1]  VARCHAR (100) NULL,
    [IntValue3]      INT           NULL, 
    [DateTimeValue1] DATETIME      NULL, 
    [VarCharValue2]  VARCHAR(100)  NULL, 
    [BitValue2]      BIT           NULL,
    [VarCharValue3]  VARCHAR(100)  NULL, 
    CONSTRAINT [PK_tblTempData] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblTempData_SessionIDModuleName]
    ON [dbo].[tblTempData]([SessionID] ASC, [ModuleName] ASC)
    INCLUDE([IntValue1], [BitValue1]);

