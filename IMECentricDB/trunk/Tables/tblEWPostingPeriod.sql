CREATE TABLE [dbo].[tblEWPostingPeriod] (
    [PostingPeriodID] INT IDENTITY (1, 1) NOT NULL,
    [OpenMonth]       INT NOT NULL,
    [OpenYear]        INT NOT NULL,
    CONSTRAINT [PK_tblEWPostingPeriod] PRIMARY KEY CLUSTERED ([PostingPeriodID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWPostingPeriod_OpenYearOpenMonth]
    ON [dbo].[tblEWPostingPeriod]([OpenYear] ASC, [OpenMonth] ASC);

