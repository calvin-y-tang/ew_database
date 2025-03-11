/*
     Background: 
          - We have been getting many reports of DoctorSpecialties goin missing from IMECentricEW in production
          - Use the data in tblDoctorSpecialty from Test IMECentricEW_QAUAT to restore missing items
          - based on DateAdded in tblDoctorSpecialty the DB was restored from a production IMECentricEW back in early 
            November 2024.
          - there is a chance that we may end up restoring some items that are controlled by CRN that 
            should not be restored.
          - Items that are restored will not be linked to CRN. But when a CRN data feed is processed for
            a doctor and there is a doctor specialty that is part of the CRN data feed our logic
            we update that item so that it is linked to CRN; therefore, if it is then removed from
            the CRN doctor profile, it will also be removed from the IMEC doctor profile.
*/

-- 1. create IMPORT Doctor Specialties file from dev6 IMECentricEW_QAUAT
--        - right click DB >> Tasks >> Generate Script >> Save to File DoctorSpecialties-Restore.slq
--          includes schema to create temp table for import
--        - edit generated file and replace tblDoctorSpecialty with _tmp_Restore_DoctorSpecialty

-- 2. create IMPORT of basic Doctor data to verify DoctorCodes are in sync for data to restore
--        - run query to create a temp table of doctor data that has just the columns we need for verification
--        - follow same steps in #1 to create a SQL import script

-- 3. execute the generated (and cleaned up) IMPORT script for Doctor and DoctorSpecialties
--        - just open it in a SQL query tab, ensure proper DB is selected and execute
--             - DoctorSpecialties-Restore.sql
--             - DoctorVerify.sql

-- **********************************************************************************************************************************

-- 4. capture the list of missing items to a temporary table for future reference
SELECT 
     resDS.SpecialtyCode AS RestoreSpecialtyCode, resDS.DoctorCode AS RestoreDoctorCode, d.EWDoctorID as RestoreEWDoctorID, s.EWSpecialtyID as RestoreEWSpecialtyID,
     resDS.MasterReviewerSpecialtyID AS RestoreMasterReviewerSpecialtyID, resDS.DateAdded AS RestoreDateAdded, 
     ds.SpecialtyCode AS OrigSpecialtyCode, ds.DoctorCode AS OrigDoctorCode, ds.MasterReviewerSpecialtyID AS OrigMasterReviewerSpecialtyID, ds.DateAdded AS OrigDateAdded
  INTO _tmp_DoctorSpecialty_MissingInProd
  FROM _tmp_Restore_DoctorSpecialty AS resDS 
               LEFT OUTER JOIN tblDoctor AS d 
                 ON d.DoctorCode = resDS.DoctorCode
               LEFT OUTER JOIN tblDoctorSpecialty AS ds
			  ON resDS.DoctorCode = ds.DoctorCode 
			 AND resDS.SpecialtyCode = ds.SpecialtyCode
               LEFT OUTER JOIN tblSpecialty AS s
                 ON s.SpecialtyCode = resDS.SpecialtyCode
WHERE ds.SpecialtyCode IS NULL

-- **********************************************************************************************************************************

/*
-- 5. Some data validation checks - Manul checks done after restore data is loaded into temp tables 
--    but before the script is applied.

-- verify doctorcodes from backup against current DB to verify that they are in "sync"
--   for ex: if DoctorCode = 1 is for John Smith in the backup it better be for John Smith
--           in the active production db

     select  d.DoctorCode, d.EWParentDocID,  d.FirstName, d.LastName, '' as spacer,
          dv.DoctorCode, dv.EWParentDocID,  dv.FirstName, dv.LastName
     from tblDoctor AS d
               left outer join _tmpDoctorVerify as dv on dv.DoctorCode = d.DoctorCode
     where d.EWParentDocID <> dv.EWParentDocID
     or d.FirstName <> dv.FirstName 
     or d.LastName <> dv.LastName

-- some data validation to ensure that data is properly lined up....
     -- show counts of missing specialties
     select distinct s.ControlledByIMEC, s.SpecialtyCode, count(*) as cnt 
     from tblDoctorSpecialty as tds
               left outer join [dbo].[_tmp_Restore_DoctorSpecialty] as pds on 
                    pds.specialtycode = tds.SpecialtyCode and 
                    pds.doctorcode = tds.DoctorCode
               left outer join tblSpecialty as s on s.specialtycode = tds.SpecialtyCode
     where pds.specialtycode is null 
     group by s.ControlledByIMEC, s.SpecialtyCode
     order by 2


-- DoctorSpecialties that are linked to CRN but the specialty is controlled by IMEC
     select distinct s.*
     from tblDoctorSpecialty as ds
               inner join tblSpecialty as s on s.SpecialtyCode = ds.SpecialtyCode
     where ds.MasterReviewerSpecialtyID is not null
     and s.ControlledByIMEC = 1

-- are they in the mapping table? 
     select * 
     from imecentricmaster.dbo.ISMapping 
     where MappingName = 'specialty' 
     and dstDescrip in (select distinct ds.SpecialtyCode 
                         from tblDoctorSpecialty as ds
                                   inner join tblSpecialty as s on s.SpecialtyCode = ds.SpecialtyCode
                         where ds.MasterReviewerSpecialtyID is not null
                         and s.ControlledByIMEC = 1)

*/
-- **********************************************************************************************************************************

USE IMECentricEW

     -- 6. create a backup copy of current tblDoctorSpecialty >>> (to undo if needed)
     SELECT * 
     INTO _tmp_JP_DoctorSpecialty_02262025
     FROM tblDoctorSpecialty

-- **********************************************************************************************************************************

     -- 7. create a backup copy of current IMECentricMaster.EWDoctorSpecialty >>> (to have a restore point)
     SELECT * 
     INTO IMECentricMaster.dbo._tmp_JP_DoctorSpecialty_022262025
     FROM IMECentricMaster.dbo.EWDoctorSpecialty

-- **********************************************************************************************************************************

     -- 8. add missing item to tblDoctorSpecialty
BEGIN TRY
     BEGIN TRANSACTION IMEC14874
     INSERT INTO tblDoctorSpecialty(SpecialtyCode, DoctorCode, MasterReviewerSpecialtyID, DateEdited, UserIDEdited, 
                                    DateAdded, UserIDAdded, DoNotUse, CertificationStatus, CertificationStatusID, ExpirationDate)
          SELECT 
               resDS.SpecialtyCode, resDS.DoctorCode, NULL, GETDATE(), 'RestoreData', 
               resDS.DateAdded, LEFT(resDS.UserIDAdded, 12), resDS.DoNotUse, resDS.CertificationStatus, resDS.CertificationStatusID, resDS.ExpirationDate
            FROM _tmp_Restore_DoctorSpecialty AS resDS
                    LEFT OUTER JOIN  tblDoctorSpecialty AS ds
                        ON ds.DoctorCode = resDS.DoctorCode
                        AND ds.SpecialtyCode = resDS.SpecialtyCode 
          WHERE ds.SpecialtyCode IS NULL
     COMMIT TRANSACTION IMEC14874
END TRY
BEGIN CATCH
     DECLARE @RN VARCHAR(2) = CHAR(13)+CHAR(10)
     PRINT ERROR_MESSAGE() + @RN
     PRINT 'On line: ' + convert(nvarchar(4), ERROR_LINE()) + @RN
     PRINT 'Rolling back transaction.'
     ROLLBACK TRANSACTION IMEC14874
END CATCH


-- **********************************************************************************************************************************

/*
     -- RESET 
     DROP TABLE _tmpDoctorVerify
     DROP TABLE _tmp_Restore_DoctorSpecialty
     
     -- temp tables that are used as data backups
     DROP TABLE _tmp_DoctorSpecialty_MissingInProd
     DROP TABLE _tmp_JP_DoctorSpecialty_02262025
     DROP TABLE IMECentricMaster.dbo._tmp_JP_DoctorSpecialty_022262025

     -- SELECT * FROM tblDoctorSpecialty where UserIDEdited = 'RestoreData'
     DELETE FROM tblDoctorSpecialty where UserIDEdited = 'RestoreData'
*/

-- **********************************************************************************************************************************



