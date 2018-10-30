CREATE TABLE [dbo].[tblCompanyOffice] (
    [CompanyCode]     INT          NOT NULL,
    [OfficeCode]      INT          NOT NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (15) NULL,
    [FeeCode]         INT          NULL,
    [InvoiceDocument] VARCHAR (15) NULL,
    [EWFacilityID]    INT          NULL,
    [SuppressWeb]     BIT          CONSTRAINT [DF_tblCompanyOffice_SuppressWEb] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblCompanyOffice] PRIMARY KEY CLUSTERED ([CompanyCode] ASC, [OfficeCode] ASC)
);



