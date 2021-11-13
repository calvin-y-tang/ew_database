CREATE VIEW vwClientWebAcct
AS
    SELECT  tblCompany.intname AS company ,
            tblClient.lastname ,
            tblClient.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblClient ON tblWebUser.WebUserID = tblClient.WebUserID
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
    WHERE   ( tblWebUser.UserType = 'CL' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  'Doctor/Provider' AS Company ,
            tblDoctor.lastname ,
            tblDoctor.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblDoctor ON tblWebUser.WebUserID = tblDoctor.WebUserID
    WHERE   ( tblWebUser.UserType = 'DR' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblDoctor.companyname AS Company ,
            tblDoctor.lastname ,
            tblDoctor.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblDoctor ON tblWebUser.WebUserID = tblDoctor.WebUserID
    WHERE   ( tblWebUser.UserType = 'OP' )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblCCAddress.company ,
            tblCCAddress.lastname ,
            tblCCAddress.firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblCCAddress ON tblWebUser.WebUserID = tblCCAddress.WebUserID
    WHERE   ( ( tblWebUser.UserType = 'AT' )
              OR ( tblWebUser.UserType = 'CC' )
            )
            AND tblWebUser.StatusID <> 2
    UNION
    SELECT  tblTranscription.transcompany AS company ,
            '' AS lastname ,
            '' AS firstname ,
            tblWebUser.UserID ,
            tblWebUser.Password ,
            tblWebUser.LastLoginDate ,
            tblWebUser.UserType ,
            tblWebUserStatus.Description
    FROM    tblWebUser
			INNER JOIN tblWebUserStatus ON tblWebUser.StatusID = tblWebUserStatus.StatusID
            INNER JOIN tblTranscription ON tblWebUser.WebUserID = tblTranscription.WebUserID
    WHERE   ( tblWebUser.UserType = 'TR' )
            AND tblWebUser.StatusID <> 2

