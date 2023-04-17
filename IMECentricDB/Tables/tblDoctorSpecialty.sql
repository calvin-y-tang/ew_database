CREATE TABLE [dbo].[tblDoctorSpecialty] (
    [SpecialtyCode]             VARCHAR (500) NOT NULL,
    [DateAdded]                 DATETIME      NULL,
    [UserIDAdded]               VARCHAR (50)  NULL,
    [DateEdited]                DATETIME      NULL,
    [UserIDEdited]              VARCHAR (50)  NULL,
    [DoctorCode]                INT           NOT NULL,
    [MasterReviewerSpecialtyID] INT           NULL,
    CONSTRAINT [PK_tblDoctorSpecialty] PRIMARY KEY CLUSTERED ([SpecialtyCode] ASC, [DoctorCode] ASC)
);
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

CREATE NONCLUSTERED INDEX [IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]
    ON [dbo].[tblDoctorSpecialty]([DoctorCode] ASC, [SpecialtyCode] ASC);

