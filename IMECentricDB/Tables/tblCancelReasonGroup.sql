CREATE TABLE [dbo].[tblCancelReasonGroup]
(
    [CancelReasonGroupID] INT         IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]        INT         NOT NULL,
	[ParentCompanyID]     INT         NULL, 
	[Active]              BIT         CONSTRAINT [DF_tblCancelReasonGroup_Active] DEFAULT ((1)) NOT NULL,
    [DateAdded]           DATETIME    NOT NULL, 
    [UserIDAdded]         VARCHAR(15) NOT NULL, 
    [DateEdited]          DATETIME    NULL, 
    [UserIDEdited]        VARCHAR(15) NULL, 
    CONSTRAINT [PK_tblCancelReasonGroup] PRIMARY KEY CLUSTERED ([CancelReasonGroupID] ASC)
)
