CREATE TABLE [dbo].[tblDoctorReason] (
    [DoctorReasonID] INT          IDENTITY (1, 1) NOT NULL,
    [Reason]         VARCHAR (25) NULL,
    [SeqNo]          INT          NULL,
    CONSTRAINT [PK_tblDoctorReason] PRIMARY KEY CLUSTERED ([DoctorReasonID] ASC)
);

