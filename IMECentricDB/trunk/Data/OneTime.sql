--
-- Patch data for SSO notify preference bug. To be run against all US IMEC databases. does not have to 
-- be run against the Canadian systems.
-- DHT
--
update tblNotifyPreference set UserType = 'CL' where 
WebUserID IN (select WebUserID from tblClient where UserIDAdded = 'AutoProv') and UserType IS NULL