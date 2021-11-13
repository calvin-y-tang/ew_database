CREATE VIEW [dbo].[vwInvoiceAttachmentGuidance]
AS
     -- Attachment Type 06 for CPT:98770-98774
          SELECT CaseNbr, '06 - Initial Assessment' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '98770' AND Detail.CPTCode <= '98774'

     UNION

     -- Attachment Type 09 for CPT: 99081 and CPT:99214-99215
          SELECT CaseNbr, '09 - Progress Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode IN ('99081', '99214', '99215')
     UNION

     -- Attachment Type DG for CPT:95804-95830
          SELECT CaseNbr, 'DG - Description for Code Not Available' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '95804' AND Detail.CPTCode <= '95830'

     UNION

     -- Attachment Type J1 for CPT:99201-99205
          SELECT CaseNbr, 'J1 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99201' AND Detail.CPTCode <= '99205'

     UNION

     -- Attachment Type J2 for ALL BR codes, CPT:97545, CPT:97546, CPT:99080 
          SELECT CaseNbr, 'J2 - Doctors First Report (5021)' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (Detail.CPTCode IN ('97545', '97546', '99080') OR Detail.CPTCode LIKE '%BR')

     UNION

     -- Attachment Type J7 for CPT:99241-99245
          SELECT CaseNbr, 'J7 - Consultation Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '99241' AND Detail.CPTCode <= '99245'

     UNION

     -- Attachment Type LA for CPT:80047-89398 CPT:G0430-G0434
          SELECT CaseNbr, 'LA - Laboratory Results' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '80047' AND Detail.CPTCode <= '89398') 
                    OR 
                    (Detail.CPTCode >= 'G0430' AND Detail.CPTCode <= 'G0434') 
                    )

     UNION

     -- Attachment Type OB for CPT:10021-69999
          SELECT CaseNbr, 'OB - Operative Note' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '10021' AND Detail.CPTCode <= '69999'

     UNION

     -- Attachment Type OZ for CPT:00100-01999
          SELECT CaseNbr, 'OZ - Support Data for Claim' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '00100' AND Detail.CPTCode <= '01999'

     UNION

     -- Attachment Type RR for CPT:70000-79999
          SELECT CaseNbr, 'RR - Radiology Reports' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND Detail.CPTCode >= '70000' AND Detail.CPTCode <= '79999'

     UNION

     -- Attachment Type RT for CPT:95831-95852, CPT: 96100�96117
          SELECT CaseNbr, 'RT - Report of Tests and Analysis Report' AS AttachDesc
               FROM tblAcctHeader AS Header
                    INNER JOIN tblAcctDetail AS Detail ON 
                         Detail.HeaderID = Header.HeaderID
                         
               WHERE Header.DocumentType = 'IN'
               AND (
                    (Detail.CPTCode >= '95831' AND Detail.CPTCode <= '95852') 
                    OR 
                    (Detail.CPTCode >= '96100' AND Detail.CPTCode <= '96117') 
                    )

