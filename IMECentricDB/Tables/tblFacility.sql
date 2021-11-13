CREATE TABLE [dbo].[tblFacility] (
    [FacilityID]      INT           IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (100) NULL,
    [Address1]        VARCHAR (100) NULL,
    [Address2]        VARCHAR (100) NULL,
    [City]            VARCHAR (50)  NULL,
    [State]           VARCHAR (2)   NULL,
    [Zip]             VARCHAR (15)  NULL,
    [Phone]           VARCHAR (15)  NULL,
    [Fax]             VARCHAR (15)  NULL,
    [Email]           VARCHAR (70)  NULL,
    [Status]          VARCHAR (10)  NULL,
    [DateAdded]       DATETIME      NULL,
    [UserIDAdded]     VARCHAR (15)  NULL,
    [DateEdited]      DATETIME      NULL,
    [UserIDEdited]    VARCHAR (15)  NULL,
    [Notes]           TEXT          NULL,
    [ContactPrefix]   VARCHAR (5)   NULL,
    [ContactFirst]    VARCHAR (25)  NULL,
    [ContactLast]     VARCHAR (50)  NULL,
    [RemitToName]     VARCHAR (100) NULL,
    [RemitToAddress1] VARCHAR (100) NULL,
    [RemitToAddress2] VARCHAR (100) NULL,
    [RemitToCity]     VARCHAR (50)  NULL,
    [RemitToState]    VARCHAR (2)   NULL,
    [RemitToZip]      VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblFacility] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);


GO
