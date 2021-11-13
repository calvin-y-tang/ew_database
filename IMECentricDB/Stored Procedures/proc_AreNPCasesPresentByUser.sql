
CREATE PROCEDURE [proc_AreNPCasesPresentByUser]
@ewwebuserid int

AS

SELECT TOP 1 CaseNbr FROM tblCase
            WHERE ClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN
            (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) AND tblCase.PublishOnWeb = 1


