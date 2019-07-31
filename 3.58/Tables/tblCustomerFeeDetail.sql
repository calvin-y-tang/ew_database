CREATE TABLE [dbo].[tblCustomerFeeDetail] (
    [CustomerFeeDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [CustomerFeeHeaderID] INT          NOT NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [ProdCode]            INT          NOT NULL,
    [EWBusLineID]         INT          NOT NULL,
    [EWFeeZoneID]         INT          NULL,
    [EWSpecialtyID]       INT          NULL,
    [FeeUnit]             VARCHAR (10) NULL,
    [FeeAmt]              MONEY        CONSTRAINT [DF_tblCustomerFeeDetail_FeeAmt] DEFAULT ((0)) NOT NULL,
    [LateCancelAmt]       MONEY        NULL,
    [CancelDays]          INT          NULL,
    [NoShowAmt]           MONEY        NULL,
    CONSTRAINT [PK_tblCustomerFeeDetail] PRIMARY KEY CLUSTERED ([CustomerFeeDetailID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCustomerFeeDetail_CustomerFeeHeaderIDProdCodeEWBusLineIDEWSpecialtyIDEWFeeZoneID]
    ON [dbo].[tblCustomerFeeDetail]([CustomerFeeHeaderID] ASC, [ProdCode] ASC, [EWBusLineID] ASC, [EWSpecialtyID] ASC, [EWFeeZoneID] ASC) WHERE ([EWFeeZoneID] IS NOT NULL);

