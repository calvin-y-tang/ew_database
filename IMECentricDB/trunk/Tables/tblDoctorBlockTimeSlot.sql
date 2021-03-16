CREATE TABLE [dbo].[tblDoctorBlockTimeSlot] (
    [DoctorBlockTimeSlotID]       INT          IDENTITY (1, 1) NOT NULL,
    [DoctorBlockTimeDayID]        INT          NOT NULL,
    [DoctorBlockTimeSlotStatusID] INT          NOT NULL,
    [StartTime]                   DATETIME     NOT NULL,
    [Duration]                    INT          NULL,
    [DisplayOrder]                INT          NULL,
    [HoldDescription]             VARCHAR (70) NULL,
    [CaseApptRequestID]           INT          NULL,
    [CaseApptID]                  INT          NULL,
    [DateAdded]                   DATETIME     NULL,
    [UserIDAdded]                 VARCHAR (15) NULL,
    [DateEdited]                  DATETIME     NULL,
    [UserIDEdited]                VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorBlockTimeSlot] PRIMARY KEY CLUSTERED ([DoctorBlockTimeSlotID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorBlockTimeSlot_DoctorBlockTimeDayIDStartTime]
ON [dbo].[tblDoctorBlockTimeSlot] ([DoctorBlockTimeDayID],[StartTime]);
