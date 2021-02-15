CREATE TABLE [dbo].[tblSLAAction]
(
	[SLAActionID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] VARCHAR(25) NULL, 
    [RequireComment] BIT NOT NULL DEFAULT 0, 
    [IsResolution] BIT NOT NULL DEFAULT 0
)
