CREATE TABLE [dbo].[tblUserOffice] (
    [UserID]        VARCHAR (30) NOT NULL,
    [OfficeCode]    INT          NOT NULL,
    [DefaultOffice] BIT          CONSTRAINT [DF_tblUserOffice_DefaultOffice] DEFAULT ((0)) NOT NULL,
    [DateAdded]     DATETIME     NULL,
    [UserIDAdded]   VARCHAR (30) NULL,
    CONSTRAINT [PK_tblUserOffice] PRIMARY KEY CLUSTERED ([UserID] ASC, [OfficeCode] ASC)
);

