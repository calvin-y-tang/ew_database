CREATE TABLE [dbo].[tblCaseSpecialty] (
    [CaseSpecialtyID] INT          IDENTITY (1, 1) NOT NULL,
    [SpecialtyCode]   VARCHAR (50) NOT NULL,
    [CaseNbr]         INT          NOT NULL,
    [DateAdded]       DATETIME     CONSTRAINT [DF_tblCaseSpecialty_DateAdded] DEFAULT (getdate()) NOT NULL,
    [UserIDAdded]     VARCHAR (30) NULL,
    CONSTRAINT [PK_tblCaseSpecialty] PRIMARY KEY CLUSTERED ([CaseSpecialtyID] ASC)
);

