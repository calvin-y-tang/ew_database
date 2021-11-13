CREATE TABLE [dbo].[tblDoctorSchedule] (
    [SchedCode]    INT          IDENTITY (1, 1) NOT NULL,
    [LocationCode] INT          NOT NULL,
    [date]         DATETIME     NOT NULL,
    [StartTime]    DATETIME     NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [Status]       VARCHAR (15) CONSTRAINT [DF_tblDoctorSchedule_Status] DEFAULT ('Open') NULL,
    [Duration]     INT          NULL,
    [CaseNbr1]     INT          NULL,
    [CaseNbr1desc] VARCHAR (70) NULL,
    [CaseNbr2]     INT          NULL,
    [CaseNbr2desc] VARCHAR (70) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    [DoctorCode]   INT          NOT NULL,
    [blnSelect]    BIT          CONSTRAINT [DF_tblDoctorSchedule_blnSelect] DEFAULT ((0)) NULL,
    [CaseNbr3]     INT          NULL,
    [CaseNbr3Desc] VARCHAR (70) NULL,
    [BlockType]    INT          NULL,
    [WasScheduled] BIT          CONSTRAINT [DF_tblDoctorSchedule_WasScheduled] DEFAULT ((0)) NOT NULL, 
    [CaseNbr4]     INT          NULL,
    [CaseNbr4Desc] VARCHAR (70) NULL,
    [CaseNbr5]     INT          NULL,
    [CaseNbr5Desc] VARCHAR (70) NULL,
    [CaseNbr6]     INT          NULL,
    [CaseNbr6Desc] VARCHAR (70) NULL,
    CONSTRAINT [PK_tblDoctorSchedule] PRIMARY KEY CLUSTERED ([SchedCode] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc]
    ON [dbo].[tblDoctorSchedule]([Status] ASC, [DoctorCode] ASC, [date] ASC, [SchedCode] ASC, [LocationCode] ASC, [StartTime] ASC, [Description] ASC, [CaseNbr1desc] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_dateLocationCode]
    ON [dbo].[tblDoctorSchedule]([date] ASC, [LocationCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_dateDoctorCode]
    ON [dbo].[tblDoctorSchedule]([date] ASC, [DoctorCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_CaseNbr1]
    ON [dbo].[tblDoctorSchedule]([CaseNbr1] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_LocationCodeStatusDoctorCodeDate]
    ON [dbo].[tblDoctorSchedule]([LocationCode] ASC, [Status] ASC, [DoctorCode] ASC, [date] ASC)
    INCLUDE([StartTime], [Description], [CaseNbr1desc]);
GO
