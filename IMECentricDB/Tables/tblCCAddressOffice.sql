CREATE TABLE [dbo].[tblCCAddressOffice] (
    [CCCode]		INT          NOT NULL,
    [OfficeCode]	INT          NOT NULL,
    [DateAdded]		DATETIME     NULL,
    [UserIDAdded]	VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCCAddressOffice] PRIMARY KEY CLUSTERED ([CCCode] ASC, [OfficeCode] ASC)
);

