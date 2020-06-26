/*
1. Set the @dbID value to match the DB entry in IMECentricMaster
2. Make sure the script run against the target database
*/

DECLARE @dbID INT

------------------------
--Set Variables Manually
SET @dbID = 1008
------------------------




DECLARE @dbName VARCHAR(100)
DECLARE @country VARCHAR(2)
DECLARE @countryID INT
DECLARE @xmfPrefix VARCHAR(10)
DECLARE @portalMasterDBID INT
DECLARE @gpDBID INT
DECLARE @isTestSystem BIT
DECLARE @wcfServer VARCHAR(100)
DECLARE @twilioAddr VARCHAR(200)
DECLARE @helperPath VARCHAR(200)
DECLARE @maintLevel INT



--Auto Set Additional Variables
SELECT @dbName = Name FROM IMECentricMaster.dbo.DB WHERE DBID = @dbID
SELECT @country = CountryCode FROM IMECentricMaster.dbo.DB WHERE DBID = @dbID

IF ISNULL(@country,'') = ''
BEGIN
	RAISERROR (10001,-1,-1, 'CountryCode is missing in DB table');
END

IF @country = 'US'
BEGIN
	SET @countryID = 1
	SET @xmfPrefix = 'xmf'
	SET @portalMasterDBID = 400
	SET @gpDBID = 1
	IF @@SERVERNAME = 'SQLSERVER7\EW_IME_CENTRIC'
		SET @isTestSystem = 0
	ELSE
		SET @isTestSystem = 1
END

IF @country = 'CA'
BEGIN
	SET @countryID = 2
	SET @xmfPrefix = 'canfax'
	SET @portalMasterDBID = 410
	SET @gpDBID = 2
	IF @@SERVERNAME = 'SQLSERVER2-CA\EW_IME_CENTRIC'
		SET @isTestSystem = 0
	ELSE
		SET @isTestSystem = 1
END



--Start setting configuration data in database
IF @isTestSystem=1
BEGIN
	SET @wcfServer = 'Dev4'
	SET @helperPath = '\\EWISApp1\Deploy\IMECentricHelper\Test\'
	SET @twilioAddr = 'https://services.examworks.com/EWTwilioHub/api/CallCenter/'
END
ELSE
BEGIN
	SET @wcfServer = 'EWISApp1'
	SET @helperPath = '\\EWISApp1\Deploy\IMECentricHelper\'
	SET @twilioAddr = 'https://services.examworks.com/TestEWTwilioHub/api/CallCenter/'
END





--System Information
UPDATE tblControl SET DBID=@dbID
UPDATE tblControl SET PortalMasterDBID=@portalMasterDBID
UPDATE tblControl SET GPDBID=@gpDBID

UPDATE tblControl SET IsTestSystem=@IsTestSystem
UPDATE tblControl SET CountryID=@countryID
UPDATE tblControl SET AppTitle=(SELECT Descrip FROM IMECentricMaster.dbo.DB WHERE DBID=@dbID)

UPDATE tblControl SET DirIMECentricHelper='\\EWISApp1\Deploy\IMECentricHelper\Test\'
UPDATE tblControl SET XMediusFaxPrefix=@xmfPrefix
UPDATE tblControl SET EWServiceBinding='BasicHttpBinding', EWServiceAddress='http://' + @wcfServer + ':8080' + '/'
UPDATE tblConfirmationSetup SET ServerAddress=@twilioAddr WHERE ConfirmationSystemID = 1


--Test System Only
IF @isTestSystem=1
BEGIN
	UPDATE tblControl SET MaintenanceAccessLevel = 3

	update tblWebCompany
	set URL = 'https://testwebportal.examworks.com'
	where name = 'Examworks'

	update tblWebCompany
	set URL = 'https://testwebportal.solomonassoc.com'
	where name = 'Solomon Associates'

	update tblWebCompany
	set URL = 'https://testwebportal.royal-medical.com'
	where name = 'Royal Medical Consultants'
END