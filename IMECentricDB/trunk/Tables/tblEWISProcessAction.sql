CREATE TABLE [dbo].[tblEWISProcessAction]
(
	[EWISProcessActionID] INT          IDENTITY (1, 1) NOT NULL,
	[DateAdded]           DATETIME     NOT NULL,
	[UserIDAdded]         VARCHAR(15)  NOT NULL, 
	[DateCompleted]       DATETIME     NULL,
	[StatusMessge]        VARCHAR(512) NULL, 
	[ProcessName]         VARCHAR(50)  NOT NULL, 
	[TableType]           VARCHAR(50)  NOT NULL, 
	[TableKey]            INT          NOT NULL, 
	[Date1]               DATETIME     NULL, 
	[Date2]               DATETIME     NULL, 
	[Int1]                DATETIME     NULL, 
	[Int2]                DATETIME     NULL,
	CONSTRAINT [PK_tblEWISProcessAction] PRIMARY KEY CLUSTERED ([EWISProcessActionID] ASC)
)
GO
CREATE NONCLUSTERED INDEX [IX_tblEWISProcessAction_DateCompletedProcessName]
	ON [dbo].tblEWISProcessAction([DateCompleted] ASC, [ProcessName] ASC);
