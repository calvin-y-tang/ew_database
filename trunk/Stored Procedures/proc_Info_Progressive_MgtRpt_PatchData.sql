CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_PatchData]
AS

print 'Retrieve the SLA reason'
 UPDATE T SET  
  T.SLAExceptions=(STUFF((SELECT ', ' + RTRIM(StartDate.Descrip) + ' to '+ RTRIM(EndDate.Descrip) + ': ' + CAST(RTRIM(SE.Descrip) + IIF(LEN(CSRD.Explanation) = 0, '', ': ') + RTRIM(ISNULL(CSRD.Explanation,'')) AS VARCHAR(4096))
 FROM tblCaseSLARuleDetail AS CSRD
	 INNER JOIN tblSLAException AS SE ON SE.SLAExceptionID = CSRD.SLAExceptionID
	 INNER JOIN tblSLARuleDetail AS SRD ON SRD.SLARuleDetailID = CSRD.SLARuleDetailID
	 INNER JOIN tblSLARule AS SR ON SR.SLARuleID = SRD.SLARuleID
	 LEFT OUTER JOIN tblTATCalculationMethod AS CalcMeth ON CalcMeth.TATCalculationMethodID = SRD.TATCalculationMethodID
	 LEFT OUTER JOIN tblDataField AS StartDate ON StartDate.DataFieldID = CalcMeth.StartDateFieldID
	 LEFT OUTER JOIN tblDataField AS EndDate ON EndDate.DataFieldID = CalcMeth.EndDateFieldID 
	 LEFT OUTER JOIN tblDataField AS TATDate ON TATDate.DataFieldID = CalcMeth.TATDataFieldID
  WHERE T.CaseNbr = CSRD.CaseNbr
  FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(4096)'),1,2,''))
  FROM ##tmpProgessiveMgtRpt as T


print 'Retrieve the most recent Report Date Viewed from the portal for each case ...'
UPDATE pmr SET pmr.ReportRetrievalDate = docs.DateViewed
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY cd.CaseNbr ORDER BY cd.SeqNo DESC) as ROWNUM, cd.CaseNbr, cd.SeqNo, pow.DateViewed
				FROM tblCaseDocuments as cd
					LEFT OUTER JOIN tblPublishOnWeb as pow on cd.SeqNo = pow.TableKey and pow.TableType = 'tblCaseDocuments'
				WHERE (cd.CaseNbr IN (Select pr.CaseNbr FROM ##tmpProgessiveMgtRpt as pr))
				  AND (cd.Type = 'Report') 
				) as tbl
		WHERE tbl.ROWNUM = 1) AS docs ON pmr.CaseNbr = docs.CaseNbr

print 'Get first no show appt date and time'
UPDATE pmr SET pmr.FirstNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 1 ) AS apt ON pmr.CaseNbr = apt.CaseNbr


print 'Get second no show appt date and time'
UPDATE pmr SET pmr.SecondNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 2 ) AS apt ON pmr.CaseNbr = apt.CaseNbr

print 'Get third no show appt date and time'
UPDATE pmr SET pmr.ThirdNoShow = apt.ApptTime
  FROM ##tmpProgessiveMgtRpt as pmr
	INNER JOIN (
SELECT *
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY CaseNbr ORDER BY CaseApptID ASC) as ROWNUM, ApptTime, CaseNbr 
				FROM tblCaseAppt as ca
				WHERE ca.CaseNbr IN (Select CaseNbr FROM ##tmpProgessiveMgtRpt)
				  and ca.ApptStatusID = 101
				) as tbl
		WHERE tbl.ROWNUM = 3 ) AS apt ON pmr.CaseNbr = apt.CaseNbr

print 'Return final result set'
SELECT *
  FROM ##tmpProgessiveMgtRpt 

print 'clean up'
IF OBJECT_ID('tempdb..##tmpProgessiveMgtRpt') IS NOT NULL DROP TABLE ##tmpProgessiveMgtRpt