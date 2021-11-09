CREATE TABLE [dbo].[EWCoverLetterClientSpecData] (
    [EWCoverLetterClientSpecDataID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWCoverLetterID]               INT           NOT NULL,
    [SpecifiedData]                 VARCHAR (500) NULL,
    [Required]                      BIT           NOT NULL,
    [UserIDAdded]                   VARCHAR (30)  NULL,
    [DateAdded]                     DATETIME      NULL,
    [UserIDEdited]                  VARCHAR (30)  NULL,
    [DateEdited]                    DATETIME      NULL,
    CONSTRAINT [PK_EWCoverLetterClientSpecData] PRIMARY KEY CLUSTERED ([EWCoverLetterClientSpecDataID] ASC) WITH (FILLFACTOR = 90)
);

