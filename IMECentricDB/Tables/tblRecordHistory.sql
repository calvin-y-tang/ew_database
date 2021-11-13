CREATE TABLE [dbo].[tblRecordHistory] (
    [MedRecID]     INT             IDENTITY (1, 1) NOT NULL,
    [CaseNbr]      INT             NOT NULL,
    [ActionID]     INT             NOT NULL,
    [Type]         VARCHAR (50)    NULL,
    [Inches]       DECIMAL (18, 2) CONSTRAINT [DF_tblRecordHistory_Inches] DEFAULT ((0)) NULL,
    [Pages]        INT             NULL,
    [Notes]        TEXT            NULL,
    [DateAdded]    DATETIME        NULL,
    [UserIDAdded]  VARCHAR (50)    NULL,
    [DateEdited]   DATETIME        NULL,
    [UserIDEdited] VARCHAR (50)    NULL,
    [OnINDocument] BIT             CONSTRAINT [DF_tblRecordHistory_OnINDocument] DEFAULT ((0)) NULL,
    [OnVODocument] BIT             CONSTRAINT [DF_tblRecordHistory_OnVODocument] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblRecordHistory] PRIMARY KEY CLUSTERED ([MedRecID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblRecordHistory_CaseNbr]
    ON [dbo].[tblRecordHistory]([CaseNbr] ASC);

