CREATE TABLE [dbo].[tblDoctorSearchWeightedCriteria] (
    [PrimaryKey]                   INT            IDENTITY (1, 1) NOT NULL,
    [BlockTime]                    DECIMAL (8, 2) NOT NULL,
    [AverageMargin]                DECIMAL (8, 2) NOT NULL,
    [CaseCount]                    DECIMAL (8, 2) NOT NULL,
    [SchedulePriority]             DECIMAL (8, 2) NOT NULL,
    [ReceiveMedRecsElectronically] DECIMAL (8, 2) NOT NULL,
    CONSTRAINT [PK_tblDoctorSearchWeightedCriteria] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

