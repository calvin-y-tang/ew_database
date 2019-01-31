CREATE VIEW vwFees
AS
    SELECT
        tblProduct.ProdCode,
        tblProduct.Description,
        tblProduct.LongDesc,
        tblProduct.CPTCode,
        tblFeeDetail.Fee,
        tblFeeDetail.LateCancelFee,
        tblFeeDetail.NoShowFee,
        tblFeeHeader.FeeCode AS Expr1,
        tblFeeHeader.FeeType,
        tblFeeHeader.Begin_Date,
        tblFeeHeader.End_Date,
        tblFeeHeader.LastUsed,
        tblProduct.Taxable,
        tblProduct.Status,
        tblProduct.INGLAcct,
        tblFeeHeader.Feedesc,
        tblFeeDetail.FeeCode,
        tblProduct.VOGLAcct,
        tblFeeDetail.CancelDays,
        tblFeeDetail.DrFee,
        tblFeeDetail.DrLateCancelFee,
        tblFeeDetail.DrNoShowFee,
        tblFeeHeader.DoctorCode,
        tblFeeHeader.DoctorLocation,
        tblFeeDetail.CancelDays2,
        tblFeeDetail.LateCancelFee2,
        tblFeeDetail.CancelDays3,
        tblFeeDetail.LateCancelFee3,
        tblFeeDetail.DrLateCancelFee2,
        tblFeeDetail.DrLateCancelFee3,
        tblFeeDetail.RecordInchesIncluded
    FROM
        tblProduct
    INNER JOIN tblFeeDetail ON tblProduct.ProdCode=tblFeeDetail.ProdCode
    INNER JOIN tblFeeHeader ON tblFeeDetail.FeeCode=tblFeeHeader.FeeCode
