CREATE TABLE [dbo].[tblHCAIBatch] (
    [HCAIBatchNumber] INT          IDENTITY (100, 1) NOT NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (50) NULL,
    CONSTRAINT [PK_tblHCAIBatch] PRIMARY KEY CLUSTERED ([HCAIBatchNumber] ASC)
);

