CREATE PROCEDURE proc_IMEException
    @ExceptionID INT ,
    @OfficeCode INT ,
    @CaseTypeCode INT ,
    @ServiceCode INT ,
    @StatusCode INT ,
    @EnterLeave INT ,
    @CaseNbr INT
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @Err INT;

    SELECT  ED.* ,
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
    WHERE   ED.Status = 'Active' AND ED.ExceptionID = @ExceptionID
			AND
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
            AND ( ED.AllOffice = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = C.OfficeCode )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = @OfficeCode )
                )
            AND ( ED.CaseTypeCode = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = C.CaseType )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = @CaseTypeCode )
                )
            AND 
					(( ED.ServiceCode = 1
						OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = C.ServiceCode )
						OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = @ServiceCode )
					)
				OR  ( ED.AllEWServiceType = 1
						OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
											 INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
											 WHERE tS.ServiceCode = C.ServiceCode )
						OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
											 INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
											 WHERE tS.ServiceCode = @ServiceCode )
					))
            AND ( ( ED.StatusCode = -1
                    AND ( ED.ExceptionID <> 18
                            OR ISNULL(ED.StatusCodeValue, 1) = @EnterLeave
                        )
                    )
                    OR ( ED.StatusCode = @StatusCode
                        AND ED.StatusCodeValue = @EnterLeave
                        )
                )

    SET @Err = @@Error;

    RETURN @Err;
END;