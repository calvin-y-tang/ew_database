PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [CbxWaitInterval]  INT          NULL,
        [XMediusFaxPrefix] VARCHAR (10) NULL;


GO
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [ExpectedVisitDuration] VARCHAR (25) NULL;


GO
PRINT N'Altering [dbo].[tblFeeHeader]...';


GO
ALTER TABLE [dbo].[tblFeeHeader]
    ADD [FeeCalcMethod] INT NULL;


GO
PRINT N'Altering [dbo].[tblIMEData]...';


GO
ALTER TABLE [dbo].[tblIMEData]
    ADD [FeeCalcMethod] INT NULL;


GO

UPDATE tblControl SET DBVersion='2.78'
GO