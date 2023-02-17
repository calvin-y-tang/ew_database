CREATE TABLE [dbo].[EWSpecialty] (
    [EWSpecialtyID]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SpecialtyCode]      VARCHAR (500) NULL,
    [Description]        VARCHAR (500) NULL,
    [PublishOnWeb]       BIT           NULL,
    [BoardCertAvailable] BIT           NULL,
    [PrimarySpecialty]   VARCHAR (500) NULL,
    [SubSpecialty]       VARCHAR (500) NULL,
    [Expertise]          VARCHAR (500) NULL,
    [Status]             VARCHAR (10)  NULL,
    [NUCCTaxonomyCode]   VARCHAR (16)  NULL,
    CONSTRAINT [PK_EWSpecialty] PRIMARY KEY CLUSTERED ([EWSpecialtyID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWSpecialty_SpecialtyCode]
    ON [dbo].[EWSpecialty]([SpecialtyCode] ASC);

