CREATE TABLE [dbo].[tblStandardCaseHistoryNotes] (
    [NoteID]          INT          IDENTITY (1, 1) NOT NULL,
    [NoteDescription] VARCHAR (50) NULL,
    [NoteText]        TEXT         NULL,
    [PublishOnWeb]    BIT          CONSTRAINT [DF_tblStandardCaseHistoryNotes_PublishOnWeb] DEFAULT ((0)) NULL,
    [Status]          VARCHAR (10) CONSTRAINT [DF_tblStandardCaseHistoryNotes_Status] DEFAULT ('Active') NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (50) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblStandardCaseHistoryNotes] PRIMARY KEY CLUSTERED ([NoteID] ASC)
);

