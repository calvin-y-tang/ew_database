CREATE TABLE [dbo].[tblFeeHeader] (
    [FeeCode]        INT          IDENTITY (1, 1) NOT NULL,
    [FeeType]        VARCHAR (10) NOT NULL,
    [Feedesc]        VARCHAR (70) NULL,
    [Begin_Date]     DATETIME     NULL,
    [End_Date]       DATETIME     NULL,
    [DateAdded]      DATETIME     NULL,
    [DateEdited]     DATETIME     NULL,
    [UserIDAdded]    VARCHAR (20) NULL,
    [UserIDEdited]   VARCHAR (20) NULL,
    [LastUsed]       DATETIME     NULL,
    [DoctorCode]     INT          NULL,
    [DoctorLocation] INT          NULL,
    [FeeCalcMethod]  INT          NULL,
    CONSTRAINT [PK_tblfeeheader] PRIMARY KEY CLUSTERED ([FeeCode] ASC) WITH (FILLFACTOR = 90)
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_tblFeeHeader_Feedesc]
    ON [dbo].[tblFeeHeader]([Feedesc] ASC);

