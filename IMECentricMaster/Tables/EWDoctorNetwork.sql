CREATE TABLE [dbo].[EWDoctorNetwork] (
    [EWDoctorID]  INT          NOT NULL,
    [EWNetworkID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_EWDoctorNetwork] PRIMARY KEY CLUSTERED ([EWDoctorID] ASC, [EWNetworkID] ASC)
);

