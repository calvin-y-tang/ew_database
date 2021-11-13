CREATE TABLE [dbo].[tblDoctorKeyWord] (
    [DoctorCode]  INT          NOT NULL,
    [KeywordID]   INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblDoctorKeyWord] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [KeywordID] ASC)
);

