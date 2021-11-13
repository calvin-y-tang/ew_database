CREATE TABLE [dbo].[tblFSEntity]
(
	[FSEntityID]   INT IDENTITY (1, 1) NOT NULL, 
	[FSGroupID]    INT          NOT NULL, 
	[OfficeCode]   INT          NOT NULL,
	[EntityType]   CHAR(2)      NOT NULL,
	[EntityID]     INT          NOT NULL,
    [DateAdded]    DATETIME     NOT NULL,
    [UserIDAdded]  VARCHAR (30) NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
	CONSTRAINT [PK_tblFSEntity] PRIMARY KEY CLUSTERED ([FSEntityID] ASC)
)
