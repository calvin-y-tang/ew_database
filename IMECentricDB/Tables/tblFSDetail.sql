CREATE TABLE [dbo].[tblFSDetail]
(
	[FSDetailID]    INT IDENTITY (1, 1) NOT NULL,
	[FSHeaderID]    INT         NOT NULL,
	[ProcessOrder]  INT         NOT NULL, 
	[FeeUnit]       INT         NOT NULL,
	[FeeAmt]        MONEY       NOT NULL,
	[NSFeeAmt1]     MONEY       NULL,
	[NSFeeAmt2]     MONEY       NULL,
	[NSFeeAmt3]     MONEY       NULL,
	[LateCancelAmt] MONEY       NULL,
	[CancelDays]    INT         NULL,
    [DateAdded]     DATETIME    NOT NULL,
    [UserIDAdded]   VARCHAR(30) NOT NULL,
    [DateEdited]    DATETIME    NULL,
    [UserIDEdited]  VARCHAR(30) NULL,
	[InchesIncluded]  DECIMAL (18, 2) CONSTRAINT [DF_tblFSDetail_InchesIncluded] DEFAULT ((0)) NULL,
	CONSTRAINT [PK_tblFSDetail] PRIMARY KEY CLUSTERED ([FSDetailID] ASC)
)
