CREATE TABLE [dbo].[tblCaseAppt] (
    [CaseApptID]               INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                  INT           NOT NULL,
    [ApptTime]                 DATETIME      NOT NULL,
    [DoctorCode]               INT           NULL,
    [LocationCode]             INT           NULL,
    [SpecialtyCode]            VARCHAR (50)  NULL,
    [ApptStatusID]             INT           NOT NULL,
    [DateAdded]                DATETIME      NULL,
    [UserIDAdded]              VARCHAR (15)  NULL,
    [DateEdited]               DATETIME      NULL,
    [UserIDEdited]             VARCHAR (15)  NULL,
    [CanceledByID]             INT           NULL,
    [Reason]                   VARCHAR (300) NULL,
    [LastStatusChg]            DATETIME      NULL,
    [DateReceived]             DATETIME      NULL,
    [EWFeeZoneID]              INT           NULL,
    [ConfirmAttemptsExaminee]  INT           NULL, 
    [ConfirmAttemptsAttorney]  INT           NULL, 
    [DateClientNotified]       DATETIME      NULL, 
    [ApptConfirmedByExaminee]  BIT           NOT NULL CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByExaminee] DEFAULT 0, 
	[DateConfirmedByExaminee]  DATETIME      NULL,
    [ApptConfirmedByAttorney]  BIT           NOT NULL CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByAttorney] DEFAULT 0, 
	[DateConfirmedByAttorney]  DATETIME      NULL,
    [ApptAttendance]           VARCHAR(300)  NULL, 
	[CancelReasonDetailID]     INT           NULL,
    [AwaitingScheduling]       DATETIME      NULL,
	[DoctorScheduledRank]      INT           NULL,
	[ScheduleMethod]           INT           NULL,
    CONSTRAINT [PK_tblCaseAppt] PRIMARY KEY CLUSTERED ([CaseApptID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_CaseNbr]
    ON [dbo].[tblCaseAppt]([CaseNbr] ASC);

