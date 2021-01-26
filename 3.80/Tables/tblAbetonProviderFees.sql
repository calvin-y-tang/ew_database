CREATE TABLE [dbo].[tblAbetonProviderFees] (
    [DrOpCode]             INT          NOT NULL,
    [FeeCode]              INT          NOT NULL,
    [ProdCode]             INT          NOT NULL,
    [OfficeCode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [ProviderFee]          MONEY        NULL,
    [InvoiceAmount]        MONEY        NULL,
    [InvoiceNoShowFee]     MONEY        NULL,
    [VoucherNoShowFee]     MONEY        NULL,
    [InvoiceLateCancelFee] MONEY        NULL,
    [VoucherLateCancelFee] MONEY        NULL,
    [LateCancelDays]       INT          NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDAdded]          VARCHAR (20) NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (20) NULL,
    [DontUpdate]           BIT          NULL,
    CONSTRAINT [PK_tblAbetonProviderFees] PRIMARY KEY CLUSTERED ([DrOpCode] ASC, [FeeCode] ASC, [ProdCode] ASC, [OfficeCode] ASC, [CaseType] ASC)
);

