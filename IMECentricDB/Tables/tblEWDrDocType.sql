CREATE TABLE [dbo].[tblEWDrDocType] (
    [EWDrDocTypeID]      INT          NOT NULL,
    [Name]               VARCHAR (30) NULL,
    [FolderID]           INT          NULL,
    [Confidential]       BIT          NULL,
    [SeqNo]              INT          NULL,
    [AllowState]         INT          NULL,
    [AllowExpireDate]    INT          NULL,
    [AllowSpecialty]     INT          NULL,
    [AllowLicenseNbr]    INT          NULL,
    [AllowAccreditation] INT          NULL,
    [AllowPublishOnWeb]  BIT          NULL,
    [ControlledByIMEC]   BIT          CONSTRAINT [DF_tblEWDrDocType_ControlledByIMEC] DEFAULT (0) NULL, 
    CONSTRAINT [PK_tblEWDrDocType] PRIMARY KEY CLUSTERED ([EWDrDocTypeID] ASC)
);

