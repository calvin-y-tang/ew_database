CREATE TABLE [dbo].[tblEWFaxCoverPage] (
    [FaxCoverPageID] INT          NOT NULL,
    [FaxType]        INT          NULL,
    [DeviceName]     VARCHAR (50) NULL,
    [DisplayName]    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblEWFaxCoverPage] PRIMARY KEY CLUSTERED ([FaxCoverPageID] ASC)
);

