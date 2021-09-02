CREATE TABLE [dbo].[tblConfirmationLocation]
(
	[LocationCode]	INT NOT NULL,
	[ExtName]      VARCHAR (50)  NULL,
    [Addr1]         VARCHAR (50)  NULL,
    [Addr2]         VARCHAR (50)  NULL,
    [City]          VARCHAR (50)  NULL,
    [State]         VARCHAR (2)   NULL,
    [Zip]           VARCHAR (15)  NULL,
	[DateExported] DATETIME NULL,
	CONSTRAINT [PK_tblConfirmationLocation] PRIMARY KEY CLUSTERED ([LocationCode])
)
