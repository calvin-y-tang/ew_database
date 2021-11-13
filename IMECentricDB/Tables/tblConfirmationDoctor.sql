CREATE TABLE [dbo].[tblConfirmationDoctor]
(
	[DoctorCode]			INT				NOT NULL,
	[FirstName]				VARCHAR(50)		NULL,
	[LastName]				VARCHAR(50)		NULL,
	[DateExported]			DATETIME		NULL,
	CONSTRAINT [PK_tblConfirmationDoctor] PRIMARY KEY CLUSTERED ([DoctorCode])
)
