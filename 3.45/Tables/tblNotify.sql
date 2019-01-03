CREATE TABLE [dbo].[tblNotify]
(
	[NotifyID]			INT				IDENTITY (1,1)		NOT NULL,
	[UserID]			INT				NOT NULL,
	[UserType]			VARCHAR(2)		NULL,
    [NotifyEventID]  INT          NOT NULL,
    [NotifyMethodID] INT          NOT NULL,
	[CaseNbr]			INT				NULL,
	[ActionType]		VARCHAR(20)		NULL,
	[ActionKey]			INT				NULL,
	[DateDelivered]		DATETIME		NULL,
	[DateAdded]			DATETIME		NULL,
	[UserIDAdded]		VARCHAR(15)		NULL,
	[TableType] VARCHAR(50) NULL, 
    [UserCode] INT NULL, 
    CONSTRAINT [PK_tblNotify] PRIMARY KEY CLUSTERED ([NotifyID] ASC)

)
