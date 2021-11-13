CREATE TABLE [dbo].[tblDoctorNetwork] (
    [DoctorCode]  INT          NOT NULL,
    [EWNetworkID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorNetwork] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [EWNetworkID] ASC)
);

