CREATE TABLE [dbo].[tblProblemArea]
(
	[ProblemAreaCode] INT  IDENTITY (1,1)  NOT NULL, 
    [Description] VARCHAR(50) NULL, 
    [DateAdded] DATETIME NULL, 
    [UserIDAdded] VARCHAR(15) NULL, 
    [DateEdited] DATETIME NULL, 
    [UserIDEdited] VARCHAR(15) NULL
	CONSTRAINT [PK_tblProblemArea] PRIMARY KEY CLUSTERED ([ProblemAreaCode] ASC)
)
