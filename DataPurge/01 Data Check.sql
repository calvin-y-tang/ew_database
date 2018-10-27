-- **********************************************************************************************************
--
--   Description:
--        Pre-Migration Clean up and data validation/verification.
--        The script has a number of MANUAL SELECT statements to execute. Included are DELETE/UPDATE
--        statements that are optionally executed based upon the results of the statement and the
--        discretion of the person that is performing the cleanup.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--        3. 09/08/2015 - DHT - added notes for those items Jose marked
--
-- **********************************************************************************************************

-- CLEANUP THE FINANCIAL\BILLING TABLES
     -- Grab the rows from AcctDetail that do not have an AcctHeader row. These are orphaned items
     -- most likely should be removed.
     SELECT AD.*
     --DELETE AD
      FROM tblAcctDetail AS AD
               LEFT OUTER JOIN tblAcctHeader AS AH ON AH.DocumentNbr = AD.DocumentNbr AND AH.DocumentType = AD.DocumentType
      WHERE AH.DocumentNbr IS NULL

     -- Grab the rows from AcctTrans that do not have an AcctHeader row. These are orphaned items
     -- but instead of deleting them the DocumentNbr should be set to NULL to break any potential link.
     SELECT *
     --UPDATE AT SET AT.DocumentNbr=NULL
      FROM tblAcctingTrans AS AT
               LEFT OUTER JOIN tblAcctHeader AS AH ON AH.DocumentNbr = AT.DocumentNbr AND AH.DocumentType=AT.Type
      WHERE AH.DocumentNbr IS NULL AND AT.DocumentNbr IS NOT NULL

     -- Find all the records in tblAcctingTrans that have a NULL (missing) SeqNo value where we have 
     -- a record in tblAcctHeader
     SELECT *
      FROM tblAcctHeader AS AH
               LEFT OUTER JOIN tblAcctingTrans AS AT ON AH.SeqNo = AT.SeqNO --AT.DocumentNbr=AH.DocumentNbr AND AH.DocumentType=AT.Type
      WHERE AT.SeqNO IS NULL AND AH.SeqNo IS NOT NULL

     -- find any doctor check request records where we don't have a matching record in accting trans
     SELECT *
       FROM tblDoctorCheckRequest
      WHERE AcctingTransID NOT IN (SELECT SeqNo FROM tblAcctingTrans)

     -- Grab the rows from ClaimInfo that have an InvoiceNbr that is not in AcctHeader. These are orphaned
     -- ClaimInfo rows that no long have a linked AcctHeader row and should be removed.
     SELECT *
     --DELETE
      FROM tblClaimInfo
     WHERE InvoiceNbr NOT IN (SELECT documentNbr FROM tblAcctHeader WHERE DocumentType='IN')

     -- Grab AcctHeader rows where the OfficeCode is mismatched to the Case table. These items
     -- should be updated so that the office codes between these tables are in sync.
     SELECT AH.*
     --UPDATE AH SET AH.OfficeCode=C.OfficeCode
      FROM tblAcctHeader AS AH
               INNER JOIN tblCase AS C ON C.CaseNbr = AH.CaseNbr
      WHERE AH.OfficeCode<>C.OfficeCode
        AND (C.OfficeCode=7 OR AH.OfficeCode=7)

     -- Grab the rows from GPInvoice that have an invoice which is not present in the AcctHeader
     -- table. These items are orphans and should be deleted.
     SELECT *
     --DELETE
      FROM tblGPInvoice
     WHERE InvoiceNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='IN')

     -- Grab the rows from GPVoucher that have a voucher which is not present in the AcctHeader
     -- table. These items are orphans and should be deleted.
     SELECT *
     --DELETE
      FROM tblGPVoucher
     WHERE VoucherNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='VO')


-- CLEAN UP SOME OF TABLES THAT HAVE INFORMATION THAT IS RELATED TO A CASE
     -- Grab the rows from the Case table that do not have an OfficeCode specified.
     -- This condition is something that the application should not allow to happen. It is fine to
     -- delete these rows.
     SELECT *
     --DELETE
      FROM tblCase
     WHERE ISNULL(OfficeCode,0)=0

     -- Grab the rows from CaseDefDocuments that are pointing to a Case that is no longer
     -- present in the Case table. These rows are orphaned and can be removed.
     SELECT *
     --DELETE
      FROM tblCaseDefDocument
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from CaseDocuments that are pointing to a Case that is no longer
     -- present in the Case table. These rows are orphaned and can be removed.
     SELECT *
     --DELETE
      FROM tblCaseDocuments
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from CaseHistory that are pointing to a Case that is no longer
     -- present in the Case table. These rows are orhpaned and can be removed.
     SELECT *
     --DELETE
      FROM tblCaseHistory
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from CaseIssue table that are pointing to a case that is no longer
     -- present in the Case table. These rows are orphaned and can be removed.
     SELECT *
     --DELETE
      FROM tblCaseIssue
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from the CaseProblem table that are pointing to a case that is no longer
     -- present in the Case table. These rows are orphaned and can be removed.
     SELECT *
     --DELETE
      FROM tblCaseProblem
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from the RecordHistory table that are pointing to a case that is no longer
     -- present in the Case table. These rows are orphaned and can be removed.
     SELECT *
     --DELETE
      FROM tblRecordHistory
     WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)



-- CLEAN UP ROWS FROM THE CASE TABLE THAT MAY BE POINTING AT DATA IN OTHER TABLES THAT IS NO LONGER PRESENT
     -- Grab the rows from the Case table that have a ClientCode value are pointing to
     -- a Client row that is no longer present
     SELECT *
       FROM tblCase
      WHERE ClientCode NOT IN (SELECT ClientCode FROM tblClient)

     -- Grab the rows from the Case table that have a BillClientCode value that are pointing to
     -- a Client row that is no longer present. Update this value so that it is pointing nowhere
     -- (Set it to NULL)
     SELECT *
     --UPDATE tblCase SET BillClientCode=NULL
      FROM tblCase
     WHERE BillClientCode NOT IN (SELECT ClientCode FROM tblClient)

     -- Grab the rows from the Case table that have a DoctorCode of 0 (zero). Change this so that
     -- the DoctorCode is NULL.
     SELECT *
     --UPDATE tblCase SET DoctorCode=NULL
      FROM tblCase
     WHERE DoctorCode=0

     -- Grab the rows from the Case table that have a DoctorLocation of 0 (zero). Change this so that
     -- the DoctorLocation is NULL.
     SELECT *
     --UPDATE tblCase SET DoctorLocation=NULL
      FROM tblCase
     WHERE DoctorLocation=0

     -- Grab the rows from the Case table that have a DoctorCode that is no longer present in the
     -- Doctor table.
     SELECT *
       FROM tblCase
      WHERE DoctorCode NOT IN (SELECT DoctorCode FROM tblDoctor)

-- find client records that are assigned a company that is no longer in the company table
-- or those clients that do not have a company code assigned 
-- SELECT *
--   FROM tblClient
-- WHERE CompanyCode NOT IN (SELECT CompanyCode FROM tblCompany)
SELECT *
-- DELETE
  FROM tblClient
 WHERE CompanyCode NOT IN (SELECT CompanyCode FROM tblCompany WHERE CompanyCode IS NOT NULL)
    OR CompanyCode IS NULL
    OR LEN(RTRIM(LTRIM(CompanyCode))) = 0

-- Grab the rows from the RecordsObtainmentDetail table that are pointing to a RecordsObtainment
-- row that no longer exists. These items are orphaned and can be deleted.
SELECT *
--DELETE
 FROM tblRecordsObtainmentDetail
WHERE RecordsID NOT IN (SELECT RecordsID FROM tblRecordsObtainment)

-- uncomment these queries for additional data checks on tblAcctHeader 
--SELECT * FROM tblAcctHeader WHERE CompanyCode NOT IN (SELECT CompanyCode FROM tblCompany)
--SELECT * FROM tblAcctHeader WHERE ClientCode NOT IN (SELECT ClientCode FROM tblClient)
--SELECT * FROM tblAcctHeader WHERE DrOpCode NOT IN (SELECT DoctorCode FROM tblDoctor)

-- CLEANUP/QUERY TABLES THAT ARE POINTING BACK INTO THE CASE TABLE. WILL HELP IDENTIFY ITEMS
-- WHERE THE CASE IS NO LONGER PRESENT.
     -- Grab the rows from DoctorCheckRequest that are pointing to a non-existent case record.
     SELECT * FROM tblDoctorCheckRequest WHERE CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)
     -- Grab the rows from AcctingTrans that are pointing to a non-existent case record.
     SELECT * FROM tblAcctingTrans AS AT WHERE AT.CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)
     -- Grab the rows from AcctHeader that are pointing to a non-existent case record.
     SELECT * FROM tblAcctHeader AS AH WHERE AH.CaseNbr NOT IN (SELECT CaseNbr FROM tblCase)

-- Grab the rows from the Examinee table that have a chartNbr value that is no longer in the case table
--SELECT *
----DELETE
-- FROM tblExaminee
-- WHERE ChartNbr NOT IN (SELECT ISNULL(ChartNbr,0) FROM tblCase)

-- CLEANUP/QUERY TABLES THAT ARE RELATED TO DOCTOR TYPE OF INFORMATION
     -- Grab the rows from the WebUser table that are pointing to one or more non-existent rows from
     -- the following tables: Client, Doctor, CCAddress
     SELECT *
       FROM tblWebUser AS WU
      WHERE (WU.UserType='CL' AND WU.IMECentricCode NOT IN (SELECT ClientCode FROM tblClient))
         OR (WU.UserType='DR' AND WU.IMECentricCode NOT IN (SELECT DoctorCode FROM tblDoctor))
         OR (WU.UserType='OP' AND WU.IMECentricCode NOT IN (SELECT DoctorCode FROM tblDoctor))
         OR (WU.UserType='AT' AND WU.IMECentricCode NOT IN (SELECT ccCode FROM tblCCAddress))

     -- Grab the rows from the DrDoNotUse table that are pointing to one or more non-existent rows
     -- from the following tables: Doctor, Client, Company. These items are orphaned and can
     -- be deleted.
     SELECT *
     --DELETE
      FROM tblDrDoNotUse
     WHERE DoctorCode NOT IN (SELECT DoctorCode FROM tblDoctor)
        OR (Type='CL' AND Code NOT IN (SELECT ClientCode FROM tblClient))
        OR (Type='CO' AND Code NOT IN (SELECT CompanyCode FROM tblCompany))

     -- Grab the rows from the DoctorSchedule table that are pointing to one or more non-existent
     -- rows from the following tables: Doctor, Location. These items are orphaned and can
     -- be deleted.
     SELECT *
     --DELETE
      FROM tblDoctorSchedule
     WHERE DoctorCode NOT IN (SELECT DoctorCode FROM tblDoctor)
        OR LocationCode NOT IN (SELECT LocationCode FROM tblLocation)

     -- Grab the rows from the DoctorOffice table that are pointing to one or more non-existent
     -- rows from the followin tables: Doctor, Office. These items are orphaned and can
     -- be deleted.
     SELECT *
     --DELETE
      FROM tblDoctorOffice
     WHERE DoctorCode NOT IN (SELECT DoctorCode FROM tblDoctor)
        OR OfficeCode NOT IN (SELECT OfficeCode FROM tblOffice)

     -- Grab rows from the DoctorSchedule table have a case nubmer 1 but that case number does
     -- not exist in the Case table. the DoctorSchedule case number should be set to NULL
     -- since the data is out of sync.
     SELECT *
     --UPDATE DS SET CaseNbr1=NULL, CaseNbr1desc=NULL
      FROM tblDoctorSchedule AS DS
               LEFT OUTER JOIN tblCase AS C1 ON DS.CaseNbr1=C1.CaseNbr
     WHERE (DS.CaseNbr1 IS NOT NULL AND C1.CaseNbr IS NULL)

     -- Grab the rows from the DoctorSchedule table that have a case number 2 but that case number does
     -- not exist in the Case table. The DoctorSchedule case number should be set to NULL
     -- since the data is out of sync.
     SELECT *
     --UPDATE DS SET CaseNbr2=NULL, CaseNbr2desc=NULL
      FROM tblDoctorSchedule AS DS
               LEFT OUTER JOIN tblCase AS C2 ON DS.CaseNbr2=C2.CaseNbr
     WHERE (DS.CaseNbr2 IS NOT NULL AND C2.CaseNbr IS NULL)

     -- Grab the rows from the DoctorSchedule table that have a case number 3 but that case number
     -- does not exist in the Case table. The DoctorSchedule case number should be set to NULL
     -- since the data is out of sync.
     SELECT *
     --UPDATE DS SET CaseNbr3=NULL, CaseNbr3desc=NULL
      FROM tblDoctorSchedule AS DS
               LEFT OUTER JOIN tblCase AS C3 ON DS.CaseNbr3=C3.CaseNbr
     WHERE (DS.CaseNbr3 IS NOT NULL AND C3.CaseNbr IS NULL)

-- CLEAN/QUERY DATA THAT IS IN THE PUBLISHONWEB TABLE
     -- Grab the rows from the PublishOnWeb table of user type "CL" (client) but where the
     -- specified user code value is not listed in the ClientCode table. These rows are linnked
     -- to non-existent data and should be removed.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE UserType='CL'
        AND UserCode NOT IN (SELECT ClientCode FROM tblClient)
        AND UserCode<>0

     -- Grab the rows from the PublishOnWeb table of user type "DR" (doctor) but where the
     -- specified user code value is not listed in the DoctorCode table. These rows are linked
     -- to non-existent data and should be removed.
     SELECT *
     --DELETE
      FROM tblPublishOnWeb
     WHERE UserType='DR'
       AND UserCode NOT IN (SELECT DoctorCode FROM tblDoctor)
       AND UserCode<>0

     -- Grab the rows from the PublishOnWeb table of user type "AT" (Attorney) but where the
     -- specified user code value is not listed in the CCAddress table. These rows are linked
     -- to non-existent data and should be removed.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE UserType='AT'
        AND UserCode NOT IN (SELECT ccCode FROM tblCCAddress)
        AND UserCode<>0

     -- Grab the rows from the PublishOnWeb table that have been tagged with a value of
     -- "tblTmpCaseHistory" for the TableType column. By their very nature they are temporary
     -- and can be removed.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblTmpCaseHistory'

     -- Grab the rows from the PublishOnWeb table that are from the Case table but we are not
     -- able to match it back to the original row in the Case table. Since the data cannot be
     -- matched to where it came from it can be deleted.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblCase'
        AND TableKey NOT IN (SELECT CaseNbr FROM tblCase)

     -- Grab the rows from the PublishOnWeb table that are from the CaseDocuments table but we
     -- are not able to match it back to the original row in the CaseDocument table. Since the
     -- data cannot be matched to where it came from it can be deleted.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblCaseDocuments'
        AND TableKey NOT IN (SELECT SeqNo FROM tblCaseDocuments)

     -- Grab the rows from the PublishOnWeb table that are from the CaseHistory table but we are
     -- not able to match it back to the original row in the CaseHistory table. Since the data
     -- cannot be matched to where it came from it can be deleted.
     SELECT *
     --DELETE
      FROM tblPublishOnWeb
      WHERE TableType='tblCaseHistory'
        AND TableKey NOT IN (SELECT ID FROM tblCaseHistory)

     -- Grab the rows from the PublishOnWeb table that are from the WebEventsOverride table but we
     -- are not able to match it back to the original row in the WebEventsOverride table. Since the
     -- data cannot be matched to where it came from it can be deleted.
     SELECT *
     --DELETE
       FROM tblPublishOnWeb
      WHERE TableType='tblWebEventsOverride'
        AND TableKey NOT IN (SELECT SeqNo FROM tblWebEventsOverride)
