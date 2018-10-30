CREATE TABLE [dbo].[tblConfirmationResult] (
    [ConfirmationResultID] INT          IDENTITY (1, 1) NOT NULL,
    [ResultCode]        VARCHAR (20) NULL,
    [Description]          VARCHAR (70) NULL,
    [IsSuccessful]         BIT          CONSTRAINT [DF_tblConfirmationResult_IsSuccessful] DEFAULT ((0)) NOT NULL,
    [HandleMethod]         INT          CONSTRAINT [DF_tblConfirmationResult_HandleMethod] DEFAULT ((1)) NOT NULL,
    [ConfirmationSystemID] INT          CONSTRAINT [DF_tblConfirmationResult_ConfirmationSystemID] DEFAULT ((1)) NOT NULL,
    [MaxRetriesPerDay]     INT          NULL,
    [IncludeParams]        VARCHAR (50) NULL,
    CONSTRAINT [PK_tblConfirmationResult] PRIMARY KEY CLUSTERED ([ConfirmationResultID] ASC)
);
GO

CREATE NONCLUSTERED INDEX [IX_tblConfirmationResult_ConfirmationSystemIDExtResultCode]
    ON [dbo].[tblConfirmationResult]([ConfirmationSystemID] ASC, [ResultCode] ASC);
GO
