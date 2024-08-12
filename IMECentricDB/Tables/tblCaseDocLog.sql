CREATE TABLE [dbo].[tblCaseDocLog]
(
     [CaseDocLogID]     INT           IDENTITY (1, 1) NOT NULL,
     [ProcessID]        VARCHAR(50)   NULL,
     [ProcessName]      VARCHAR(32)   NULL,
     [EntityType]       VARCHAR(2)    NULL, 
     [EntityID]         INT           NULL, 
     [CaseNbr]          INT           NULL,
     [DocumentSeqNo]    INT           NULL, 
     [OrigDocFilePath]  VARCHAR(256)  NULL, 
     [NewDocFilePath]   VARCHAR(256)  NULL, 
     [OtherInfo]        VARCHAR(512)  NULL,
     CONSTRAINT [PK_tblCaseDocLog] PRIMARY KEY CLUSTERED ([CaseDocLogID] ASC)
);

GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocLog_DocSeqNoEntity]
    ON [dbo].[tblCaseDocLog]([DocumentSeqNo] ASC, [EntityType] ASC, [EntityID] ASC);

