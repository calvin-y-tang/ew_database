CREATE TABLE [dbo].[EWDrDocType] (
    [EWDrDocTypeID]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]               VARCHAR (30) NULL,
    [FolderID]           INT          NULL,
    [Confidential]       BIT          NULL,
    [AddTokenName]       VARCHAR (40) NULL,
    [AllowEdit]          BIT          NULL,
    [SeqNo]              INT          NULL,
    [AllowState]         INT          NULL,
    [AllowExpireDate]    INT          NULL,
    [AllowSpecialty]     INT          NULL,
    [AllowLicenseNbr]    INT          NULL,
    [AllowAccreditation] INT          NULL,
    [AllowPublishOnWeb]  BIT          NULL,
    [AddSecurityTokenID] INT          NULL,
    CONSTRAINT [PK_EWDrDocType] PRIMARY KEY CLUSTERED ([EWDrDocTypeID] ASC)
);

