CREATE TABLE [dbo].[tblParamPropertyGroup]
(
	[ParamPropertyGroupID] INT IDENTITY (1, 1) NOT NULL,
	[Description]          VARCHAR(50)  NOT NULL, 
	[LabelText]            VARCHAR(20)  NOT NULL, 
	[Version]              INT          NOT NULL, 
	[DateAdded]            DATETIME NOT NULL, 
    [UserIDAdded]          VARCHAR(15) NOT NULL, 
	CONSTRAINT [PK_tblParamPropertyGroup] PRIMARY KEY CLUSTERED ([ParamPropertyGroupID] ASC)
)
