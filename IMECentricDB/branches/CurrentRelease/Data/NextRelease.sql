-- Issue 11547 - Add Secondary Email for V2 Client Portal Notifications
INSERT INTO tblNotifyAudience
(
    NotifyEventID,
    NotifyMethodID,
    UserType,
    ActionType,
    DateAdded,
    UserIDAdded,
    DateEdited,
    UserIDEdited,
    DefaultPreferenceValue,
    TableType
)
SELECT
NotifyEventID,
NotifyMethodID,
'SD',
ActionType,
DateAdded,
UserIDAdded,
DateEdited,
UserIDEdited,
0,
TableType
FROM tblNotifyAudience
WHERE UserType='CL'
and NotifyMethodID=2
GO

UPDATE NP SET NP.UserType = WU.UserType 
from tblNotifyPreference AS NP INNER JOIN tblWebUser AS WU ON NP.WebUserID = WU.WebUserID

INSERT INTO tblNotifyPreference
  (
      WebUserID,
      NotifyEventID,
      NotifyMethodID,
      DateEdited,
      UserIDEdited,
      PreferenceValue,
      UserType
  )
  SELECT DISTINCT
  NP.WebUserID,
  NA.NotifyEventID,
  NA.NotifyMethodID,
  GETDATE(),
  'System',
  NA.DefaultPreferenceValue,
  NA.UserType
  FROM tblNotifyPreference AS NP
  INNER JOIN tblNotifyAudience AS NA ON NA.UserType = 'SD'
  WHERE NP.UserType = 'CL'

GO





insert into tbluserfunction (functioncode, functiondesc)
 select 'EditApptCancelReason', 'Appointment - Edit Cancel Reason'
 where not exists (select functionCode from tblUserFunction where functionCode='EditApptCancelReason')
GO


INSERT INTO tblDataField
(
    DataFieldID,
    TableName,
    FieldName,
    Descrip
)
VALUES
(   215,  -- DataFieldID - int
    'tblCase', -- TableName - varchar(35)
    'OrigApptMadeDate', -- FieldName - varchar(35)
    'Exam Scheduled'  -- Descrip - varchar(70)
    )
GO
UPDATE tblTATCalculationMethod SET EndDateFieldID=215 WHERE TATCalculationMethodID=7
GO





UPDATE tblCase SET OrigApptMadeDate=(SELECT TOP 1 DateAdded FROM tblCaseAppt WHERE tblCaseAppt.CaseNbr=tblCase.CaseNbr ORDER BY CaseApptID DESC)
GO



-- Issue 11595 Data Patch for Making Portal Fields Reqd/Optional by Web Users
  UPDATE tblCompany Set AllowMedIndex = 0, AllowScheduling = 0, ShowFinancialInfo = 1
  UPDATE tblWebUser Set AllowMedIndex = 0
  UPDATE tblEWParentCompany Set AllowMedIndex = 0, AllowScheduling = 0, ShowFinancialInfo = 1
