CREATE PROCEDURE [proc_GetPublishOnWebRecordsByCaseNbr]

@CaseNbr int,
@UserCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'OP' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase' and tblPublishOnWeb.UserCode <> @UserCode
	union
	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'DR' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase' and tblPublishOnWeb.UserCode <> @UserCode

	ORDER BY LastName, Firstname

	SET @Err = @@Error

	RETURN @Err
END
GO