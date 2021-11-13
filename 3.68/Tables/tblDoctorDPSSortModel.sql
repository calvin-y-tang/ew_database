CREATE TABLE [dbo].[tblDoctorDPSSortModel] (
    [DPSDoctorSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModelID]          INT          NOT NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorDPSSortModel] PRIMARY KEY CLUSTERED ([DPSDoctorSortModelID] ASC)
);

