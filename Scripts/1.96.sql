ALTER TABLE tblDoctor
 DROP COLUMN PracticingDoctor
GO

ALTER TABLE tblDoctor
 DROP COLUMN ActivePracticing
GO

ALTER TABLE tblDoctor
 ADD PracticingDoctor INT
GO


INSERT  INTO tbluserfunction
        ( functioncode ,
          functiondesc
        )
        SELECT  'DoctorDocumentEditDoc' ,
                'Doctor - Edit Document File'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'DoctorDocumentEditDoc' )

GO


UPDATE tblControl SET DBVersion='1.96'
GO
