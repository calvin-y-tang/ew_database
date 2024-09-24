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
    [Int1]          INT           NULL,
    [Int2]          INT           NULL,
    [Int3]          INT           NULL,
    [Text1]         VARCHAR(256)  NULL,
    [Text2]         VARCHAR(120)  NULL,
    [Text3]         VARCHAR(4096) NULL,
    [Text4]         VARCHAR(4096) NULL,
    [Text5]         VARCHAR(512)  NULL,
    [Text6]         VARCHAR(MAX)  NULL,
    [Text7]         VARCHAR(4096) NULL,
    [Text8]         VARCHAR(50)   NULL,
    [Text9]         VARCHAR(4096) NULL,
    [Bit1]          Bit           NULL,
    CONSTRAINT [PK_tblTask] PRIMARY KEY CLUSTERED ([TaskID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblTask_DateCompletedProcessName]
	ON [dbo].tblTask([DateCompleted] ASC, [ProcessName] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_tblTask_ProcessNameTableTypeDate1]
    ON [dbo].[tblTask]([ProcessName] ASC, [TableType] ASC, [Date1] ASC);

