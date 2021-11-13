CREATE TABLE [dbo].[CRNMasterID] (
    [PrimaryKey]      INT          IDENTITY (1, 1) NOT NULL,
    [LocalSystemName] VARCHAR (50) NULL,
    [LocalSystemID]   INT          NULL,
    [MasterID]        INT          NULL,
    [DBID]            INT          NULL,
    [IsLinked]        BIT          NULL,
    CONSTRAINT [PK_CRNMasterID] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_CRNMasterID_DBIDLocalSystemID]
    ON [dbo].[CRNMasterID]([DBID] ASC, [LocalSystemID] ASC);

