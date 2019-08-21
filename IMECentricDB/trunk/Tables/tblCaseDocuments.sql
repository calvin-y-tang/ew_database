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
    [FirstViewedBy] VARCHAR(50) NULL, 
    [FirstViewedDate] SMALLDATETIME NULL, 
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

