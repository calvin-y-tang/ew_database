PRINT N'Altering [dbo].[tblTempData]...';


GO
ALTER TABLE [dbo].[tblTempData]
    ADD [VarCharValue1] VARCHAR (100) NULL;


GO

UPDATE tblControl SET DBVersion='3.31'
GO
