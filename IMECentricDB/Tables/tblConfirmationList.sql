CREATE TABLE [dbo].[tblConfirmationList]
(
    [ConfirmationListID]        INT           IDENTITY (1, 1) NOT NULL,
    [CaseApptID]                INT           NOT NULL,
    [ConfirmationRuleDetailID]  INT           NOT NULL,
    [ConfirmationStatusID]      INT           NOT NULL,
    [StartDate]                 DATETIME      NOT NULL,
    [Selected]                  BIT           CONSTRAINT [DF_tblConfirmationList_Selected] DEFAULT ((1)) NOT NULL,
    [ContactType]               VARCHAR (20)  NOT NULL,
    [Phone]                     VARCHAR (15)  NOT NULL,
    [ContactMethod]             INT           NOT NULL,
    [BatchNbr]                  INT           NOT NULL,
    [AttemptNbr]                INT           NOT NULL,
    [DateAdded]                 DATETIME      NULL,
    [UserIDAdded]               VARCHAR (15)  NULL,
    [DateEdited]                DATETIME      NULL,
    [UserIDEdited]              VARCHAR (15)  NULL,
    [ConfirmationMessageIDUsed] INT           NULL,
    [ConfirmationResultID]      INT           NULL,
    [ContactedDateTime]         DATETIME      NULL,
    [NbrOfCallAttempts]         INT           NULL,
    [SMSStatus]                 VARCHAR (50)  NULL,
    [Resolution]                INT           NULL,
    [AssignedTo]                VARCHAR (15)  NULL,
    [TargetCallTime]            DATETIME      NULL,
    [UITempData]                VARCHAR(10)   NULL, 
    [Replicated] BIT NULL, 
    CONSTRAINT [PK_tblConfirmationList] PRIMARY KEY CLUSTERED ([ConfirmationListID] ASC)

)

GO

CREATE INDEX [IX_tblConfirmationList_StartDateConfirmationStatusID] ON [dbo].[tblConfirmationList] ([StartDate], [ConfirmationStatusID])

GO

CREATE INDEX [IX_tblConfirmationList_BatchNbrConfirmationStatusID] ON [dbo].[tblConfirmationList] ([BatchNbr], [ConfirmationStatusID])
