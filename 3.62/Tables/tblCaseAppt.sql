CREATE TABLE [dbo].[tblCaseAppt] (
    [CaseApptID]              INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                 INT           NOT NULL,
    [ApptTime]                DATETIME      NOT NULL,
    [DoctorCode]              INT           NULL,
    [LocationCode]            INT           NULL,
    [SpecialtyCode]           VARCHAR (50)  NULL,
    [ApptStatusID]            INT           NOT NULL,
    [DateAdded]               DATETIME      NULL,
    [UserIDAdded]             VARCHAR (15)  NULL,
    [DateEdited]              DATETIME      NULL,
    [UserIDEdited]            VARCHAR (15)  NULL,
    [CanceledByID]            INT           NULL,
    [Reason]                  VARCHAR (300) NULL,
    [LastStatusChg]           DATETIME      NULL,
    [DateReceived]            DATETIME      NULL,
    [EWFeeZoneID]             INT           NULL,
    [ConfirmAttemptsExaminee] INT           NULL,
    [ConfirmAttemptsAttorney] INT           NULL,
    [DateClientNotified]      DATETIME      NULL,
    [ApptConfirmedByExaminee] BIT           CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByExaminee] DEFAULT ((0)) NOT NULL,
    [DateConfirmedByExaminee] DATETIME      NULL,
    [ApptConfirmedByAttorney] BIT           CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByAttorney] DEFAULT ((0)) NOT NULL,
    [DateConfirmedByAttorney] DATETIME      NULL,
    [ApptAttendance]          VARCHAR (300) NULL,
    [CancelReasonDetailID]    INT           NULL,
    [AwaitingScheduling]      DATETIME      NULL,
    [DoctorScheduledRank]     INT           NULL,
    [ScheduleMethod]          INT           NULL,
	[Duration]                INT           NULL,
    CONSTRAINT [PK_tblCaseAppt] PRIMARY KEY CLUSTERED ([CaseApptID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_CaseNbr]
    ON [dbo].[tblCaseAppt]([CaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_ApptTimeApptStatusID]
    ON [dbo].[tblCaseAppt]([ApptTime] ASC, [ApptStatusID] ASC);

