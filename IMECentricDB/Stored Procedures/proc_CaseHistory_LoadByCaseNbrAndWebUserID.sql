CREATE PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS


	SELECT DISTINCT tblCaseHistory.CaseNbr, tblCaseHistory.EventDate, tblCaseHistory.EventDesc, tblCaseHistory.DateAdded,
	tblCaseHistory.UserID, tblCaseHistory.OtherInfo, tblCaseHistory.ID, tblCaseHistory.[Type], tblPublishOnWeb.PublishID,
	tblPublishOnWeb.TableType, tblPublishOnWeb.TableKey, tblPublishOnWeb.UserID, tblPublishOnWeb.UserType, tblPublishOnWeb.UserCode,
	tblPublishOnWeb.PublishOnWeb, tblPublishOnWeb.PublishAsPDF, ISNULL(tblPublishOnWeb.Viewed, 0) Viewed, tblPublishOnWeb.CaseNbr, tblPublishOnWeb.UseWidget,
	tblPublishOnWeb.DateViewed
	FROM tblCaseHistory 
		INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode IN 
			(SELECT UserCode 
				FROM tblWebUserAccount 
				WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
				AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
		AND (tblCaseHistory.casenbr = @CaseNbr)
		ORDER BY tblCaseHistory.DateAdded DESC