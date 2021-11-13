CREATE TABLE [dbo].[tblOfficeDPSSortModel] (
    [DPSOfficeSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [Officecode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModelID]          INT          NOT NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblOfficeDPSSortModel] PRIMARY KEY CLUSTERED ([DPSOfficeSortModelID] ASC)
);

