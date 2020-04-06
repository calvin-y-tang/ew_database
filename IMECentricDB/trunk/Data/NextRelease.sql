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
