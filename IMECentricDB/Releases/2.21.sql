UPDATE tblCaseHistory SET Type='ACCT'
 WHERE ISNULL(Type,'')=''
 AND Eventdesc LIKE 'Xport % to Dynamics'

UPDATE tblCaseHistory SET Type='ACCT'
 WHERE ISNULL(Type,'')=''
 AND (Eventdesc LIKE 'Invoice % Unfinalized' OR Eventdesc LIKE 'Voucher % Unfinalized')
GO


INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'MergeExaminee' ,
                'Examinee - Merge'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'MergeExaminee' )

GO


UPDATE tblCase SET DoctorReason='N/A'
 WHERE DoctorReason IS NULL AND DoctorCode IS NOT NULL
UPDATE tblCasePanel SET DoctorReason='N/A'
 WHERE DoctorReason IS NULL
GO

UPDATE tblControl SET DBVersion='2.21'
GO
