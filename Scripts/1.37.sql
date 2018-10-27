----------------------------------------------------
--Remove tblEWFlashCategory for new one
----------------------------------------------------

IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblEWFlashCategory]')
                    AND OBJECTPROPERTY(id, N'IsTable') = 1 ) 
    DROP TABLE dbo.tblEWFlashCategory
GO

----------------------------------------------------
--Correct exception stored procedure
----------------------------------------------------

ALTER    PROCEDURE [dbo].[proc_IMEException]

@ExceptionID int,                   -- ExceptionID we are looking for
@IMECentricCode int,                -- code related to the Entity.  Will be -1 if exception is not case related.
@CaseTypeCode int,                        -- will be -1 if not applicable
@ServiceCode int,                   -- will be -1 if not applicable
@StatusCode int,                    -- will be -1 if not applicable
@EnterLeave int,                    -- will be 0 if not applicable.  Will be 1 if we are looking for an exception with a case that has a statuscode that just entered the status, 2 if the case just left the statuscode
@CaseNbr int                              -- will be -1 if not applicable

AS

--declare local variables
DECLARE @clientcode int
DECLARE @companycode int
DECLARE @doctorcode int
DECLARE @plaintiffattorneycode int
DECLARE @defenseattorneycode int
DECLARE @defparalegal int
SET NOCOUNT ON

IF @CaseNbr <> -1 
BEGIN
      --fill variables
      SELECT @clientcode = tblclient.clientcode, 
                  @companycode = tblclient.companycode,
                  @doctorcode = doctorcode, 
                  @plaintiffattorneycode = plaintiffattorneycode, 
                  @defenseattorneycode = defenseattorneycode, 
                  @defparalegal = defparalegal
      FROM tblCase
            INNER JOIN tblclient ON tblclient.clientcode = tblcase.clientcode
                  WHERE casenbr = @CaseNbr
END
ELSE BEGIN
      select @clientcode = -1,
             @companycode = -1,
               @doctorcode = -1,
               @plaintiffattorneycode = -1,
               @defenseattorneycode = -1,
               @defparalegal = -1
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
DECLARE @ExceptionDefID_loop int
DECLARE list cursor for
SELECT Entity, IMECentricCode, CaseTypeCode, ServiceCode, StatusCode, StatusCodeValue, ExceptionDefID 
      FROM tblExceptionDefinition WHERE ExceptionID = @ExceptionID AND status = 'Active'

OPEN list
FETCH NEXT FROM list 
      INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop
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
            IF @clientcode =  @IMECentricCode_loop
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
            IF @companycode =  @IMECentricCode_loop
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
            INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop
END
CLOSE list
DEALLOCATE list

SELECT DISTINCT * FROM @tblException


GO

---------------------------------------------------------------------------------
--Adding Security function to access the custom programs from the menu
---------------------------------------------------------------------------------


insert into tbluserfunction(functioncode, functiondesc) values('CustomProgram', 'Custom - Custom Program')
GO


---------------------------------------------------------------------------------
--Add option to flatten form fields on PDF template
--Add new field in tblIssue to map the bookmark name for issue
---------------------------------------------------------------------------------

ALTER TABLE [tblDocument]
  ADD [FlattenFormFields] BIT
GO

UPDATE tblDocument
 SET FlattenFormFields=1
 WHERE TemplateFormat='PDF'
GO

ALTER TABLE [tblIssue]
  ADD [Bookmark] VARCHAR(30)
GO





update tblControl set DBVersion='1.37'
GO