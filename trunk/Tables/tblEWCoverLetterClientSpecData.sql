CREATE TABLE [dbo].[tblEWCoverLetterClientSpecData] (
    [EWCoverLetterClientSpecDataID] INT           NOT NULL,
    [EWCoverLetterID]               INT           NOT NULL,
    [SpecifiedData]                 VARCHAR (500) NULL,
    [Required]                      BIT           NOT NULL,
    [UserIDAdded]                   VARCHAR (30)  NULL,
    [DateAdded]                     DATETIME      NULL,
    [UserIDEdited]                  VARCHAR (30)  NULL,
    [DateEdited]                    DATETIME      NULL,
    CONSTRAINT [PK_tblEWCoverLetterClientSpecData] PRIMARY KEY CLUSTERED ([EWCoverLetterClientSpecDataID] ASC)
);

