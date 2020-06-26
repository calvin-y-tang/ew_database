/*
1. Make sure the script run against the target database
*/





DECLARE @isTestSystem BIT
DECLARE @testEmailAddr VARCHAR(200)
DECLARE @qaEmailAddr VARCHAR(200)
DECLARE @testPhone VARCHAR(200)

--Set Variables
SET @testEmailAddr = 'ewistest@examworks.com'
SET @qaEmailAddr = 'xao.metteauer@examworks.com'
SET @testPhone = '(123) 456-7890'

--Auto Set Additional Variables
SELECT @isTestSystem = IsTestSystem FROM tblControl


--System Information
IF @isTestSystem=1
BEGIN
    UPDATE tblUser SET Email=@testEmailAddr WHERE Admin=0 AND Email IS NOT NULL
    UPDATE tblDoctor SET EmailAddr=@testEmailAddr WHERE EmailAddr IS NOT NULL
    UPDATE tblClient SET Email=@testEmailAddr WHERE Email IS NOT NULL
    UPDATE tblCCAddress SET Email=@testEmailAddr WHERE Email IS NOT NULL
    UPDATE tblExaminee SET Email=@testEmailAddr WHERE Email IS NOT NULL
    UPDATE tblTranscription SET Email=@testEmailAddr WHERE Email IS NOT NULL
    UPDATE tblExceptionDefinition SET EmailOther=@testEmailAddr WHERE EmailOther IS NOT NULL

    UPDATE tblOffice SET bccEmailAddress=@qaEmailAddr, ReferralNotifyEmail=@qaEmailAddr, FileUploadNotifyEmail=@qaEmailAddr, NotificationEmailAddress=@qaEmailAddr
    UPDATE tblIMEData SET EmailAddress = @qaEmailAddr
    update tblofficecontact set email = @qaEmailAddr
    UPDATE tblCase SET WebNotifyEmail=@qaEmailAddr WHERE WebNotifyEmail IS NOT NULL

    UPDATE tblClient SET Phone1=@testPhone, Phone2=@testPhone, Fax=@testPhone
    UPDATE tblDoctor SET Phone=@testPhone, Pager=@testPhone, FaxNbr=@testPhone
    UPDATE tblExaminee SET Phone1=@testPhone, Phone2=@testPhone, MobilePhone=@testPhone, Fax=@testPhone
    UPDATE tblCCAddress SET Phone=@testPhone
    UPDATE tblEmployerAddress SET Phone=@testPhone
    UPDATE tblFacility SET Phone=@testPhone
    UPDATE tblLocation SET Phone=@testPhone
    UPDATE tblRelatedParty SET Phone=@testPhone
    UPDATE tblTreatingDoctor SET Phone=@testPhone
    UPDATE tblUser SET Phone=@testPhone
END


/*
UPDATE tblControl SET DBVersion='x.xx'
*/