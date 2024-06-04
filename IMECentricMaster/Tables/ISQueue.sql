CREATE TABLE [dbo].[ISQueue] (
    [QueueID]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ScheduleID]   INT            NOT NULL,
    [Name]         VARCHAR (35)   NULL,
    [Task]         VARCHAR (50)   NOT NULL,
    [RunDateTime]  SMALLDATETIME  NOT NULL,
    [RunTimeStart] SMALLDATETIME  NULL,
    [RunTimeEnd]   SMALLDATETIME  NULL,
    [Param]        VARCHAR (8000) NULL,
    [GroupNo]      INT            NULL,
    [SeqNo]        INT            NULL,
    CONSTRAINT [PK_ISQueue] PRIMARY KEY CLUSTERED ([QueueID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_ISQueue_ScheduleID]
    ON [dbo].[ISQueue]([ScheduleID] ASC);

