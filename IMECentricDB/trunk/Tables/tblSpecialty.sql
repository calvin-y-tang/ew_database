CREATE TABLE [dbo].[tblSpecialty] (
    [SpecialtyCode]      VARCHAR (50) NOT NULL,
    [Description]        VARCHAR (50) NULL,
    [DateAdded]          DATETIME     NULL,
    [UserIDAdded]        VARCHAR (50) NULL,
    [DateEdited]         DATETIME     NULL,
    [UserIDEdited]       VARCHAR (50) NULL,
    [PublishOnWeb]       BIT          NULL,
    [WebSynchDate]       DATETIME     NULL,
    [OCF21Type]          VARCHAR (5)  NULL,
    [WebID]              INT          NULL,
    [DisplayOrder]       INT          NULL,
    [BoardCertAvailable] BIT          NULL,
    [EWSpecialtyID]      INT          IDENTITY (1, 1) NOT NULL,
    [Status]             VARCHAR (10) NULL,
    [NUCCTaxonomyCode]   VARCHAR (16) NULL,
    [PrimarySpecialty]   VARCHAR (50) NULL,
    [SubSpecialty]       VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSpecialty] PRIMARY KEY CLUSTERED ([EWSpecialtyID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSpecialty_SpecialtyCode]
    ON [dbo].[tblSpecialty]([SpecialtyCode] ASC);

