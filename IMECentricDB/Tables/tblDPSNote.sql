CREATE TABLE [dbo].[tblDPSNote]
(
	[DPSNoteID] INT NOT NULL IDENTITY, 
    [DateAdded] DATETIME NOT NULL, 
    [UserIDAdded] VARCHAR(15) NOT NULL, 
    [DateEdited] DATETIME NOT NULL, 
    [UserIDEdited] VARCHAR(15) NOT NULL,
	[Notes] VARCHAR(MAX) NOT NULL,
	[CaseNbr] INT NOT NULL, 
    [DateExported] DATETIME NULL, 
    [DateImported] DATETIME NULL, 
    CONSTRAINT [PK_tblDPSNote] PRIMARY KEY CLUSTERED ([DPSNoteID] ASC)
)

GO

CREATE INDEX [IX_tblDPSNote_CaseNbr] ON [dbo].[tblDPSNote] ([CaseNbr])
