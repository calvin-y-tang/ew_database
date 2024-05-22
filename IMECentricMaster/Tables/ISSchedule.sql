CREATE TABLE [dbo].[ISSchedule] (
    [ScheduleID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]         VARCHAR (35)  NULL,
    [Task]         VARCHAR (50)  NOT NULL,
    [Type]         VARCHAR (1)   NOT NULL,
    [Interval]     INT           NOT NULL,
    [WeekDays]     CHAR (7)      NOT NULL,
    [Time]         SMALLDATETIME NOT NULL,
    [StartDate]    SMALLDATETIME NOT NULL,
    [EndDate]      SMALLDATETIME NULL,
    [RunTimeStart] SMALLDATETIME NULL,
    [RunTimeEnd]   SMALLDATETIME NULL,
    [Param]        VARCHAR (8000) NULL,
    [GroupNo]      INT           NULL,
    [SeqNo]        INT           NULL,
    CONSTRAINT [PK_ISSchedule] PRIMARY KEY CLUSTERED ([ScheduleID] ASC) WITH (FILLFACTOR = 90)
);

