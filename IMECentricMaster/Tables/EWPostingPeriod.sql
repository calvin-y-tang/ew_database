CREATE TABLE [dbo].[EWPostingPeriod] (
    [PostingPeriodID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OpenMonth]       INT NOT NULL,
    [OpenYear]        INT NOT NULL,
    CONSTRAINT [PK_EWPostingPeriod] PRIMARY KEY CLUSTERED ([PostingPeriodID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWPostingPeriod_OpenYearOpenMonth]
    ON [dbo].[EWPostingPeriod]([OpenYear] ASC, [OpenMonth] ASC);

