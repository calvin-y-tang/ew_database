CREATE TABLE [dbo].[tblUserFunction] (
    [FunctionCode] VARCHAR (30) NOT NULL,
    [FunctionDesc] VARCHAR (50) NULL,
    [DateAdded] DATE NOT NULL CONSTRAINT [DF_tblUserFunction_DateAdded] DEFAULT GETDATE(), 
    CONSTRAINT [PK_tblUserFunction] PRIMARY KEY CLUSTERED ([FunctionCode] ASC)
);

