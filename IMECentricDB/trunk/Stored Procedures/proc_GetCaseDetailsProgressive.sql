CREATE PROCEDURE [proc_GetCaseDetailsProgressive] 
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblExaminee.*, 
		tblCase.*,
		CC1.ccCode DefenseAttorneyCode,
		CC1.LastName DefenseAttorneyLastName,
		CC1.FirstName DefenseAttorneyFirstName,
		CC1.Company DefenseAttorneyCompany,
		CC1.Address1 DefenseAttorneyAddress1,
		CC1.Address2 DefenseAttorneyAddress2,
		CC1.City DefenseAttorneyCity,
		CC1.[State] DefenseAttorneyState,
		CC1.Zip DefenseAttorneyZip,
		CC1.Phone DefenseAttorneyPhone,
		CC1.PhoneExtension DefenseAttorneyPhoneExt,
		CC1.Fax DefenseAttorneyFax,
		CC1.Email DefenseAttorneyEmail,
		CC2.ccCode PlaintiffAttorneyCode,
		CC2.LastName PlaintiffAttorneyLastName,
		CC2.FirstName PlaintiffAttorneyFirstName,
		CC2.Company PlaintiffAttorneyCompany,
		CC2.Address1 PlaintiffAttorneyAddress1,
		CC2.Address2 PlaintiffAttorneyAddress2,
		CC2.City PlaintiffAttorneyCity,
		CC2.[State] PlaintiffAttorneyState,
		CC2.Zip PlaintiffAttorneyZip,
		CC2.Phone PlaintiffAttorneyPhone,
		CC2.PhoneExtension PlaintiffAttorneyPhoneExt,
		CC2.Fax PlaintiffAttorneyFax,
		CC2.Email PlaintiffAttorneyEmail
		FROM tblCase
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr 
		LEFT JOIN tblCCAddress CC1 on tblCase.DefenseAttorneyCode = CC1.CCCode
		LEFT JOIN tblCCAddress CC2 on tblCase.PlaintiffAttorneyCode = CC2.CCCode
		WHERE tblCase.CaseNbr = @CaseNbr

	SET @Err = @@Error

	RETURN @Err
END
GO