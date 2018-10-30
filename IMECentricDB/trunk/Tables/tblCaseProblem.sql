CREATE TABLE [dbo].[tblCaseProblem] (
    [CaseNbr]     INT          NOT NULL,
    [ProblemCode] INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [ProblemAreaCode] INT NULL, 
    CONSTRAINT [PK_tblCaseProblem] PRIMARY KEY CLUSTERED ([CaseNbr] ASC, [ProblemCode] ASC)
);

