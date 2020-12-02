--
-- Patch data for SSO notify preference bug. To be run against all US IMEC databases. does not have to 
-- be run against the Canadian systems.
-- DHT
--
update tblNotifyPreference set UserType = 'CL' where 
WebUserID IN (select WebUserID from tblClient where UserIDAdded = 'AutoProv') and UserType IS NULL



-- Issue 11850 - add states to tblOfficeState that MCMC user are limited to 
INSERT INTO tblOfficeState VALUES (43, 'CO', 'Admin', GetDate()),
 (43, 'AZ', 'Admin', GetDate()),
 (43, 'NV', 'Admin', GetDate()),
 (43, 'UT', 'Admin', GetDate())
 GO

