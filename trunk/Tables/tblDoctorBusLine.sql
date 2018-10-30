CREATE TABLE [dbo].[tblDoctorBusLine] (
    [DoctorCode]  INT          NOT NULL,
    [EWBusLineID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorBusLine] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [EWBusLineID] ASC)
);

