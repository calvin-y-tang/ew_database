CREATE TABLE [dbo].[tblTreatingDoctor] (
    [TreatingDoctorID] INT          IDENTITY (1, 1) NOT NULL,
    [LastName]         VARCHAR (50) NULL,
    [FirstName]        VARCHAR (50) NULL,
    [MI]               VARCHAR (2)  NULL,
    [TaxID]            VARCHAR (15) NULL,
    [DateAdded]        DATETIME     NULL,
    [DateEdited]       DATETIME     NULL,
    [UserIDAdded]      VARCHAR (15) NULL,
    [UserIDEdited]     VARCHAR (15) NULL,
    [Addr1]            VARCHAR (50) NULL,
    [Addr2]            VARCHAR (50) NULL,
    [City]             VARCHAR (50) NULL,
    [State]            VARCHAR (2)  NULL,
    [Zip]              VARCHAR (10) NULL,
    [Phone]            VARCHAR (15) NULL,
    [Fax]              VARCHAR (15) NULL,
    [Email]            VARCHAR (70) NULL,
    CONSTRAINT [PK_tblTreatingDoctor] PRIMARY KEY CLUSTERED ([TreatingDoctorID] ASC)
);

