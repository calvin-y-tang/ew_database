CREATE TABLE [dbo].[tblLock] (
    [LockID]     INT          IDENTITY (1, 1) NOT NULL,
    [TableType]  VARCHAR (50) NULL,
    [TableKey]   INT          NULL,
    [DateLocked] DATETIME     NULL,
    [DateAdded]  DATETIME     NULL,
    [UserID]     VARCHAR (50) NULL,
    [SessionID]  VARCHAR (50) NOT NULL,
    [ModuleName] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblLock] PRIMARY KEY CLUSTERED ([LockID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblLock_TableTypeTableKey]
    ON [dbo].[tblLock]([TableType] ASC, [TableKey] ASC)
    INCLUDE([SessionID], [UserID]);

