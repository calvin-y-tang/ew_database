CREATE TABLE [dbo].[EWAccreditation] (
    [EWAccreditationID] INT          NOT NULL,
    [Name]              VARCHAR (10) NULL,
    [Description]       VARCHAR (50) NULL,
    [PublishOnWeb]      BIT          NULL,
    [SeqNo]             INT          NULL,
    [CountryID]         INT          NULL,
    CONSTRAINT [PK_EWAccreditation] PRIMARY KEY CLUSTERED ([EWAccreditationID] ASC)
);

