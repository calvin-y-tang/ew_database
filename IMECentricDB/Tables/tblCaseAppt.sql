CREATE TABLE [dbo].[tblCaseAppt] (
    [CaseApptID]                        INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]                           INT           NOT NULL,
    [ApptTime]                          DATETIME      NOT NULL,
    [DoctorCode]                        INT           NULL,
    [LocationCode]                      INT           NULL,
    [SpecialtyCode]                     VARCHAR (500) NULL,
    [ApptStatusID]                      INT           NOT NULL,
    [DateAdded]                         DATETIME      NULL,
    [UserIDAdded]                       VARCHAR (15)  NULL,
    [DateEdited]                        DATETIME      NULL,
    [UserIDEdited]                      VARCHAR (15)  NULL,
    [CanceledByID]                      INT           NULL,
    [Reason]                            VARCHAR (300) NULL,
    [LastStatusChg]                     DATETIME      NULL,
    [DateReceived]                      DATETIME      NULL,
    [EWFeeZoneID]                       INT           NULL,
    [ConfirmAttemptsExaminee]           INT           NULL,
    [ConfirmAttemptsAttorney]           INT           NULL,
    [DateClientNotified]                DATETIME      NULL,
    [ApptConfirmedByExaminee]           BIT           CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByExaminee] DEFAULT ((0)) NOT NULL,
    [DateConfirmedByExaminee]           DATETIME      NULL,
    [ApptConfirmedByAttorney]           BIT           CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByAttorney] DEFAULT ((0)) NOT NULL,
    [DateConfirmedByAttorney]           DATETIME      NULL,
    [ApptAttendance]                    VARCHAR (300) NULL,
    [CancelReasonDetailID]              INT           NULL,
    [AwaitingScheduling]                DATETIME      NULL,
    [DoctorScheduledRank]               INT           NULL,
    [ScheduleMethod]                    INT           NULL,
    [Duration]                          INT           NULL,
    [DoctorBlockTimeSlotID]             INT           NULL,
    [DateApptLetterSent]                DATETIME      NULL,
    [NoShowNotificationDate]            DATETIME      NULL,
    [DoctorReason]                      VARCHAR (25)  NULL,
    [DateShowNoShowLetterSent]          DATETIME      NULL,
    [TATNoShowToScheduled]              INT           NULL,
    [SLAExScheduledToExam]              VARCHAR(275)  NULL, 
    [SLAExExamToClientNotified]         VARCHAR(275)  NULL, 
    [SLAExAwaitingScheduling]           VARCHAR(275)  NULL,
    [SLAExAwaitingSchedulingToExam]     VARCHAR(275)  NULL,
    [SALExEnteredToExam]                VARCHAR(275)  NULL,
    [SLAExDateLossToApptDate]           VARCHAR(275)  NULL, 
    [SLAExExamSchedToQuoteSent]         VARCHAR(275)  NULL,
    [SLAExExamSchedToApprovalSent]      VARCHAR(275)  NULL,
    [SLAExExamDateToNotifyShowNoShow]   VARCHAR(275)  NULL, 
    CONSTRAINT [PK_tblCaseAppt] PRIMARY KEY CLUSTERED ([CaseApptID] ASC)
);



GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_CaseNbr]
    ON [dbo].[tblCaseAppt]([CaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_ApptTimeApptStatusID]
    ON [dbo].[tblCaseAppt]([ApptTime] ASC, [ApptStatusID] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_ApptStatusID]
    ON [dbo].[tblCaseAppt]([ApptStatusID] ASC)
    INCLUDE([CaseNbr], [ApptTime], [DoctorCode], [LocationCode], [DoctorBlockTimeSlotID]);

