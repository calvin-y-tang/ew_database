CREATE TABLE [dbo].[tblEmployer]
(
	[EmployerID]         INT         IDENTITY NOT NULL, 
    [Name]               VARCHAR(70) NULL, 
    [DateAdded]          DATETIME    NULL, 
    [UserIDAdded]        VARCHAR(15) NULL, 
    [DateEdited]         DATETIME    NULL, 
    [UserIDEdited]       VARCHAR(15) NULL,
	[EWParentEmployerID] INT         NOT NULL
	CONSTRAINT [PK_tblEmployer] PRIMARY KEY CLUSTERED ([EmployerID] ASC)
)
