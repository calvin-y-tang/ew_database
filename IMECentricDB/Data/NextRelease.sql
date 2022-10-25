-- Sprint 96

-- IMEC-13120 - in table tblExceptionDefEntity, set field Entity to NULL in all DB's
UPDATE tblExceptionDefEntity SET Entity = NULL
GO

-- IMEC-13145  - create new tblCodes Entry for SLA Calc For Exam values
INSERT INTO tblCodes(Category, SubCategory, Value)
VALUES('SLARuleAppt', 'First Scheduled Exam', '10'),
	  ('SLARuleAppt', 'Subsequent Scheduled Exams', '20'),
	  ('SLARuleAppt', 'All Exams', '30'),
	  ('SLARuleAppt', 'Not Applicable', '40')
GO

-- IMEC-13145 patch existing data
UPDATE TCM
	   SET isApptBased = 1
FROM tblTATCalculationMethod AS TCM  
	        INNER JOIN tblDataField AS SD ON TCM.StartDateFieldID = SD.DataFieldID   
	        INNER JOIN tblDataField AS ED ON TCM.EndDateFieldID = ED.DataFieldID  
WHERE sd.TableName = 'tblCaseAppt' or ed.TableName = 'tblCaseAPpt'
GO
UPDATE TCM
	   SET isApptBased = 0
FROM tblTATCalculationMethod AS TCM  
WHERE isApptBased is null
GO 
UPDATE SLA 
   SET CalculateForExam = IIF(TAT.IsApptBased = 1, 30, 40)
FROM tblSLARuleDetail AS SLA
          INNER JOIN tblTATCalculationMethod AS TAT ON TAT.TATCalculationMethodID = SLA.TATCalculationMethodID
WHERE SLA.CalculateForExam IS NULL
GO
