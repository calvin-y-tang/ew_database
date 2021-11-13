CREATE TABLE [dbo].[tblSLARule] (
    [SLARuleID]    INT          IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (70) NULL,
    [ProcessOrder] INT          NOT NULL,
    [Active]       BIT          CONSTRAINT [DF_tblSLARule_Active] DEFAULT ((1)) NOT NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    [UseException] BIT          CONSTRAINT [DF_tblSLARule_UseException] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblSLARule] PRIMARY KEY CLUSTERED ([SLARuleID] ASC)
);

