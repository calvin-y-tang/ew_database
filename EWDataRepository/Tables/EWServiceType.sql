CREATE TABLE [dbo].[EWServiceType] (
    [EWServiceTypeID] INT          NOT NULL,
    [SeqNo]           INT          NULL,
    [Name]            VARCHAR (25) NULL,
    [Mapping1]        VARCHAR (10) NULL,
    [Mapping2]        VARCHAR (10) NULL,
    [Mapping3]        VARCHAR (10) NULL,
    CONSTRAINT [PK_EWServiceType] PRIMARY KEY CLUSTERED ([EWServiceTypeID] ASC)
);

