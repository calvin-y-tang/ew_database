CREATE TABLE [dbo].[tblDoctorOffice] (
    [DoctorCode]  INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (20) NOT NULL,
    [FeeCode]     INT          NULL,
    CONSTRAINT [PK_tblDoctorOffice] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [OfficeCode] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorOffice_OfficeCodeDoctorCode]
    ON [dbo].[tblDoctorOffice]([OfficeCode] ASC, [DoctorCode] ASC);

