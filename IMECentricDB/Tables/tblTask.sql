CREATE TABLE [dbo].[tblTask] (
    [TaskID]        INT           IDENTITY (1, 1) NOT NULL,
    [DateAdded]     DATETIME      NOT NULL,
    [UserIDAdded]   VARCHAR (15)  NOT NULL,
    [DateCompleted] DATETIME      NULL,
    [StatusMessge]  VARCHAR (512) NULL,
    [ProcessName]   VARCHAR (50)  NOT NULL,
    [TableType]     VARCHAR (50)  NOT NULL,
    [TableKey]      INT           NOT NULL,
    [Date1]         DATETIME      NULL,
    [Date2]         DATETIME      NULL,
    [Int1]          DATETIME      NULL,
    [Int2]          DATETIME      NULL,
    CONSTRAINT [PK_tblTask] PRIMARY KEY CLUSTERED ([TaskID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblTask_DateCompletedProcessName]
	ON [dbo].tblTask([DateCompleted] ASC, [ProcessName] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_tblTask_ProcessNameTableTypeDate1]
    ON [dbo].[tblTask]([ProcessName] ASC, [TableType] ASC, [Date1] ASC);

