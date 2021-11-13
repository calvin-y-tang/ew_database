CREATE TABLE [dbo].[tblDPSBundleCaseDocument] (
    [DPSBundleID] INT          NOT NULL,
    [CaseDocID]   INT          NOT NULL,
    [Filename]    VARCHAR (40) NULL, 
    CONSTRAINT [PK_tblDPSBundleCaseDocument] PRIMARY KEY ([DPSBundleID], [CaseDocID])
);





