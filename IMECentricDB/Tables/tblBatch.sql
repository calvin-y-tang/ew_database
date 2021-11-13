CREATE TABLE [dbo].[tblBatch] (
    [BatchNbr]    INT          NOT NULL,
    [Type]        VARCHAR (2)  NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (20) NULL,
    CONSTRAINT [PK_TblBatch] PRIMARY KEY CLUSTERED ([BatchNbr] ASC)
);

