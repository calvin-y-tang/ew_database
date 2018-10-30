CREATE TABLE [dbo].[tblDoctorAccreditation] (
    [DoctorCode]        INT          NOT NULL,
    [EWAccreditationID] INT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (15) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorAccreditation] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [EWAccreditationID] ASC)
);

