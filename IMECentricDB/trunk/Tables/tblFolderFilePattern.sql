CREATE TABLE [dbo].[tblFolderFilePattern]
(
    [FolderID]      INT          NOT NULL,
    [FilePatternID]	INT          NOT NULL,
    [DateAdded]     DATETIME     NULL,
    [UserIDAdded]   VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFolderFilePattern] PRIMARY KEY CLUSTERED ([FolderID] ASC, [FilePatternID] ASC)
)
