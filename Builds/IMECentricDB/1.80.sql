--Changes to enable exception for parent company and third party biller
ALTER TABLE [tblExceptionDefinition]
  ADD [UseBillingEntity] BIT
GO


DROP PROCEDURE proc_IMEException
GO
CREATE PROCEDURE proc_IMEException

@ExceptionID int,                   -- ExceptionID we are looking for
@IMECentricCode int,                -- code related to the Entity.  Will be -1 if exception is not case related.
@CaseTypeCode int,                  -- will be -1 if not applicable
@ServiceCode int,                   -- will be -1 if not applicable
@StatusCode int,                    -- will be -1 if not applicable
@EnterLeave int,                    -- will be 0 if not applicable.  Will be 1 if we are looking for an exception with a case that has a statuscode that just entered the status, 2 if the case just left the statuscode
@CaseNbr int                        -- will be -1 if not applicable

AS

--declare local variables
DECLARE @clientcode int
DECLARE @parentCompanyID INT
DECLARE @companycode int

DECLARE @billClientCode int
DECLARE @billParentCompanyID INT
DECLARE @billCompanyCode int

DECLARE @doctorcode int

DECLARE @plaintiffattorneycode int
DECLARE @defenseattorneycode int
DECLARE @defparalegal INT


SET NOCOUNT ON

IF @CaseNbr <> -1 
BEGIN
      --fill variables
      SELECT    @clientcode = CL.ClientCode ,
				@parentCompanyID = CO.ParentCompanyID ,
                @companycode = CL.CompanyCode ,
                @doctorcode = C.DoctorCode ,
                @plaintiffattorneycode = C.PlaintiffAttorneyCode ,
                @defenseattorneycode = C.DefenseAttorneyCode ,
                @defparalegal = C.DefParaLegal ,
                @billClientCode = BCL.ClientCode ,
                @billParentCompanyID = BCO.ParentCompanyID ,
                @billCompanyCode = BCL.CompanyCode
      FROM      tblCase AS C
                INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
                LEFT OUTER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
                LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
                LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
      WHERE     C.CaseNbr = @CaseNbr
END
ELSE BEGIN
      SELECT    @clientcode = -1 ,
				@parentCompanyID = -1 ,
                @companycode = -1 ,
                @doctorcode = -1 ,
                @plaintiffattorneycode = -1 ,
                @defenseattorneycode = -1 ,
                @defparalegal = -1 ,
                @billClientCode = -1 ,
                @billParentCompanyID = -1,
                @billCompanyCode = -1
                
END

--declare temp table to hold return values
DECLARE @tblException TABLE
(
  ExceptionDefID int
)

DECLARE @entity_loop varchar(10)
DECLARE @IMECentricCode_loop int
DECLARE @CaseTypeCode_loop int
DECLARE @ServiceCode_loop int
DECLARE @StatusCode_loop int
DECLARE @StatusCodeValue_loop int
DECLARE @ExceptionDefID_loop INT
DECLARE @UseBillingEntity_loop BIT

DECLARE list cursor for
	SELECT  Entity ,
			IMECentricCode ,
			CaseTypeCode ,
			ServiceCode ,
			StatusCode ,
			StatusCodeValue ,
			ExceptionDefID, 
			UseBillingEntity
	FROM    tblExceptionDefinition
	WHERE   ExceptionID = @ExceptionID
			AND status = 'Active'

OPEN list
FETCH NEXT FROM list 
      INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop, @UseBillingEntity_loop
WHILE @@FETCH_STATUS = 0
BEGIN
      -- if exception is for a case @IMECentricCode should be -1
      IF @entity_loop = 'CS'
      BEGIN
            IF @IMECentricCode = -1
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              -- only include exception if just changed into that status
                              IF @StatusCodeValue_loop = @EnterLeave
                              BEGIN
                                    --do insert
                                    INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                              END
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END

                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END

                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END

      -- if exception is for a client
      IF @entity_loop = 'CL'
      BEGIN
            IF (@clientcode=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=0) OR (@billClientCode=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=1)
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode_loop = -1
                              BEGIN
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1, service = -1 and status = -1, then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END

      -- if exception is for a company
      IF @entity_loop = 'CO'
      BEGIN
			IF (@companycode=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=0) OR (@billCompanyCode=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=1)
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1, service = -1 and status = -1, then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END

      -- if exception is for a parent company
      IF @entity_loop = 'PC'
      BEGIN
			IF (@parentCompanyID=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=0) OR (@billParentCompanyID=@IMECentricCode_loop AND ISNULL(@UseBillingEntity_loop,0)=1)
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1, service = -1 and status = -1, then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18 
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END

      -- if exception is for a doctor
      IF @entity_loop = 'DR'
      BEGIN
            IF @doctorcode =  @IMECentricCode_loop
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode_Loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1, service = -1 and status = -1, then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END

      -- if exception is for an attorney
      IF @entity_loop = 'AT'
      BEGIN
            IF @defenseattorneycode =  @IMECentricCode_loop or  @plaintiffattorneycode =  @IMECentricCode_loop
            BEGIN
                  IF @CaseTypeCode = @CaseTypeCode_loop
                  BEGIN
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    IF @StatusCode <> -1
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                -- If casetype, service, and status all equal
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                          END                                                                                             
                                    END         
                              END
                              -- if casetype, service equal and status = -1 then insert
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END                                                               
                        END
                        -- if casetype equals and service and status = -1 then insert
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = @casetype and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END

                        END                                                         
                  END
                  
                  IF @CaseTypeCode_loop = -1
                  BEGIN
                        IF @ServiceCode_loop = -1
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1, service = -1 and status = -1, then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = -1 and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END   
                        IF @ServiceCode = @ServiceCode_loop
                        BEGIN
                              IF @StatusCode_loop = -1
                              BEGIN
                                    -- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
                                    -- only include exception if just changed into that status
                                    IF @ExceptionID = 18
                                    BEGIN
                                          IF @StatusCodeValue_loop = @EnterLeave
                                          BEGIN
                                                --do insert
                                                INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                               
                                          END                                 
                                    END
                                    ELSE
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)                                                                                
                                    END
                              END   
                              IF @StatusCode = @StatusCode_loop
                              BEGIN
                                    -- if casetype = -1 and service = @servicecode and status = @status then insert
                                    IF @StatusCodeValue_loop = @EnterLeave
                                    BEGIN
                                          --do insert
                                          INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
                                    END                                                                                             
                              END
                        END
                  END         
            END
      END


      FETCH NEXT FROM list 
            INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop, @UseBillingEntity_loop
END
CLOSE list
DEALLOCATE list

SELECT DISTINCT * FROM @tblException


GO



UPDATE tblControl SET DBVersion='1.80'
GO
