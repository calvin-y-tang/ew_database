CREATE TABLE [dbo].[tblStorage] (
    [StorageID]       INT           IDENTITY (1, 1) NOT NULL,
    [StorageTypeID]   INT           NOT NULL,
    [ExtStorageKey]   VARCHAR (30)  NULL,
    [DateAdded]       DATETIME      NOT NULL,
    [UserIDAdded]     VARCHAR (15)  NULL,
    [IsDeleted]       BIT           CONSTRAINT [DF_tblStorage_IsDeleted] DEFAULT ((0)) NOT NULL,
    [Param]           VARCHAR (100) NULL,
	[DateReadyDelete] DATETIME      NULL,
	[DateDeleted]     DATETIME      NULL,
    CONSTRAINT [PK_tblStorage] PRIMARY KEY CLUSTERED ([StorageID] ASC)
);

