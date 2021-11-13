CREATE TABLE [dbo].[tblLabelFile] (
    [LabelID]      INT           IDENTITY (1, 1) NOT NULL,
    [LabelName]    VARCHAR (100) NULL,
    [LabelFile]    VARCHAR (200) NULL,
    [Roll1]        BIT           CONSTRAINT [DF_tblLabelFile_Roll1] DEFAULT ((0)) NULL,
    [Roll2]        BIT           CONSTRAINT [DF_tblLabelFile_Roll2] DEFAULT ((0)) NULL,
    [Type]         VARCHAR (10)  NULL,
    [DateAdded]    DATETIME      NULL,
    [UserIDAdded]  VARCHAR (50)  NULL,
    [DateEdited]   DATETIME      NULL,
    [UserIDEdited] VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblLabelFile] PRIMARY KEY CLUSTERED ([LabelID] ASC)
);

