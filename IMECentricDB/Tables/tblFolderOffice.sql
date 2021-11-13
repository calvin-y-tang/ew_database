CREATE TABLE [dbo].[tblFolderOffice] (
    [FolderID]	INT          NOT NULL,
    [OfficeCode]	INT          NOT NULL,
    [DateAdded]		DATETIME     NULL,
    [UserIDAdded]	 VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFolderOffice] PRIMARY KEY CLUSTERED ([FolderID] ASC, [OfficeCode] ASC)
);
GO

