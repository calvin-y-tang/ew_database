CREATE TABLE [dbo].[tblLocationOffice] (
    [LocationCode]	INT          NOT NULL,
    [OfficeCode]	INT          NOT NULL,
    [DateAdded]		DATETIME     NULL,
    [UserIDAdded]	 VARCHAR (15) NULL,
    CONSTRAINT [PK_tblLocationOffice] PRIMARY KEY CLUSTERED ([LocationCode] ASC, [OfficeCode] ASC)
);
GO

