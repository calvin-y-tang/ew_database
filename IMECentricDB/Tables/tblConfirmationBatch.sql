CREATE TABLE [dbo].[tblConfirmationBatch]
(
	[BatchNbr]					INT			NOT NULL, 
    [ConfirmationSetupID] INT NULL, 
	[BatchStatus]				INT			NULL,
	[DateAdded] DATETIME NULL, 
    [UserIDAdded] VARCHAR(15) NULL, 
    [DateBatchPrepared] DATETIME NULL, 
    [UserIDBatchPrepared] VARCHAR(15) NULL, 
	[DateFileSent]		DATETIME	NULL,
    CONSTRAINT [PK_tblConfirmationBatch] PRIMARY KEY CLUSTERED ([BatchNbr] ASC)
)
