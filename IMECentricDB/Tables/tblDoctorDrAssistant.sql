CREATE TABLE dbo.tblDoctorDrAssistant(
	[DrAssistantID] INT			NOT NULL,
	[DoctorCode]	INT			NOT NULL,
	[UserIDAdded]	VARCHAR(15) NOT NULL,
	[DateAdded]		DATETIME	NOT NULL
    CONSTRAINT [PK_tblDoctorDrAssistant] PRIMARY KEY CLUSTERED ([DrAssistantID] ASC, [DoctorCode] ASC)
);
