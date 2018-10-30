CREATE VIEW [dbo].[vwFeeScheduleRpt]
AS
SELECT  tblFeeHeader.FeeCode ,
        tblFeeHeader.FeeType ,
        tblFeeHeader.Feedesc ,
        tblFeeHeader.Begin_Date ,
        tblFeeHeader.End_Date ,
        tblFeeDetail.ProdCode ,
        tblFeeDetail.Fee ,
        tblFeeDetail.LateCancelFee ,
        tblFeeDetail.NoShowFee ,
        tblProduct.Description ,
        tblDoctor.LastName + ', ' + tblDoctor.FirstName + ' '
        + ISNULL(tblDoctor.Credentials, '') AS Doctorname ,
        tblLocation.Location ,
        tblFeeDetail.CancelDays ,
        tblFeeDetail.DrFee ,
        tblFeeDetail.DrLateCancelFee ,
        tblFeeDetail.DrNoShowFee ,
        tblFeeDetail.CancelDays2 ,
        tblFeeDetail.CancelDays3 ,
        tblFeeDetail.LateCancelFee2 ,
        tblFeeDetail.LateCancelFee3 ,
        tblFeeDetail.DrLateCancelFee2 ,
        tblFeeDetail.DrLateCancelFee3
FROM    tblFeeHeader
        INNER JOIN tblFeeDetail ON tblFeeHeader.FeeCode = tblFeeDetail.FeeCode
        INNER JOIN tblProduct ON tblFeeDetail.ProdCode = tblProduct.ProdCode
        LEFT OUTER JOIN tblLocation ON tblFeeHeader.DoctorLocation = tblLocation.LocationCode
        LEFT OUTER JOIN tblDoctor ON tblFeeHeader.DoctorCode = tblDoctor.DoctorCode
