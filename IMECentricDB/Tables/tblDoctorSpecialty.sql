CREATE TABLE [dbo].[tblDoctorSpecialty] (
    [SpecialtyCode]             VARCHAR (50) NOT NULL,
    [DateAdded]                 DATETIME     NULL,
    [UserIDAdded]               VARCHAR (50) NULL,
    [DateEdited]                DATETIME     NULL,
    [UserIDEdited]              VARCHAR (50) NULL,
    [DoctorCode]                INT          NOT NULL,
    [MasterReviewerSpecialtyID] INT          NULL,
    CONSTRAINT [PK_tblDoctorSpecialty] PRIMARY KEY CLUSTERED ([SpecialtyCode] ASC, [DoctorCode] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]
    ON [dbo].[tblDoctorSpecialty]([DoctorCode] ASC, [SpecialtyCode] ASC);

