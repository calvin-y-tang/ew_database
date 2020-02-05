CREATE PROCEDURE proc_IMEException
    @ExceptionID INT ,
    @OfficeCode INT ,
    @CaseTypeCode INT ,
    @ServiceCode INT ,
    @StatusCode INT ,
    @EnterLeave INT ,
    @CaseNbr INT, 
	@SLARuleDetailID INT
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @Err INT;

	-- DEV NOTE: Changed this to be a SELECT DISTINCT when the SLA tables were added to this.
	--	the problem is with tblSLARuleDetail because that will have multiple items for each SLA Rule.
	--	Just need to keep this point in mind when making any future changes to this stored procedure.

    SELECT  DISTINCT 
		ED.ExceptionDefID, 
		ED.Description, 
		ED.Entity, 
		ED.IMECentricCode,
		ED.ExceptionID, 
		ED.CaseTypeCode, 
		ED.ServiceCode, 
		ED.StatusCodeValue, 
		ED.DisplayMessage, 
		ED.RequireComment, 
		ED.EmailMessage,
		ED.EditEMail, 
		ED.GenerateDocument, 
		CAST(ED.Message AS VARCHAR(MAX)) AS Message, 
		ED.EmailScheduler, 
		ED.EmailQA, 
		ED.EmailOther, 
		ED.EmailSubject, 
		CAST(ED.EmailText AS VARCHAR(MAX)) AS EmailText, 
		ED.Document1, 
		ED.Document2, 
		ED.Status,
		ED.DateAdded, 
		ED.UserIDAdded, 
		ED.DateEdited, 
		ED.UserIDEdited, 
		ED.UseBillingEntity, 
		ED.AllOffice, 
		ED.CreateCHAlert,
		ED.CHEventDesc,
		ED.ChOtherInfo,
		ED.AllEWServiceType, 
		ED.AllCaseType, 
		ED.AllService, 
		ED.AllSLARuleDetail,
		ISNULL(C.CaseNbr, -1) AS CaseNbr ,
		CL.ClientCode ,
		CO.ParentCompanyID ,
		CL.CompanyCode ,
		C.DoctorCode ,
		C.PlaintiffAttorneyCode ,
		C.DefenseAttorneyCode ,
		C.DefParaLegal ,
		BCL.ClientCode AS BillClientCode ,
		BCO.ParentCompanyID AS BillParentCompanyID ,
		BCL.CompanyCode AS BillCompanyCode
    FROM    tblExceptionDefinition AS ED
            LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = @CaseNbr
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
            LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
            LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
			LEFT OUTER JOIN tblEmployer AS ER ON ER.EmployerID = C.EmployerID
			LEFT OUTER JOIN tblEWParentEmployer AS PE ON PE.EWParentEmployerID = ER.EWParentEmployerID
			LEFT OUTER JOIN tblSLARule AS  SLA ON SLA.SLARuleID = C.SLARuleID 
			LEFT OUTER JOIN tblSLARuleDetail AS SLADET ON SLADET.SLARuleID = SLA.SLARuleID 
    WHERE   ED.Status = 'Active' AND ED.ExceptionID = @ExceptionID
			AND
			(
				( ED.Entity = 'CA' 
					AND C.CaseNbr IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
				)
				OR
				( ED.Entity = 'CS'
	                OR ( ED.Entity = 'PC'
	                    AND ( CO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND ISNULL(ED.UseBillingEntity, 0) = 0
	                        
	                    OR  BCO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND ISNULL(ED.UseBillingEntity, 0) = 1
	                        )
	                    )
	                OR ( ED.Entity = 'CO'
	                    AND ( CL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND ISNULL(ED.UseBillingEntity, 0) = 0
	                        
	                    OR  BCL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND ISNULL(ED.UseBillingEntity, 0) = 1
	                        )
	                    )
	                OR ( ED.Entity = 'CL'
	                    AND ( CL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND ISNULL(ED.UseBillingEntity, 0) = 0
	                       
	                    OR  BCL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND ISNULL(ED.UseBillingEntity, 0) = 1
	                        )
	                    )
	                OR ( ED.Entity = 'DR'
	        			AND ( C.DoctorCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	                OR ( ED.Entity = 'AT'
	                    AND ( C.PlaintiffAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                    
						OR C.DefenseAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        )
	                    )
	                OR ( ED.Entity = 'PE'
	                    AND ( ER.EWParentEmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	                OR ( ED.Entity = 'ER'
	                    AND ( C.EmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	            )
			)
            AND ( ED.AllOffice = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = C.OfficeCode )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = @OfficeCode )
                )
            AND ( ED.AllCaseType = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = C.CaseType )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = @CaseTypeCode )
                )
            AND 
				( ED.AllService = 1
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = C.ServiceCode )
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = @ServiceCode )
				)
			AND
				( ED.AllEWServiceType = 1
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
										INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
										WHERE tS.ServiceCode = C.ServiceCode )
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
										INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
										WHERE tS.ServiceCode = @ServiceCode )
				)
            AND ( ( ED.StatusCode = -1
                    AND ( ED.ExceptionID <> 18
                            OR ISNULL(ED.StatusCodeValue, 1) = @EnterLeave
                        )
                    )
                    OR ( ED.StatusCode = @StatusCode
                        AND ED.StatusCodeValue = @EnterLeave
                        )
                )
			AND 
				( ED.AllSLARuleDetail = 1
					OR SLADET.SLARuleDetailID IN (SELECT SLARuleDetailID 
					                                FROM tblExceptionDefSLARuleDetail 
												   WHERE SLARuleDetailID = @SLARuleDetailID 
												     AND ExceptionDefID = ED.ExceptionDefID)
				)

    SET @Err = @@Error;

    RETURN @Err;
END;