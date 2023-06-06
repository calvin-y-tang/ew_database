-- Sprint 112

-- IMEC-13475 - initialize value for new column to -1 (<All>)
UPDATE tblSLAException
   SET TATCalculationMethodID = -1
 WHERE TATCalculationMethodID IS NULL
 GO 

