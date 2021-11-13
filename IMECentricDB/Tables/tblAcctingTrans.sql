CREATE TABLE [dbo].[tblAcctingTrans] (
    [CaseNbr]        INT           NOT NULL,
    [Type]           VARCHAR (2)   NOT NULL,
    [StatusCode]     INT           NOT NULL,
    [otherinfo]      VARCHAR (256) NULL,
    [DateAdded]      DATETIME      NOT NULL,
    [DateEdited]     DATETIME      NULL,
    [UserIDAdded]    VARCHAR (20)  NULL,
    [UserIDEdited]   VARCHAR (20)  NULL,
    [DrOpCode]       INT           NULL,
    [DrOpType]       VARCHAR (5)   NULL,
    [SeqNO]          INT           IDENTITY (1, 1) NOT NULL,
    [ApptDate]       DATETIME      NULL,
    [DoctorLocation] INT           NULL,
    [ApptTime]       DATETIME      NULL,
    [LastStatusChg]  DATETIME      NULL,
    [Result]         VARCHAR (10)  NULL,
    [blnSelect]      BIT           CONSTRAINT [DF_tblAcctingTrans_blnSelect] DEFAULT (0) NULL,
    [CaseApptID]     INT           NULL,
    [ApptStatusID]   INT           NULL,
    CONSTRAINT [PK_tblAcctingTrans] PRIMARY KEY CLUSTERED ([SeqNO] ASC)
);






GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_tblAcctingTrans_StatusCode]
    ON [dbo].[tblAcctingTrans]([StatusCode] ASC)
    INCLUDE([CaseNbr]);




GO
CREATE NONCLUSTERED INDEX [IX_tblAcctingTrans_CaseNbrTypeStatusCodeDrOpCode]
    ON [dbo].[tblAcctingTrans]([CaseNbr] ASC, [Type] ASC, [StatusCode] ASC, [DrOpCode] ASC);

