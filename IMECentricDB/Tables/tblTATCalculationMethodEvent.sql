CREATE TABLE [dbo].[tblTATCalculationMethodEvent] (
    [TATCalculationMethodID] INT NOT NULL,
    [EventID]                INT NOT NULL,
    CONSTRAINT [PK_tblTATCalculationMethodEvent] PRIMARY KEY CLUSTERED ([TATCalculationMethodID] ASC, [EventID] ASC)
);

