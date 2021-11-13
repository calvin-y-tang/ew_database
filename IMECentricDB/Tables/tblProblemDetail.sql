CREATE TABLE [dbo].[tblProblemDetail]
(
	[ProblemAreaCode] INT NOT NULL , 
    [ProblemCode] INT NOT NULL, 
    [DateAdded] DATETIME NULL, 
    [UserIDAdded] VARCHAR(15) NULL, 
    [DateEdited] DATETIME NULL, 
    [UserIDEdited] VARCHAR(15) NULL, 
    CONSTRAINT [PK_tblProblemDetail] PRIMARY KEY CLUSTERED ([ProblemCode] ASC, [ProblemAreaCode] ASC)	
)
