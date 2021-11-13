CREATE PROCEDURE [proc_CaseVerifyAccessNP] 

@caseNbr int,
@ewwebuserid int

AS 

SELECT TOP 1 CaseNbr FROM tblCase 
WHERE 
(
ClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) 
OR
BillClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) 
)
AND tblCase.PublishOnWeb = 1 
AND tblCase.CaseNbr = @caseNbr
