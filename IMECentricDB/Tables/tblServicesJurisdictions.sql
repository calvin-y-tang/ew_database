
CREATE TABLE [dbo].[tblServicesJurisdictions]
(
	[StateCode]    VARCHAR (2)  NOT NULL,
	[ServiceCode]  INT			NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    [Country]      VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServicesJurisdictions] PRIMARY KEY CLUSTERED ([ServiceCode] ASC, [StateCode] ASC)
)
