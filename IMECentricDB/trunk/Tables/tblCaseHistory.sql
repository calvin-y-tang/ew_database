CREATE TABLE [dbo].[tblCaseHistory] (
    [CaseNbr]         INT              NOT NULL,
    [EventDate]       DATETIME         NOT NULL,
    [Eventdesc]       VARCHAR (50)     NULL,
    [UserID]          VARCHAR (15)     NULL,
    [OtherInfo]       VARCHAR (3000)   NULL,
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [Duration]        INT              NULL,
    [Type]            VARCHAR (20)     NULL,
    [Status]          INT              NULL,
    [PublishOnWeb]    BIT              CONSTRAINT [DF_tblCaseHistory_PublishOnWeb] DEFAULT ((0)) NULL,
    [WebSynchDate]    DATETIME         NULL,
    [DateEdited]      DATETIME         NULL,
    [UserIDEdited]    VARCHAR (30)     NULL,
    [WebGUID]         UNIQUEIDENTIFIER NULL,
    [DateAdded]       DATETIME         NULL,
    [SubCaseID]       INT              NULL,
    [Highlight]       BIT              NULL,
    [PublishedTo]     VARCHAR (50)     NULL,
    [Viewed]          BIT              CONSTRAINT [DF_tblCaseHistory_Viewed] DEFAULT ((0)) NOT NULL,
    [Locked]          BIT              CONSTRAINT [DF_tblCaseHistory_Locked] DEFAULT ((0)) NOT NULL,
    [ConversationLog] BIT              CONSTRAINT [DF_tblCaseHistory_ConversationLog] DEFAULT ((0)) NOT NULL,
    [FollowUpDate]    DATETIME         NULL,
    [ExceptionAlert]  BIT              CONSTRAINT [DF_tblCaseHistory_ExceptionAlert] DEFAULT ((0)) NOT NULL, 
	[AlertType]       INT              CONSTRAINT [DF_tblCaseHistory_AlertType] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblCaseHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_Type]
    ON [dbo].[tblCaseHistory]([Type] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_FollowUpDate]
    ON [dbo].[tblCaseHistory]([FollowUpDate] ASC) INCLUDE ([CaseNbr]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrEventDate]
    ON [dbo].[tblCaseHistory]([CaseNbr] ASC, [EventDate] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_EventDate]
    ON [dbo].[tblCaseHistory]([EventDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrFollowUpDate]
    ON [dbo].[tblCaseHistory]([CaseNbr] ASC, [FollowUpDate] ASC)
    INCLUDE([EventDate], [Eventdesc], [UserID], [OtherInfo], [ID]);

