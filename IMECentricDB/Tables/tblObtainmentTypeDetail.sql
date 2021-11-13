CREATE TABLE [dbo].[tblObtainmentTypeDetail] (
    [ObtainmentTypeDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]            VARCHAR (50) NULL,
    [Status]                 VARCHAR (10) CONSTRAINT [DF_tblObtainmentTypeDetail_Status] DEFAULT ('Active') NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDAdded]            VARCHAR (50) NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDEdited]           VARCHAR (50) NULL,
    CONSTRAINT [PK_tblObtainmentTypeDetail] PRIMARY KEY CLUSTERED ([ObtainmentTypeDetailID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblObtainmentTypeDetail_Description]
    ON [dbo].[tblObtainmentTypeDetail]([Description] ASC);

