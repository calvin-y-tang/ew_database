CREATE TABLE [dbo].[tblCaseApptPanel] (
    [CaseApptID]            INT           NOT NULL,
    [DoctorCode]            INT           NOT NULL,
    [SpecialtyCode]         VARCHAR (500) NULL,
	[DoctorBlockTimeSlotID] INT           NULL,
    CONSTRAINT [PK_tblCaseApptPanel] PRIMARY KEY CLUSTERED ([CaseApptID] ASC, [DoctorCode] ASC)
);

