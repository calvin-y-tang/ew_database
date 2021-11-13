CREATE VIEW vwFeeDetailAbeton
AS
    SELECT
        FD.FeeCode,
        FD.OfficeCode,
        FD.CaseType,
        FD.ProdCode,
        FD.fee,
        FD.latecancelfee,
        FD.noshowfee,
        FD.DateAdded,
        FD.UserIDAdded,
        FD.DateEdited,
        FD.UserIDEdited,
        FD.drfee,
        FD.drlatecancelfee,
        FD.drnoshowfee,
        FD.canceldays,
        FD.feeplus,
        FD.MinFee,
        FD.Rounding,
        FD.RoundOn,
        FD.Divisor,
        FD.RevenueAcct,
        FD.ExpenseAcct,
        FD.Dept,
        FD.flatfee,
        P.Description
    FROM
        tblFeeDetailAbeton AS FD
    INNER JOIN tblProduct AS P ON P.ProdCode=FD.ProdCode
GO
