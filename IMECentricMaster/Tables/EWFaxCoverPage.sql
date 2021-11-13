CREATE TABLE [dbo].[EWFaxCoverPage] (
    [FaxCoverPageID] INT          NOT NULL,
    [FaxType]        INT          NULL,
    [DeviceName]     VARCHAR (50) NULL,
    [DisplayName]    VARCHAR (50) NULL,
    CONSTRAINT [PK_EWFaxCoverPage] PRIMARY KEY CLUSTERED ([FaxCoverPageID] ASC)
);

