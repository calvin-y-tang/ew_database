CREATE TABLE [dbo].[tblCancelReasonDetail]
(
	[CancelReasonDetailID] INT         IDENTITY (1, 1) NOT NULL,
    [CancelReasonGroupID]  INT         NOT NULL, 
    [ExtName]              VARCHAR(50) NULL, 
    [Descrip]              VARCHAR(50) NULL, 
	[ReasonType]           VARCHAR(50) NULL, 
	[RequireAddtlInfo]     BIT         CONSTRAINT [DF_tblCancelReasonDetail_RequireAddtlInfo] DEFAULT ((0)) NOT NULL,
    [DateAdded]            DATETIME    NOT NULL, 
    [UserIDAdded]          VARCHAR(15) NOT NULL, 
    [DateEdited]           DATETIME    NULL, 
    [UserIDEdited]         VARCHAR(15) NULL, 
    CONSTRAINT [PK_tblCancelReasonDetail] PRIMARY KEY CLUSTERED ([CancelReasonDetailID] ASC)
)
