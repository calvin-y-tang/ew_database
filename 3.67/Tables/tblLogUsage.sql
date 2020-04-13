CREATE TABLE [dbo].[tblLogUsage] (
    [LogUsageID]  INT          IDENTITY (1, 1) NOT NULL,
    [UserID]      VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    [ModuleName]  VARCHAR (50) NULL,
    [LogDetail]   TEXT         NULL,
    [CaseNbr]     INT          NULL,
    [CompanyCode] INT          NULL,
    [ClientCode]  INT          NULL,
    [DoctorCode]  INT          NULL,
    CONSTRAINT [PK_tblLogUsage] PRIMARY KEY CLUSTERED ([LogUsageID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblLogUsage_DateAddedModuleName]
    ON [dbo].[tblLogUsage]([DateAdded] ASC, [ModuleName] ASC);

