CREATE TABLE [dbo].[tblSpecialty] (
    [SpecialtyCode]      VARCHAR (500) NOT NULL,
    [Description]        VARCHAR (500) NULL,
    [DateAdded]          DATETIME      NULL,
    [UserIDAdded]        VARCHAR (50)  NULL,
    [DateEdited]         DATETIME      NULL,
    [UserIDEdited]       VARCHAR (50)  NULL,
    [PublishOnWeb]       BIT           NULL,
    [WebSynchDate]       DATETIME      NULL,
    [OCF21Type]          VARCHAR (5)   NULL,
    [WebID]              INT           NULL,
    [DisplayOrder]       INT           NULL,
    [BoardCertAvailable] BIT           NULL,
    [EWSpecialtyID]      INT           IDENTITY (1, 1) NOT NULL,
    [Status]             VARCHAR (10)  NULL,
    [NUCCTaxonomyCode]   VARCHAR (16)  NULL,
    [PrimarySpecialty]   VARCHAR (500) NULL,
    [SubSpecialty]       VARCHAR (500) NULL,
    [ControlledByIMEC]   BIT           CONSTRAINT [DF_tblSpecialty_ControlledByIMEC] DEFAULT (0) NULL, 
    CONSTRAINT [PK_tblSpecialty] PRIMARY KEY CLUSTERED ([EWSpecialtyID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSpecialty_SpecialtyCode]
    ON [dbo].[tblSpecialty]([SpecialtyCode] ASC);

