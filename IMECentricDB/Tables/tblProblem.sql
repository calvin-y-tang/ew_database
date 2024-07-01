CREATE TABLE [dbo].[tblProblem] (
    [ProblemCode]           INT            IDENTITY (1, 1) NOT NULL,
    [Description]           VARCHAR (50)   NULL,
    [Status]                VARCHAR (10)   CONSTRAINT [DF_tblproblem_status] DEFAULT ('Active') NULL,
    [DateAdded]             DATETIME       NULL,
    [UserIDAdded]           VARCHAR (15)   NULL,
    [DateEdited]            DATETIME       NULL,
    [UserIDEdited]          VARCHAR (15)   NULL,
    [PublishOnWeb]          BIT            NULL,
    [WebSynchDate]          DATETIME       NULL,
    [WebID]                 INT            NULL,
    [Description_Encrypted] VARBINARY(MAX) NULL,
    CONSTRAINT [PK_tblProblem] PRIMARY KEY CLUSTERED ([ProblemCode] ASC)
);

GO
CREATE TRIGGER [dbo].[tblProblem_AfterInsert_TRG]
   ON  [dbo].[tblProblem]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE P
        SET P.Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description)
            -- I.Description = NULL
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode

END

GO
CREATE TRIGGER [dbo].[tblProblem_AfterUpdate_TRG]
   ON  [dbo].[tblProblem]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE P
        SET P.Description_Encrypted = IIF(I.Description = D.Description,
                                  P.Description_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description))
            -- P.Description = NULL
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode
        WHERE I.Description <> D.Description 
           OR I.Description IS NULL 
           OR D.Description IS NULL
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END
