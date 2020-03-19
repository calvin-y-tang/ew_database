CREATE TABLE [dbo].[tblDPSBundleCaseDocument] (
    [DPSBundleID] INT          NOT NULL,
    [CaseDocID]   INT          NOT NULL,
    [Filename]    VARCHAR (100) NULL, 
    CONSTRAINT [PK_tblDPSBundleCaseDocument] PRIMARY KEY ([DPSBundleID], [CaseDocID])
);





