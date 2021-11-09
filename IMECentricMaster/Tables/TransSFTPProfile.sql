CREATE TABLE [dbo].[TransSFTPProfile] (
    [TransSFTPProfileID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]               VARCHAR (20)  NULL,
    [SourceID]           INT           NOT NULL,
    [DBID]               INT           NULL,
    [Active]             BIT           NOT NULL,
    [ExportFolderID]     INT           NOT NULL,
    [FTPFolder]          VARCHAR (50)  NULL,
    [NotifyEmail]        VARCHAR (140) NULL,
    CONSTRAINT [PK_TransSFTPProfile] PRIMARY KEY CLUSTERED ([TransSFTPProfileID] ASC)
);

