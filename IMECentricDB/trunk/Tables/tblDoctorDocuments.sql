CREATE TABLE [dbo].[tblDoctorDocuments] (
    [DoctorCode]         INT           NOT NULL,
    [RecID]              INT           IDENTITY (1, 1) NOT NULL,
    [Description]        VARCHAR (50)  NULL,
    [ExpireDate]         DATETIME      NULL,
    [PathFilename]       VARCHAR (120) NULL,
    [DateAdded]          DATETIME      NOT NULL,
    [UserIDAdded]        VARCHAR (20)  NULL,
    [PublishOnWeb]       BIT           NULL,
    [DateEdited]         DATETIME      NULL,
    [UserIDEdited]       VARCHAR (30)  NULL,
    [EWDoctorDocumentID] INT           NULL,
    [EWDoctorID]         INT           NULL,
    [EWDrDocTypeID]      INT           NULL,
    [SpecialtyCode]      VARCHAR (50)  NULL,
    [EWAccreditationID]  INT           NULL,
    [State]              VARCHAR (2)   NULL,
    [LicenseNbr]         VARCHAR (50)  NULL,
    [FileExists]         BIT           NULL,
    [Confidential]       BIT           NULL,
    [FolderID]           INT           NULL,
    [Notes]              TEXT          NULL,
    [AllowEdit]          BIT           NULL,
    [FileSize]           BIGINT        NULL,
    [OriginalFilePath]   VARCHAR (250) NULL,
    [ConvertStatus]      VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblDoctorDocuments] PRIMARY KEY CLUSTERED ([RecID])
);


GO

CREATE INDEX [IX_U_tblDoctorDocuments_DoctorCodeRecID] ON [dbo].[tblDoctorDocuments] ([DoctorCode], [RecID])

GO

CREATE INDEX [IX_tblDoctorDocuments_EWDoctorDocumentID] ON [dbo].[tblDoctorDocuments] ([EWDoctorDocumentID])
