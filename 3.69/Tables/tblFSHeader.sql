CREATE TABLE [dbo].[tblFSHeader]
(
	[FSHeaderID]   INT IDENTITY (1, 1) NOT NULL, 
	[FSGroupID]    INT          NOT NULL, 
	[StartDate]    DATETIME     NOT NULL, 
	[EndDate]      DATETIME     NULL,
    [DateAdded]    DATETIME     NOT NULL,
    [UserIDAdded]  VARCHAR (30) NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
	CONSTRAINT [PK_tblFSHeader] PRIMARY KEY CLUSTERED ([FSHeaderID] ASC)
)
