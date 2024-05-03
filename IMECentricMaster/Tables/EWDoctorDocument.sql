CREATE TABLE [dbo].[EWDoctorDocument] (
    [EWDoctorDocumentID]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWDoctorID]               INT            NOT NULL,
    [EWDrDocTypeID]            INT            NULL,
    [Description]              VARCHAR (50)   NULL,
    [ExpireDate]               DATETIME       NULL,
    [PathFilename]             VARCHAR (120)  NULL,
    [DateAdded]                DATETIME       NOT NULL,
    [UserIDAdded]              VARCHAR (20)   NULL,
    [PublishOnWeb]             BIT            NULL,
    [DateEdited]               DATETIME       NULL,
    [UserIDEdited]             VARCHAR (30)   NULL,
    [SpecialtyCode]            VARCHAR (500)  NULL,
    [EWAccreditationID]        INT            NULL,
    [State]                    VARCHAR (2)    NULL,
    [LicenseNbr]               VARCHAR (50)   NULL,
    [FileExists]               BIT            NULL,
    [FileSize]                 BIGINT         NULL,
    [Confidential]             BIT            NULL,
    [FolderID]                 INT            NULL,
    [Notes]                    TEXT           NULL,
    [AllowEdit]                BIT            NULL,
    [OriginalFilePath]         VARCHAR (256)  NULL,
    [ConvertStatus]            VARCHAR (25)   NULL,
    [ConvertFailed]            BIT            NULL,
    [EffectiveDate]            DATETIME       NULL,
    [MasterReviewerDocumentID] INT            NULL,
    CONSTRAINT [PK_EWDoctorDocument] PRIMARY KEY CLUSTERED ([EWDoctorDocumentID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EWDoctorDocument_EWDoctorID]
    ON [dbo].[EWDoctorDocument]([EWDoctorID] ASC) WITH (FILLFACTOR = 90);

