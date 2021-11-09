CREATE TABLE [dbo].[EWCoverLetterState] (
    [EWCoverLetterStateID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWCoverLetterID]      INT          NOT NULL,
    [StateCode]            VARCHAR (2)  NOT NULL,
    [UserIDAdded]          VARCHAR (30) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    CONSTRAINT [PK_EWCoverLetterState] PRIMARY KEY CLUSTERED ([EWCoverLetterStateID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWCoverLetterState_EWCoverLetterIDStateCode]
    ON [dbo].[EWCoverLetterState]([EWCoverLetterID] ASC, [StateCode] ASC);

