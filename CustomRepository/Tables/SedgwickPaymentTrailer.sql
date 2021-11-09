CREATE TABLE [dbo].[SedgwickPaymentTrailer] (
    [Id]                       INT             IDENTITY (1, 1) NOT NULL,
    [ProviderPaymentCount]     INT             NULL,
    [ReviewFeePaymentCount]    INT             NULL,
    [PPOFeePaymentCount]       INT             NULL,
    [IntermediaryPaymentCount] INT             NULL,
    [StateTaxFeePaymentCount]  INT             NULL,
    [NoPaymentInfoCount]       INT             NULL,
    [TotalPaymentInfoRecCount] INT             NULL,
    [TotalPaymentAmount]       NUMERIC (18, 2) NULL,
    [TotalAllocationAmount]    NUMERIC (18, 2) NULL,
    [EInvoicePaymentCount]     INT             NULL,
    [PaymentHeaderId]          INT             NULL,
    CONSTRAINT [PK_SedgwickPaymentTrailer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

