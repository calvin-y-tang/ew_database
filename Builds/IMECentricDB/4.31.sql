

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblIntegrationBatchDetail]...';


GO
ALTER TABLE [dbo].[tblIntegrationBatchDetail] DROP COLUMN [BatchStatus], COLUMN [DateProcessed];


GO
ALTER TABLE [dbo].[tblIntegrationBatchDetail] ALTER COLUMN [ProcessName] VARCHAR (25) NULL;

ALTER TABLE [dbo].[tblIntegrationBatchDetail] ALTER COLUMN [UserIDAdded] VARCHAR (15) NULL;


GO
ALTER TABLE [dbo].[tblIntegrationBatchDetail]
    ADD [TableType] VARCHAR (50)  NULL,
        [TableKey]  INT           NOT NULL,
        [Param]     VARCHAR (200) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblIntegrationBatchHeader]...';


GO
ALTER TABLE [dbo].[tblIntegrationBatchHeader] DROP COLUMN [Param], COLUMN [TableKey], COLUMN [TableType];


GO
ALTER TABLE [dbo].[tblIntegrationBatchHeader] ALTER COLUMN [ProcessName] VARCHAR (25) NULL;

ALTER TABLE [dbo].[tblIntegrationBatchHeader] ALTER COLUMN [UserIDAdded] VARCHAR (15) NULL;


GO
ALTER TABLE [dbo].[tblIntegrationBatchHeader]
    ADD [BatchStatus]   VARCHAR (15) NULL,
        [DateProcessed] DATETIME     NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblDoctorSpecialty_AfterInsert_TRG]...';


GO

CREATE TRIGGER tblDoctorSpecialty_AfterInsert_TRG 
  ON tblDoctorSpecialty
AFTER INSERT
AS
BEGIN     
    -- DEV NOTE: need to ensure that items that are added to this table
    --      are also present in Master.EWDoctorSpecialty. Only applies if 
    --      when Doctor has an EWDoctorID and that specialty is not present
    --      in Master.EWDoctorSpecialty

    DECLARE @cnt INT

    SET @cnt = (SELECT COUNT(*) 
                  FROM Inserted AS I
                         INNER JOIN tblDoctor AS D ON D.DoctorCode = I.DoctorCode
                 WHERE D.EWDoctorID IS NOT NULL)

    IF @cnt > 0 
    BEGIN
         INSERT INTO IMECentricMaster.dbo.EWDoctorSpecialty (EWDoctorID, EWSpecialtyID, UserIDAdded, DateAdded)
             SELECT D.EWDoctorID, Sp.EWSpecialtyID, I.UserIDAdded, I.DateAdded 
               FROM Inserted AS I
                       INNER JOIN tblDoctor AS D ON D.DoctorCode = I.DoctorCode
                       INNER JOIN tblSpecialty AS Sp ON Sp.SpecialtyCode = I.SpecialtyCode
                       LEFT OUTER JOIN IMECentricMaster.dbo.EWDoctorSpecialty AS EWDrSp ON EWDrSp.EWSpecialtyID = Sp.EWSpecialtyID 
                                                                                       AND EWDrSp.EWDoctorID = D.EWDoctorID
              WHERE D.EWDoctorID IS NOT NULL
                AND EWDrSp.EWDoctorID IS NULL
     END
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblDoctorSpecialty_BeforeDelete_TRG]...';


GO

CREATE TRIGGER tblDoctorSpecialty_BeforeDelete_TRG 
  ON tblDoctorSpecialty
FOR DELETE
AS
BEGIN
    -- DEV NOTE: need to ensure that the items being deleted are also deleted
    --      from Master.EWDoctorSpecialty

    DECLARE @cnt INT

    SET @cnt = (SELECT COUNT(*) 
                  FROM Deleted AS D
                         INNER JOIN tblDoctor AS Dr ON D.DoctorCode = D.DoctorCode
                 WHERE Dr.EWDoctorID IS NOT NULL)

    IF @cnt > 0 
    BEGIN

         DELETE EWDrSp
           FROM IMECentricMaster.dbo.EWDoctorSpecialty AS EWDrSp
                   INNER JOIN tblSpecialty AS Sp ON Sp.EWSpecialtyID = EWDrSp.EWSpecialtyID
                   INNER JOIN tblDoctor AS Dr ON Dr.EWDoctorID = EWDrSp.EWDoctorID
                   INNER JOIN Deleted AS D ON D.SpecialtyCode = Sp.SpecialtyCode 
                                          AND D.DoctorCode = Dr.DoctorCode
     END
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
-- Sprint 108



