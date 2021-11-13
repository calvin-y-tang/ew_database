CREATE TABLE [dbo].[tblTATCalculationMethod] (
    [TATCalculationMethodID] INT         NOT NULL,
    [StartDateFieldID]       INT         NOT NULL,
    [EndDateFieldID]         INT         NOT NULL,
    [Unit]                   VARCHAR (5) NULL,
    [TATDataFieldID]         INT         NOT NULL,
    [UseTrend]               BIT         CONSTRAINT [DF_tblTATCalculationMethod_UseTrend] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblTATCalculationMethod] PRIMARY KEY CLUSTERED ([TATCalculationMethodID] ASC)
);





