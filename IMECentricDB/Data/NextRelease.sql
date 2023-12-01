-- Sprint 124

-- IMEC-13893 - Texas Tax configuration information for default time out, update expiration date, and IS email address for problems
INSERT INTO tblConfiguration (ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
VALUES (19, 'Tax Web Service', 1, 'Texas', GETDATE(), 'TLyde', 'DefaultTimeOutmsec=5000;NoResponseUpdateExpDate=1;EmailIS="william.cecil@examworks.com,Doug.Troy@examworks.com"')
GO

