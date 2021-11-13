CREATE TABLE [dbo].[tblEWCoverLetterState] (
    [EWCoverLetterStateID] INT          NOT NULL,
    [EWCoverLetterID]      INT          NOT NULL,
    [StateCode]            VARCHAR (2)  NOT NULL,
    [UserIDAdded]          VARCHAR (30) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    CONSTRAINT [PK_tblEWCoverLetterState] PRIMARY KEY CLUSTERED ([EWCoverLetterStateID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterState_EWCoverLetterIDStateCode]
    ON [dbo].[tblEWCoverLetterState]([EWCoverLetterID] ASC, [StateCode] ASC);

