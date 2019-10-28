
-- Issue 10169 - add column to tblCase - not sure if this is needed here since I changed the table in this project
  ALTER TABLE tblCase ADD RptQADraftDate DATETIME NULL
  ALTER TABLE tblCase ADD TATQADraftToQAComplete INT NULL


-- Issue 10169 data changes - adds data fields to use for TAT
  INSERT INTO tblDataField (DataFieldID, TableName, FieldName, Descrip) VALUES
  (214, 'tblCase', 'RptQADraftDate', 'Report QA Draft Date'),
  (120, 'tblCase', 'TATQADraftToQAComplete', '')

  -- Issue 10169 data changes - specifies how to calculate fields for TAT
  INSERT INTO tblTATCalculationMethod (TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend) VALUES
(20, 214, 204, 'Day', 120, 0)


-- Issue 10169 data changes - change the grouping display order for TAT calculation details so I can add new one in the middle
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 7 WHERE TATCalculationMethodID = 2 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 9 WHERE TATCalculationMethodID = 3 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 10 WHERE TATCalculationMethodID = 4 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 11 WHERE TATCalculationMethodID = 16 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 12 WHERE TATCalculationMethodID = 9 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 13 WHERE TATCalculationMethodID = 5 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 14 WHERE TATCalculationMethodID = 17 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 15 WHERE TATCalculationMethodID = 18 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 16 WHERE TATCalculationMethodID = 19 AND TATCalculationGroupID = 1

-- Issue 10169 data changes - add to the business line group IMEC
  INSERT INTO tblTATCalculationGroupDetail (TATCalculationGroupID, TATCalculationMethodID, DisplayOrder) VALUES
  (1, 20, 8)


