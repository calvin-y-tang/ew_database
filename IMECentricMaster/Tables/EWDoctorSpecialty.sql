CREATE TABLE [dbo].[EWDoctorSpecialty] (
    [EWDoctorID]                INT          NOT NULL,
    [EWSpecialtyID]             INT          NOT NULL,
    [UserIDAdded]               VARCHAR (15) NULL,
    [DateAdded]                 DATETIME     NULL,
    [MasterReviewerSpecialtyID] INT          NULL, 
    CONSTRAINT [PK_EWDoctorSpecialty] PRIMARY KEY CLUSTERED ([EWDoctorID] ASC, [EWSpecialtyID] ASC)
);

