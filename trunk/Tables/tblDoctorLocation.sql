CREATE TABLE [dbo].[tblDoctorLocation] (
    [LocationCode]   INT          NOT NULL,
    [ScheduleThru]   DATETIME     NULL,
    [Status]         VARCHAR (10) NULL,
    [DateAdded]      DATETIME     NULL,
    [UserIDAdded]    VARCHAR (15) NULL,
    [DateEdited]     DATETIME     NULL,
    [UserIDEdited]   VARCHAR (50) NULL,
    [DoctorCode]     INT          NOT NULL,
    [Correspondence] VARCHAR (1)  NULL,
    [PublishOnWeb]   BIT          CONSTRAINT [DF_tblDoctorLocation_PublishOnWeb] DEFAULT ((0)) NULL,
    [OldKey]         INT          NULL,
    CONSTRAINT [PK_tblDoctorLocation] PRIMARY KEY CLUSTERED ([LocationCode] ASC, [DoctorCode] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorLocation_DoctorCodeLocationCode]
    ON [dbo].[tblDoctorLocation]([DoctorCode] ASC, [LocationCode] ASC)
    INCLUDE([Status]);

