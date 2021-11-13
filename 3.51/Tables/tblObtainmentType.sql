CREATE TABLE [dbo].[tblObtainmentType] (
    [ObtainmentTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (50) NULL,
    [DateAdded]        DATETIME     NULL,
    [ProdCode]         INT          NULL,
    [UserIDAdded]      VARCHAR (50) NULL,
    [DateEdited]       DATETIME     NULL,
    [UserIDEdited]     VARCHAR (50) NULL,
    CONSTRAINT [PK_tblObtainmentType] PRIMARY KEY CLUSTERED ([ObtainmentTypeID] ASC)
);

