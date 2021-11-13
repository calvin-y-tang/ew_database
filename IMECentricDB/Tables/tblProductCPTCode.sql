CREATE TABLE [dbo].[tblProductCPTCode] (
    [ProdCode]            INT          NOT NULL,
    [StateCode]           VARCHAR(5)   NOT NULL,
    [CPTCode]             VARCHAR (20) NULL,
    [CPTCodeNoShow]       VARCHAR (20) NULL,
    [CPTCodeCancel]       VARCHAR (20) NULL,
    CONSTRAINT [PK_tblProductCPTCode] PRIMARY KEY CLUSTERED ([ProdCode] ASC, [StateCode] ASC)
);
GO

