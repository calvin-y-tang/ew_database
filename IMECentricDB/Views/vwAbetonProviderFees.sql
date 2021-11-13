
CREATE VIEW vwAbetonProviderFees
AS
    SELECT  tblFeeHeader.FeeCode ,
            tblFeeHeader.Feedesc ,
            tblFeeHeader.Begin_Date ,
            tblFeeHeader.End_Date ,
            tblAbetonProviderFees.ProdCode ,
            tblAbetonProviderFees.ProviderFee AS DrFee ,
            tblAbetonProviderFees.InvoiceAmount AS Fee ,
            tblAbetonProviderFees.InvoiceNoShowFee AS NoShowFee ,
            tblAbetonProviderFees.VoucherNoShowFee AS DrNoShowFee ,
            tblAbetonProviderFees.InvoiceLateCancelFee AS LateCancelFee ,
            tblAbetonProviderFees.VoucherLateCancelFee AS DrLateCancelFee ,
            tblAbetonProviderFees.LateCancelDays AS CancelDays ,
            tblProduct.Description AS ProductDesc ,
            tblAbetonProviderFees.DrOpCode ,
            tblAbetonProviderFees.OfficeCode ,
            tblAbetonProviderFees.CaseType ,
            tblFeeDetailAbeton.latecancelfee AS FSLateCancel ,
            tblFeeDetailAbeton.noshowfee AS FSNoShow ,
            tblFeeDetailAbeton.canceldays AS FSCancelDays ,
            tblFeeDetailAbeton.flatfee ,
            tblFeeDetailAbeton.feeplus ,
            tblFeeDetailAbeton.MinFee ,
            tblFeeDetailAbeton.Rounding ,
            tblFeeDetailAbeton.RoundOn ,
            tblFeeDetailAbeton.Divisor ,
            tblFeeDetailAbeton.RevenueAcct ,
            tblFeeDetailAbeton.ExpenseAcct ,
            tblFeeDetailAbeton.Dept
    FROM    tblFeeHeader
            INNER JOIN tblFeeDetailAbeton ON tblFeeDetailAbeton.FeeCode = tblFeeHeader.FeeCode
            INNER JOIN tblAbetonProviderFees ON tblFeeDetailAbeton.FeeCode = tblAbetonProviderFees.FeeCode
                                                AND tblFeeDetailAbeton.OfficeCode = tblAbetonProviderFees.OfficeCode
                                                AND tblFeeDetailAbeton.CaseType = tblAbetonProviderFees.CaseType
                                                AND tblFeeDetailAbeton.ProdCode = tblAbetonProviderFees.ProdCode
            INNER JOIN tblProduct ON tblProduct.ProdCode = tblAbetonProviderFees.ProdCode

