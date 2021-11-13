CREATE TABLE [dbo].[tblPOPBVoucher] (
    [DoctorCode]           INT             NULL,
    [Percentage]           DECIMAL (10, 2) NULL,
    [CaseDoctorPercentage] DECIMAL (10, 2) NULL,
    [CaseDoctorCode]       INT             NOT NULL,
    [DoctorCode2]          INT             NULL,
    [Percentage2]          DECIMAL (10, 2) NULL,
    CONSTRAINT [PK_tblPOPBVoucher] PRIMARY KEY CLUSTERED ([CaseDoctorCode] ASC)
);



