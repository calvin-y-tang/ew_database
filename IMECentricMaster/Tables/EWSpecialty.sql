CREATE TABLE [dbo].[EWSpecialty] (
    [EWSpecialtyID]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SpecialtyCode]      VARCHAR (50) NULL,
    [Description]        VARCHAR (50) NULL,
    [PublishOnWeb]       BIT          NULL,
    [BoardCertAvailable] BIT          NULL,
    [PrimarySpecialty]   VARCHAR (50) NULL,
    [SubSpecialty]       VARCHAR (50) NULL,
    [Expertise]          VARCHAR (50) NULL,
    [Status]             VARCHAR (10) NULL,
    [NUCCTaxonomyCode]   VARCHAR (16) NULL,
    CONSTRAINT [PK_EWSpecialty] PRIMARY KEY CLUSTERED ([EWSpecialtyID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWSpecialty_SpecialtyCode]
    ON [dbo].[EWSpecialty]([SpecialtyCode] ASC);

