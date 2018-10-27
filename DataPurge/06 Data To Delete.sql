-- **********************************************************************************************************
--
--   Description:
--        Scirpt will process a number of tables that have data that we know we will have to delete.
--        The individual data item IDs (PKEYs) from the various tables are loaded into the
--        tmpDelete table. At this time MOST ITEMS are being marked for potential deletion
--        by being added to the tmpDelete table. There may be instances where an item is initially
--        added to delete list but later removed (marked to be kept) from the table.
--
--        THE ONE EXCEPTION TO THE 'NOT BEING DELETED' STATEMENT IS TBLOFFICE. THE ITEMS IN THAT
--        TABLE THAT ARE MARKED FOR DELETION ARE DELETED AT THE END OF THIS SCRIPT.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- grab all the cases that are attached to an office that has been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT 'Case', CaseNbr, 1
       FROM tblCase
      WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

-- grab all the AcctHeader rows that are invoices that are attached to a case that has been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT 'Invoice', DocumentNbr, 1
       FROM tblAcctHeader
      WHERE DocumentType='IN'
        AND CaseNbr IN (SELECT ID FROM getID('Case'))

-- grab all the AcctHeader rows that are vouchers that are attached to a case that has been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT 'Voucher', DocumentNbr, 1
       FROM tblAcctHeader
      WHERE DocumentType='VO'
        AND CaseNbr IN (SELECT ID FROM getID('Case'))

-- grab all the examinee rows that are attached to cases that have been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT DISTINCT 'Examinee', EE.ChartNbr, 1
       FROM tblExaminee AS EE
               INNER JOIN tblCase AS C ON C.ChartNbr = EE.ChartNbr
      WHERE C.CaseNbr IN (SELECT ID FROM getID('Case'))

-- grab the doctors that meet following conditions and mark them for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     -- doctors attached to a case where the office on the case has been marked for deletion
     -- ??? TODO: why could you not just grab the doctor codes for cases that are marked for deletion?
     --           the other selects that are "UNIONED" use the case marked for deletion method. Why???
     SELECT DISTINCT 'Doctor', DoctorCode, 1
       FROM tblCase
      WHERE DoctorCode IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- doctors attached to case appt or case appt panel where the case has been marked for deletion
     SELECT DISTINCT 'Doctor', ISNULL(CAP.DoctorCode, CA.DoctorCode), 1
       FROM tblCaseAppt AS CA
               LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = CA.CaseApptID
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))
     UNION
     -- doctors attached to a case panel where the case has been marked for deletion
     SELECT DISTINCT 'Doctor', CP.DoctorCode, 1
       FROM tblCasePanel AS CP
               INNER JOIN tblCase AS C ON C.PanelNbr = CP.PanelNbr
      WHERE CaseNbr IN (SELECT ID FROM getID('Case'))

-- grab the clients that meet following conditions and mark them for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     -- clients (ClientCode) attached to cases where the office on the case has been marked for deletion
     -- ??? TODO: why could you not just grab the client codes for cases that are marked for deletion?
     SELECT DISTINCT 'Client', ClientCode, 1
       FROM tblCase
      WHERE ClientCode IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- clients (BillClientCode) attached to cases where the office on the case has been marked for deletion
     -- ??? TODO: why could you not just grab the client codes for cases that are marked for deletion?
     SELECT DISTINCT 'Client', BillClientCode, 1
       FROM tblCase
      WHERE BillClientCode IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))

-- grab all the company rows that are attached to clients that have been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT DISTINCT 'Company', CompanyCode, 1
       FROM tblClient
      WHERE ClientCode IN (SELECT ID FROM getID('Client'))

-- grab all the attorney codes that are attached to the following items that have been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     -- attorney codes(Plaintiff) that are attached to cases that have an office that has been marked for deletion
     -- ??? TODO: why could you not just grab the attorney codes for cases that are marked for deletion?
     SELECT DISTINCT 'CC', PlaintiffAttorneyCode, 1
       FROM tblCase
      WHERE PlaintiffAttorneyCode IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- attorney codes (Defense) that are attached to cases that have an office that has been marked for deletion
     -- ??? TODO: why could you not just grab the attorney codes for cases that are marked for deletion?
     SELECT DISTINCT 'CC', DefenseAttorneyCode, 1
       FROM tblCase
      WHERE DefenseAttorneyCode IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- attorney codes (Paralegal) that are attached to cases that have an office that has been marked for deletion
     -- ??? TODO: why could you not just grab the attorney codes for cases that are marked for deletion?
     SELECT DISTINCT 'CC', DefParaLegal, 1
       FROM tblCase
      WHERE DefParaLegal IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- attorney codes that are attached to examinees that have been marked for deletion
     SELECT DISTINCT 'CC', ccCode, 1
       FROM tblExamineeCC
       WHERE ChartNbr IN (SELECT ID FROM getID('Examinee'))

-- grab all location codes that are attached to the following items that have been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     -- case doctor location codes that are attached to cases where the office has been marked for deletion
     -- ??? TODO: why could you not just grab the location codes for cases that are marked for deletion?
     SELECT DISTINCT 'Location', DoctorLocation, 1
       FROM tblCase
      WHERE DoctorLocation IS NOT NULL
        AND OfficeCode IN (SELECT ID FROM getID('Office'))
     UNION
     -- Doctor location codes that are attached to doctors that have been marked for deletion
     SELECT DISTINCT 'Location', LocationCode, 1
       FROM tblDoctorLocation
      WHERE DoctorCode IN (SELECT ID FROM getID('Doctor'))
     UNION
     -- case appt location code attached to a case that has been marked for deletion
     SELECT DISTINCT 'Location', LocationCode, 1
       FROM tblCaseAppt
      WHERE LocationCode IS NOT NULL
        AND CaseNbr IN (SELECT ID FROM getID('Case'))

-- grab web users that are attached to either client, doctor or attorney that have been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT DISTINCT 'WebUser', WU.WebUserID, 1
       FROM tblWebUser AS WU
      WHERE (WU.UserType='CL' AND WU.IMECentricCode IN (SELECT ID FROM getID('Client')))
         OR (WU.UserType='DR' AND WU.IMECentricCode IN (SELECT ID FROM getID('Doctor')))
         OR (WU.UserType='AT' AND WU.IMECentricCode IN (SELECT ID FROM getID('CC')))

-- grab all users that are attached to an office that has been marked for deletion
INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     SELECT DISTINCT 'User', U.SeqNo, 1
      FROM tblUser AS U
               INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
     WHERE OfficeCode IN (SELECT ID FROM getID('Office'))

-- >>>> DELETE OFFICES THAT HAVE BEEN MARKED FOR DELETION FROM TBLOFFICE <<<<
DELETE FROM tblOffice WHERE OfficeCode IN (SELECT ID FROM getID('Office'))
