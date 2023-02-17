CREATE TABLE [dbo].[tblCasePanel] (
    [PanelNbr]      INT           NOT NULL,
    [DoctorCode]    INT           NOT NULL,
    [PanelNote]     TEXT          NULL,
    [SpecialtyCode] VARCHAR (500) NULL,
    [SchedCode]     INT           NULL,
    [DateAdded]     DATETIME      NULL,
    [UserIDAdded]   VARCHAR (50)  NULL,
    [DateEdited]    DATETIME      NULL,
    [UserIDEdited]  VARCHAR (50)  NULL,
    [DoctorReason]  VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblCasePanel] PRIMARY KEY CLUSTERED ([PanelNbr] ASC, [DoctorCode] ASC) WITH (FILLFACTOR = 90)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblCasePanel_DoctorCode]
    ON [dbo].[tblCasePanel]([DoctorCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCasePanel_SchedCodePanelNbr]
    ON [dbo].[tblCasePanel]([SchedCode] ASC, [PanelNbr] ASC);

