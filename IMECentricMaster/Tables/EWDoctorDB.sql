CREATE TABLE [dbo].[EWDoctorDB] (
    [EWDoctorID]   INT          NOT NULL,
    [DBID]         INT          NOT NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateAdded]    DATETIME     NULL,
    [Status]       VARCHAR (10) NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    CONSTRAINT [PK_EWDoctorDB] PRIMARY KEY CLUSTERED ([EWDoctorID] ASC, [DBID] ASC)
);

