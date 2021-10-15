CREATE TABLE [dbo].[tblTATCalculationGroupDetail] (
    [TATCalculationGroupID] INT NOT NULL,
    [TATCalculationMethodID] INT NOT NULL,
    [DisplayOrder]          INT NOT NULL,
    CONSTRAINT [PK_tblTATCalculationGroupDetail] PRIMARY KEY CLUSTERED ([TATCalculationGroupID] ASC, [TATCalculationMethodID] ASC)
);

