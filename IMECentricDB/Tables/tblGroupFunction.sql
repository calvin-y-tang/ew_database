CREATE TABLE [dbo].[tblGroupFunction] (
    [GroupCode]    VARCHAR (15) NOT NULL,
    [FunctionCode] VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_tblGroupFunction] PRIMARY KEY CLUSTERED ([GroupCode] ASC, [FunctionCode] ASC)
);

