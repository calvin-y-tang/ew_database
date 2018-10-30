CREATE TABLE [dbo].[tblProblem] (
    [ProblemCode]  INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [Status]       VARCHAR (10) CONSTRAINT [DF_tblproblem_status] DEFAULT ('Active') NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    [PublishOnWeb] BIT          NULL,
    [WebSynchDate] DATETIME     NULL,
    [WebID]        INT          NULL,
    CONSTRAINT [PK_tblProblem] PRIMARY KEY CLUSTERED ([ProblemCode] ASC)
);

