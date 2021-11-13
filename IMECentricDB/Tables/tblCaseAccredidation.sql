CREATE TABLE [dbo].[tblCaseAccredidation] (
    [CaseAccreditationID] INT          IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT          NOT NULL,
    [EWAccreditationID]   INT          NOT NULL,
    [Description]         VARCHAR (50) NOT NULL,
    [DateAdded]           DATETIME     CONSTRAINT [DF_tblCaseAccredidation_DateAdded] DEFAULT (getdate()) NOT NULL,
    [UserIDAdded]         VARCHAR (30) NULL,
    CONSTRAINT [PK_tblCaseAccredidation] PRIMARY KEY CLUSTERED ([CaseAccreditationID] ASC)
);

