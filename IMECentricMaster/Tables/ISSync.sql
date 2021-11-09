CREATE TABLE [dbo].[ISSync] (
    [SyncID]  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]    VARCHAR (20) NULL,
    [Descrip] VARCHAR (50) NULL,
    [Active]  BIT          CONSTRAINT [DF_ISSync_Active] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ISSync] PRIMARY KEY CLUSTERED ([SyncID] ASC)
);

