
ALTER TABLE tblDoctor
 ADD AddExceptionTriggered BIT
GO

ALTER TABLE tblCaseAppt
 ADD DateReceived DATETIME
GO


INSERT INTO tblUserFunction
        ( FunctionCode, FunctionDesc )
VALUES  ( 'SetApptDateReceived', -- FunctionCode - varchar(30)
          'Appointments - Set Date Received'  -- FunctionDesc - varchar(50)
          )
GO


UPDATE tblControl SET DBVersion='2.06'
GO
