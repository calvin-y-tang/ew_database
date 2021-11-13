CREATE TABLE [dbo].[tblEWServiceType] (
    [EWServiceTypeID] INT          NOT NULL,
    [SeqNo]           INT          NULL,
    [Name]            VARCHAR (25) NULL,
    [Mapping1]        VARCHAR (10) NULL,
    [Mapping2]        VARCHAR (10) NULL,
    [Mapping3]        VARCHAR (10) NULL,
    CONSTRAINT [PK_tblEWServiceType] PRIMARY KEY CLUSTERED ([EWServiceTypeID] ASC)
);

