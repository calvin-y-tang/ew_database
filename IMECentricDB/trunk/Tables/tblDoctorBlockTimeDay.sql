CREATE TABLE [dbo].[tblDoctorBlockTimeDay] (
    [DoctorBlockTimeDayID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]           INT          NOT NULL,
    [LocationCode]         INT          NOT NULL,
    [ScheduleDate]         DATETIME     NOT NULL,
    [Active]               BIT          CONSTRAINT [DF_tblDoctorBlockTimeDay_Active] DEFAULT ((0)) NOT NULL,
    [MaxSlotOnWeb]         INT          NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorBlockTimeDay] PRIMARY KEY CLUSTERED ([DoctorBlockTimeDayID] ASC)
);




GO


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]
    ON [dbo].[tblDoctorBlockTimeDay]([ScheduleDate] ASC, [DoctorCode] ASC, [LocationCode] ASC);

