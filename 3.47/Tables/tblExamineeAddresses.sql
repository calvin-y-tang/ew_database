CREATE TABLE [dbo].[tblExamineeAddresses]
(
	[ExamineeAddressID]			INT IDENTITY(1,1) NOT NULL,
    [ChartNbr]                     INT	NOT NULL,
    [Addr1]                        VARCHAR (50) NULL,
    [Addr2]                        VARCHAR (50) NULL,
    [City]                         VARCHAR (50) NULL,
    [State]                        VARCHAR (2)  NULL,
    [Zip]                          VARCHAR (10) NULL,
    [DateAdded]                    DATETIME     NULL,
    [DateEdited]                   DATETIME     NULL,
    [UserIDAdded]                  VARCHAR (15) NULL,
    [UserIDEdited]                 VARCHAR (15) NULL,
    [County]                       VARCHAR (50) NULL,
    CONSTRAINT [PK_tblExamineeAddresses] PRIMARY KEY CLUSTERED ([ExamineeAddressID] ASC)
);
