CREATE TABLE [dbo].[tblCompanyCPTCode] (
    [CompanyCode]         INT          NOT NULL,
    [ProdCode]            INT          NOT NULL,
    [CPTCode]             VARCHAR (20) NULL,
    [CPTCodeNoShow]       VARCHAR (20) NULL,
    [CPTCodeCancel]       VARCHAR (20) NULL,
    CONSTRAINT [PK_tblCompanyCPTCode] PRIMARY KEY CLUSTERED ([CompanyCode] ASC, [ProdCode] ASC)
);
GO

