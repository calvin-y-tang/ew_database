CREATE TABLE [dbo].[tblCaseOtherTreatingDoctor] (
    [CaseNbr]          INT          NOT NULL,
    [TreatingDoctorID] INT          NOT NULL,
    [DateAdded]        DATETIME     NULL,
    [UserIDAdded]      VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCaseOtherTreatingDoctor] PRIMARY KEY CLUSTERED ([CaseNbr] ASC, [TreatingDoctorID] ASC)
);

