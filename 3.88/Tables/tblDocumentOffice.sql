CREATE TABLE [dbo].[tblDocumentOffice] (
    [DocumentID]	INT          NOT NULL,
    [OfficeCode]	INT          NOT NULL,
    [DateAdded]		DATETIME     NULL,
    [UserIDAdded]	VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDocumentOffice] PRIMARY KEY CLUSTERED ([DocumentID] ASC, [OfficeCode] ASC)
);

