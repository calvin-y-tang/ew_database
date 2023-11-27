CREATE TABLE [dbo].[tblDPSBundle] (
    [DPSBundleID]         INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT           NOT NULL,
    [DPSStatusID]         INT           CONSTRAINT [DF_tblDPSBundle_DPSStatusID] DEFAULT ((0)) NOT NULL,
    [ExtWorkBundleID]     VARCHAR (30)  NULL,
    [ResultFileName]      VARCHAR (100) NULL,
    [FolderID]            INT           NULL,
    [SubFolder]           VARCHAR (32)  NULL,
    [CombinedDPSBundleID] INT           NULL,
    [UserIDAdded]         VARCHAR (15)  NULL,
    [LastWSCall]          VARCHAR (20)  NULL,
    [LastWSDate]          DATETIME      NULL,
    [LastWSResult]        VARCHAR (20)  NULL,
    [DateAdded]           DATETIME      NULL,
    [UserIDEdited]        VARCHAR (15)  NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDSubmitted]     VARCHAR (15)  NULL,
    [DateSubmitted]       DATETIME      NULL,
    [DateSentToDPS]       DATETIME      NULL,
    [DateCompleted]       DATETIME      NULL,
    [DateCanceled]        DATETIME      NULL,
    [SortModelID]         INT           NULL,
    [DueDate]             DATETIME      NULL,
    [SpecialInstructions] VARCHAR (500) NULL,
    [ContactName]         VARCHAR (100) NULL,
    [ContactPhone]        VARCHAR (15)  NULL,
    [ContactEmail]        VARCHAR (70)  NULL,
    [NotifyWhenComplete]  BIT           NULL,
    [DateAcknowledged]    DATETIME      NULL,
    [WorkBundleDesc]      VARCHAR (30)  NULL,
    [ExtDocumentID]       VARCHAR (100) NULL,
    [DPSPriorityID]       INT           NULL,
    [DPSSystemID]         INT           CONSTRAINT [DF_tblDPSBundle_DPSSystemID] DEFAULT ((0)) NOT NULL,
    [DPSBundleTypeID]     INT           NULL,
    [CaseData]            VARCHAR (MAX) NULL,
    [CancelReason]        VARCHAR (100) NULL,
    [UserIDAcknowledged]  VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblDPSBundle] PRIMARY KEY CLUSTERED ([DPSBundleID] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblDPSBundle_DPSStatusIDDateAcknowledged]
    ON [dbo].[tblDPSBundle]([DPSStatusID] ASC, [DateAcknowledged] ASC)
	INCLUDE([CaseNbr]);


GO
CREATE NONCLUSTERED INDEX [IX_tblDPSBundle_CombinedDPSBundleID]
    ON [dbo].[tblDPSBundle]([CombinedDPSBundleID] ASC) INCLUDE ([DPSBundleID], [DPSBundleTypeID]);


GO

