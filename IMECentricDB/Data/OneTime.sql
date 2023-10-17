-- Sprint 121

-- IMEC-13804 - Add new tokens to tblMessageToken
USE IMECentricEW
GO
  INSERT INTO tblMessageToken (Name) 
  VALUES ('@DAttorneyName@'),
         ('@DAttorneyCompany@'),
         ('@DAttorneyAddr1@'),
         ('@DAttorneyAddr2@'),
         ('@DAttorneyAddr3@'),
         ('@DAttorneyPhone@'),
         ('@PAttorneyName@'),
         ('@PAttorneyCompany@'),
         ('@PAttorneyAddr1@'),
         ('@PAttorneyAddr2@'),
         ('@PAttorneyAddr3@'),
         ('@PAttorneyPhone@')

GO


