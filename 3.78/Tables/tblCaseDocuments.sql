CREATE TABLE [dbo].[tblCaseDocuments] (
    [CaseNbr]        INT              NOT NULL,
    [Document]       VARCHAR (20)     NOT NULL,
    [Type]           VARCHAR (20)     NULL,
    [ReportType]     VARCHAR (20)     NULL,
    [Description]    VARCHAR (200)    NULL,
    [sFilename]      VARCHAR (200)    NULL,
    [DateAdded]      DATETIME         NOT NULL,
    [UserIDAdded]    VARCHAR (20)     NULL,
    [PublishOnWeb]   BIT              CONSTRAINT [DF_tblcasedocuments_publishonweb] DEFAULT (0) NULL,
    [WebSynchDate]   DATETIME         NULL,
    [DateEdited]     DATETIME         NULL,
    [UserIDEdited]   VARCHAR (30)     NULL,
    [SeqNo]          INT              IDENTITY (1, 1) NOT NULL,
    [WebGUID]        UNIQUEIDENTIFIER NULL,
    [PublishedTo]    VARCHAR (50)     NULL,
    [FileMoved]      BIT              CONSTRAINT [DF_tblCaseDocuments_FileMoved] DEFAULT ((0)) NOT NULL,
    [Source]         VARCHAR (15)     NULL,
    [FileSize]       BIGINT           NULL,
    [Pages]          INT              NULL,
    [Viewed]         BIT              CONSTRAINT [DF_tblCaseDocuments_Viewed] DEFAULT ((0)) NOT NULL,
    [FolderID]       INT              NULL,
    [SubFolder]      VARCHAR (32)     NULL,
    [CaseDocTypeID]  INT              NULL,
    [ReportApproved] BIT              NULL,
    [SharedDoc]      BIT              CONSTRAINT [DF_tblCaseDocuments_SharedDoc] DEFAULT ((0)) NOT NULL,
    [MasterCaseNbr]  INT              NULL,
    [FirstViewedOnWebBy] VARCHAR(100) NULL, 
    [FirstViewedOnWebDate] SMALLDATETIME NULL, 
    CONSTRAINT [PK_tblCaseDocuments] PRIMARY KEY CLUSTERED ([SeqNo] ASC)
);




GO 

CREATE TRIGGER tblCaseDocuments_AfterInsert_TRG
	ON tblCaseDocuments 
AFTER INSERT
AS 
BEGIN
	
	UPDATE tblCaseDocuments
	   SET tblCaseDocuments.MasterCaseNbr = tblCase.MasterCaseNbr	
	  FROM inserted 
			INNER JOIN tblCase ON tblCase.CaseNbr = inserted.CaseNbr 
	 WHERE tblCaseDocuments.SeqNo = inserted.SeqNo

	 -- create corresponding entry in tblOCRDocument 
      INSERT INTO tblOCRDocument 
          (CaseDocID, OCRStatusID, DateAdded, UserIDAdded, Source)
      SELECT NewDoc.SeqNo, 
             10, -- New
             GETDATE(), 
             NewDoc.UserIDAdded, 
             'InsertTrigger'
        FROM inserted AS NewDoc

END

GO

CREATE TRIGGER [dbo].[tblCaseDocuments_AfterUpdate_TRG]
	ON [dbo].[tblCaseDocuments] 
AFTER UPDATE
AS 
BEGIN
     -- DEV NOTE: the inserted table has "new" row (or updated data) while
     --   the deleted table has the "old" row (or original data). For now, 
     --   we want to do an insert in the OCRDoc table when a CaseDoc row 
	 --		has its CaseDocTypeID modified and it does not already exist 
	 --		in the OCRDoc table.

	 SET NOCOUNT OFF

     DECLARE @iCount AS INT
     DECLARE @caseDocID AS INT 
     DECLARE @newCaseDocID AS INT
     DECLARE @origCaseDocID AS INT 
     DECLARE @userID AS VARCHAR(20)

     DECLARE curCaseDoc CURSOR FOR
          SELECT ins.SeqNo, ins.CaseDocTypeID AS NewCaseDocID, del.CaseDocTypeID as OrigCaseDocID, ins.UserIDAdded
            FROM inserted AS ins
                      INNER JOIN deleted AS del ON del.SeqNo = ins.SeqNo
     OPEN curCaseDoc
     FETCH NEXT FROM curCaseDoc INTO @caseDocID, @newCaseDocID, @origCaseDocID, @userID
     WHILE @@FETCH_STATUS = 0
     BEGIN
          IF @newCaseDocID <> @origCaseDocID
          BEGIN
               IF (SELECT COUNT(*) FROM tblOCRDocument WHERE CaseDocID = @caseDocID) = 0
               BEGIN
                    INSERT INTO tblOCRDocument (CaseDocID, OCRStatusID, DateAdded, UserIDAdded, Source)
                                VALUES(@caseDocID, 10, GETDATE(), @userID, 'UpdateTrigger')
               END
          END
          FETCH NEXT FROM curCaseDoc INTO @caseDocID, @newCaseDocID, @origCaseDocID, @userID
     END
     CLOSE curCaseDoc
     DEALLOCATE curCaseDoc
END

GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_CaseNbr]
    ON [dbo].[tblCaseDocuments]([CaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_MasterCaseNbrType]
    ON [dbo].[tblCaseDocuments]([MasterCaseNbr] ASC, [Type] ASC)
    INCLUDE([CaseNbr], [Document], [Description], [sFilename], [DateAdded], [UserIDAdded], [PublishOnWeb], [DateEdited], [UserIDEdited], [SeqNo], [PublishedTo], [Source], [FileSize], [Pages], [FolderID], [SubFolder], [CaseDocTypeID], [SharedDoc]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_SourceDateAdded]
    ON [dbo].[tblCaseDocuments]([Source] ASC, [DateAdded] ASC)
    INCLUDE([CaseNbr], [Description], [UserIDAdded], [CaseDocTypeID]);

