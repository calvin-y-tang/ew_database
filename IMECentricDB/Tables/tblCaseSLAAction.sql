CREATE TABLE [dbo].[tblCaseSLAAction] (
    [CaseSLAActionID]     INT           IDENTITY (1, 1) NOT NULL,
    [CaseSLARuleDetailID] INT           NOT NULL,
    [DateAdded]           DATETIME      NOT NULL,
    [UserIDAdded]         VARCHAR (15)  NULL,
    [SLAActionID]         INT           NOT NULL,
    [Comment]             VARCHAR (100) NULL,
    [ForDSE]              BIT           CONSTRAINT [DF_tblCaseSLAAction_ForDSE] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblCaseSLAAction] PRIMARY KEY CLUSTERED ([CaseSLAActionID] ASC)
);



GO

CREATE INDEX [IX_tblCaseSLAAction_CaseSLARuleDetailID] ON [dbo].[tblCaseSLAAction] ([CaseSLARuleDetailID])
GO

