CREATE TABLE [dbo].[tblCaseApptRequest] (
    [CaseApptRequestID]       INT           IDENTITY (1, 1) NOT NULL,
    [DoctorBlockTimeSlotID]   INT           NOT NULL,
    [CaseNbr]                 INT           NOT NULL,
    [CaseApptRequestStatusID] INT           NOT NULL,
    [DateAdded]               DATETIME      NULL,
    [UserIDAdded]             VARCHAR (15)  NULL,
    [DateEdited]              DATETIME      NULL,
    [UserIDEdited]            VARCHAR (15)  NULL,
    [RejectionReason]         VARCHAR (100) NULL,
    [ReservationSource] VARCHAR(200) NULL, 
    CONSTRAINT [PK_tblCaseApptRequest] PRIMARY KEY CLUSTERED ([CaseApptRequestID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseApptRequest_CaseNbr]
    ON [dbo].[tblCaseApptRequest]([CaseNbr] ASC);


