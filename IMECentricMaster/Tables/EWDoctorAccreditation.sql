CREATE TABLE [dbo].[EWDoctorAccreditation] (
    [EWDoctorID]        INT          NOT NULL,
    [EWAccreditationID] INT          NOT NULL,
    [UserIDAdded]       VARCHAR (15) NULL,
    [DateAdded]         DATETIME     NULL,
    CONSTRAINT [PK_EWDoctorAccreditation] PRIMARY KEY CLUSTERED ([EWDoctorID] ASC, [EWAccreditationID] ASC)
);

