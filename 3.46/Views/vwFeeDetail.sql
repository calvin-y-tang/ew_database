CREATE VIEW vwFeeDetail
AS
    SELECT  FD.FeeCode,
            FD.ProdCode,
            FD.Fee,
            FD.LateCancelFee,
            FD.NoShowFee,
            FD.DateAdded,
            FD.UserIDAdded,
            FD.DateEdited,
            FD.UserIDEdited,
            FD.DrFee,
            FD.DrLateCancelFee,
            FD.DrNoShowFee,
            FD.CancelDays,
            FD.CancelDays2,
            FD.LateCancelFee2,
            FD.CancelDays3,
            FD.LateCancelFee3,
            FD.DrLateCancelFee2,
            FD.DrLateCancelFee3,
            FD.RecordInchesIncluded,
            FD.feeplus,
            FD.MinFee,
            FD.Rounding,
            FD.RoundOn,
            FD.Divisor,
            FD.RevenueAcct,
            FD.ExpenseAcct,
            FD.Dept ,
            P.Description
    FROM    tblFeeDetail AS FD
            INNER JOIN tblProduct AS P ON P.ProdCode = FD.ProdCode

