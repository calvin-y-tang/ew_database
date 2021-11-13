
CREATE VIEW vwDoctorFeeSchedule
AS
SELECT DISTINCT
 DFS.DoctorFeeScheduleID,
 D.DoctorCode,
 DP.ProdCode,
 DP.Description AS Product,
 BL.EWBusLineID,
 BL.Name AS BusLine,
 S.EWSpecialtyID,
 DS.SpecialtyCode AS Specialty,
 N.EWNetworkID,
 N.Name AS Network,
 N.SeqNo AS NetworkOrder,
 L.LocationCode,
 L.Location,
 DFS.EffDate,
 DFS.FeeAmount,
 DFS.CancelDays,
 DFS.LateCancelAmount,
 DFS.NoShow1Amount,
 DFS.NoShow2Amount,
 DFS.NoShow3Amount
 FROM tblDoctor AS D
 INNER JOIN
 (
   SELECT DISTINCT DF.DoctorCode, P.ProdCode, P.Description FROM tblProduct AS P
    INNER JOIN tblDoctorFeeSchedule AS DF ON P.ProdCode = DF.ProdCode
 ) AS DP ON DP.DoctorCode = D.DoctorCode
 INNER JOIN tblDoctorBusLine AS DBL ON DBL.DoctorCode = D.DoctorCode
 INNER JOIN tblEWBusLine AS BL ON BL.EWBusLineID = DBL.EWBusLineID
 INNER JOIN tblDoctorSpecialty AS DS ON DS.DoctorCode = D.DoctorCode
 INNER JOIN tblSpecialty AS S ON S.SpecialtyCode = DS.SpecialtyCode
 INNER JOIN tblDoctorLocation AS DL ON DL.DoctorCode = D.DoctorCode
 INNER JOIN tblLocation AS L ON L.LocationCode = DL.LocationCode
 LEFT OUTER JOIN tblDoctorNetwork AS DN ON DN.DoctorCode = D.DoctorCode
 LEFT OUTER JOIN tblEWNetwork AS N ON N.EWNetworkID = DN.EWNetworkID OR N.OutOfNetwork=1
 LEFT OUTER JOIN tblDoctorFeeSchedule AS DFS ON DFS.DoctorCode = -1

