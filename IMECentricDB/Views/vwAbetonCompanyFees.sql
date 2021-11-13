CREATE VIEW vwAbetonCompanyFees
AS
    SELECT  tblFeeHeader.FeeCode ,
            tblFeeHeader.Feedesc ,
            tblFeeHeader.Begin_Date ,
            tblFeeHeader.End_Date ,
            tblProduct.Description AS ProductDesc ,
            tblFeeDetailAbeton.latecancelfee AS FSLateCancel ,
            tblFeeDetailAbeton.noshowfee AS FSNoShow ,
            tblFeeDetailAbeton.canceldays AS FSCancelDays ,
            tblFeeDetailAbeton.flatfee ,
            tblFeeDetailAbeton.OfficeCode ,
            tblFeeDetailAbeton.CaseType ,
            tblFeeDetailAbeton.ProdCode
    FROM    tblFeeHeader
            INNER JOIN tblFeeDetailAbeton ON tblFeeDetailAbeton.FeeCode = tblFeeHeader.FeeCode
            INNER JOIN tblProduct ON tblFeeDetailAbeton.ProdCode = tblProduct.ProdCode

