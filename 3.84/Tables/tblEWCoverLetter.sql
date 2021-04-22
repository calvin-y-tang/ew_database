CREATE TABLE [dbo].[tblEWCoverLetter] (
    [EWCoverLetterID]               INT           NOT NULL,
    [Description]                   VARCHAR (140) NULL,
    [ExternalName]                  VARCHAR (140) NULL,
    [Active]                        BIT           NOT NULL,
    [TemplateFilename]              VARCHAR (255) NULL,
    [EnableAdditionalQuestionsSect] BIT           NOT NULL,
    [IncludeClaimsHistorySect]      BIT           NOT NULL,
    [IncludeMedicalRecordsSect]     BIT           NOT NULL,
    [AllowSelReqCompanyName]        BIT           NOT NULL,
    [UserIDAdded]                   VARCHAR (30)  NULL,
    [DateAdded]                     DATETIME      NULL,
    [UserIDEdited]                  VARCHAR (30)  NULL,
    [DateEdited]                    DATETIME      NULL,
    CONSTRAINT [PK_tblEWCoverLetter] PRIMARY KEY CLUSTERED ([EWCoverLetterID] ASC)
);

