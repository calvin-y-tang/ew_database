CREATE TABLE [dbo].[EWDoctorBusLine] (
    [EWDoctorID]  INT          NOT NULL,
    [EWBusLineID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_EWDoctorBusLine] PRIMARY KEY CLUSTERED ([EWDoctorID] ASC, [EWBusLineID] ASC)
);

