-- Sprint 107

-- IMEC-13437 patch existing tblDoctor data for new columns
USE IMECentricEW
GO
UPDATE dr
  SET CRNStatus = IIF(activeCnt.cnt IS NULL, dr.status, 'Active'),
      SavedStatus = dr.Status
 FROM tblDoctor as dr
          LEFT OUTER JOIN (SELECT COUNT(*) AS cnt, EWParentDocID, Status
                             FROM tblDoctor 
                             WHERE EWParentDocID IS NOT NULL
                               AND Status = 'Active'
                            GROUP BY EWParentDocID, Status) AS activeCnt ON activeCnt.EWParentDocID = dr.EWParentDocID
WHERE OPType = 'DR' 
GO

USE IMECentricFCE 
GO 
UPDATE dr
  SET CRNStatus = IIF(activeCnt.cnt IS NULL, dr.status, 'Active'),
      SavedStatus = dr.Status
 FROM tblDoctor as dr
          LEFT OUTER JOIN (SELECT COUNT(*) AS cnt, EWParentDocID, Status
                             FROM tblDoctor 
                             WHERE EWParentDocID IS NOT NULL
                               AND Status = 'Active'
                            GROUP BY EWParentDocID, Status) AS activeCnt ON activeCnt.EWParentDocID = dr.EWParentDocID
WHERE OPType = 'DR' 
GO

