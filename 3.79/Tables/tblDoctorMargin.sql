CREATE TABLE [dbo].[tblDoctorMargin]
(
	[PrimaryKey] INT NOT NULL IDENTITY, 
    [DoctorCode] INT NOT NULL, 
    [ParentCompanyID] INT NOT NULL, 
    [EWBusLineID] INT NOT NULL, 
    [EWServiceTypeID] INT NOT NULL, 
    [SpecialtyCode] VARCHAR(50) NULL, 
    [CaseCount] INT NOT NULL, 
    [TotalInvoiceAmt] MONEY NOT NULL, 
    [TotalVoucherAmt] MONEY NOT NULL, 
    [Margin] NUMERIC(8, 2) NULL, 
    [DateLastEdited] DATETIME NOT NULL,
	CONSTRAINT [PK_tblDoctorMargin] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
)

GO

CREATE INDEX [IX_tblDoctorMargin_DoctorCode] ON [dbo].[tblDoctorMargin] ([DoctorCode])
