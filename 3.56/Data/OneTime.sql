--S38


--  Jurisdiction & EWBusLineID = 1 (Liability)
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('SW', NULL, 2, 1, 12, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MI', '15', NULL, NULL, NULL, NULL)

--  Jurisdiction & EWBusLineID = 2 (first party auto)
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('SW', NULL, 2, 1, 12, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, 'MI', '15', NULL, NULL, NULL, NULL)

--  Jurisdiction & EWBusLineID = 5 (third party auto)
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('SW', NULL, 2, 1, 12, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MI', '15', NULL, NULL, NULL, NULL)



-- Issue 11147

BEGIN TRANSACTION TRX
  
BEGIN TRY  
  print 'Updating tblCase ...'
  UPDATE tblCase SET [SReqSpecialty] = 'Chiropractic' WHERE [SReqSpecialty] = 'Chiropractic Medicine'
  UPDATE tblCase SET [SReqSpecialty] = 'Pain Medicine' WHERE [SReqSpecialty] = 'Pain Management'
  
  UPDATE tblCase SET [DoctorSpecialty] = 'Chiropractic' WHERE [DoctorSpecialty]  = 'Chiropractic Medicine'
  UPDATE tblCase SET [DoctorSpecialty] = 'Pain Medicine' WHERE [DoctorSpecialty]  = 'Pain Management'

  print 'Updating tblCaseAppt ...'
  UPDATE tblCaseAppt SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblCaseAppt SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblCaseApptPanel ...'
  UPDATE tblCaseApptPanel SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblCaseApptPanel SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblCasePanel ...'
  UPDATE tblCasePanel SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblCasePanel SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblCasePeerBill ...'
  UPDATE tblCasePeerBill SET [ProviderSpecialtyCode] = 'Chiropractic' WHERE [ProviderSpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblCasePeerBill SET [ProviderSpecialtyCode] = 'Pain Medicine' WHERE [ProviderSpecialtyCode] = 'Pain Management'

  print 'Updating tblCaseSpecialty ...'
  UPDATE tblCaseSpecialty SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblCaseSpecialty SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblDoctorDocuments ...'
  UPDATE tblDoctorDocuments SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblDoctorDocuments SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblDoctorMargin ...'
  UPDATE tblDoctorMargin SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblDoctorMargin SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblDoctorRecommend ...'
  UPDATE tblDoctorRecommend SET [Specialty] = 'Chiropractic' WHERE [Specialty] = 'Chiropractic Medicine'
  UPDATE tblDoctorRecommend SET [Specialty] = 'Pain Medicine' WHERE [Specialty] = 'Pain Management'

  print 'Updating tblDoctorSpecialty ...'
  UPDATE tblDoctorSpecialty SET [SpecialtyCode] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblDoctorSpecialty SET [SpecialtyCode] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'

  print 'Updating tblExternalCommunications ...'
  UPDATE tblExternalCommunications SET [DoctorSpecialty] = 'Chiropractic' WHERE [DoctorSpecialty] = 'Chiropractic Medicine'
  UPDATE tblExternalCommunications SET [DoctorSpecialty] = 'Pain Medicine' WHERE [DoctorSpecialty] = 'Pain Management'

  print 'Updating tblSpecialty ...'
  UPDATE tblSpecialty SET [SpecialtyCode] = 'Chiropractic', [Description] = 'Chiropractic' WHERE [SpecialtyCode] = 'Chiropractic Medicine'
  UPDATE tblSpecialty SET [SpecialtyCode] = 'Pain Medicine', [Description] = 'Pain Medicine' WHERE [SpecialtyCode] = 'Pain Management'


  print 'Opertions Completed'
END TRY  
BEGIN CATCH  
    print 'Error ...'
    SELECT	ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,  
			ERROR_STATE() AS ErrorState,  
			ERROR_PROCEDURE() AS ErrorProcedure,  
			ERROR_LINE() AS ErrorLine,  
			ERROR_MESSAGE() AS ErrorMessage
  
    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION TRX
END CATCH
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION TRX  
