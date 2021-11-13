CREATE TABLE [dbo].[tblEWCoverLetterQuestion] (
    [EWCoverLetterQuestionID] INT            NOT NULL,
    [EWCoverLetterID]         INT            NOT NULL,
    [QuestionText]            VARCHAR (1500) NULL,
    [Required]                BIT            NOT NULL,
    [DefaultChecked]          BIT            NOT NULL,
    [UserIDAdded]             VARCHAR (30)   NULL,
    [DateAdded]               DATETIME       NULL,
    [UserIDEdited]            VARCHAR (30)   NULL,
    [DateEdited]              DATETIME       NULL,
    CONSTRAINT [PK_tblEWCoverLetterQuestion] PRIMARY KEY CLUSTERED ([EWCoverLetterQuestionID] ASC)
);

