-- Sprint 119

-- IMEC-13817 - Create business rules for Automated Referral Acknowledgement
DELETE 
  FROM tblExternalCommunications
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1070, 'CaseHistoryAdded', 'Case')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (116, 'CreateExtComm', 'Case', 'Create entry in tblExternalCommunications', 1, 1070, 0, 'ExtCommTypesAllowed', 'ExtCommEntity', NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (116, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'NewCase;', 'EntityType=PC;EntityID=9', NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13820 add new security token for edit doctor notes
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorEditNotes', 'Doctor - Edit Notes (Notes/QANotes/RecordReqNotes)', GETDATE())
GO

-- IMEC-13847 patch tblWebUser.MFAEmailAddr column using email address from source table
UPDATE wu
   SET MFAEmailAddr = CASE
                         WHEN cl.Email IS NOT NULL THEN SUBSTRING(cl.Email, 1, CASE CHARINDEX(';', cl.Email)
                                              WHEN 0 THEN NULL 
                                              ELSE CHARINDEX(';', cl.Email) - 1
                                              END) 
                         WHEN dr.EmailAddr IS NOT NULL THEN SUBSTRING(dr.EmailAddr, 1, CASE CHARINDEX(';', dr.EmailAddr)
                                              WHEN 0 THEN NULL 
                                              ELSE CHARINDEX(';', dr.EmailAddr) - 1
                                              END)
                         WHEN atty.Email IS NOT NULL THEN SUBSTRING(atty.Email, 1, CASE CHARINDEX(';', atty.Email)
                                              WHEN 0 THEN NULL 
                                              ELSE CHARINDEX(';', atty.Email) - 1
                                              END)
                         WHEN tr.Email IS NOT NULL THEN SUBSTRING(tr.Email, 1, CASE CHARINDEX(';', tr.Email)
                                              WHEN 0 THEN NULL 
                                              ELSE CHARINDEX(';', tr.Email) - 1
                                              END)
                         WHEN drA.Email IS NOT NULL THEN SUBSTRING(drA.Email, 1, CASE CHARINDEX(';', drA.Email)
                                              WHEN 0 THEN NULL 
                                              ELSE CHARINDEX(';', drA.Email) - 1
                                              END) 
                         ELSE NULL
                    END
FROM tblWebUser AS wu
          LEFT OUTER JOIN tblClient AS cl ON cl.ClientCode = wu.IMECentricCode AND wu.UserType = 'CL'
          LEFT OUTER JOIN tblDoctor AS dr ON dr.DoctorCode = wu.IMECentricCode AND wu.UserType IN ('DR', 'OP')
          LEFT OUTER JOIN tblCCAddress AS atty ON atty.ccCode = wu.IMECentricCode AND wu.UserType = 'AT'
          LEFT OUTER JOIN tblTranscription AS tr ON tr.TransCode = wu.IMECentricCode AND wu.UserType = 'TR'
          LEFT OUTER JOIN tblDrAssistant AS drA ON drA.DrAssistantID = wu.IMECentricCode AND wu.UserType = 'DA'
GO 

