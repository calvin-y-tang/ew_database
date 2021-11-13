CREATE TABLE [dbo].[tblEmployerAddress]
(
	[EmployerAddressID] INT IDENTITY(1, 1) NOT NULL , 
    [EmployerID]        INT                NOT NULL, 
    [Address1]          VARCHAR(50)        NULL, 
    [Address2]          VARCHAR(50)        NULL, 
    [City]              VARCHAR(50)        NULL, 
    [State]             VARCHAR(2)         NULL, 
    [Zip]               VARCHAR(10)        NULL, 
    [ContactFirst]      VARCHAR(50)        NULL, 
    [ContactLast]       VARCHAR(50)        NULL, 
    [Phone]             VARCHAR(15)        NULL, 
    [PhoneExt]          VARCHAR(10)        NULL, 
    [Fax]               VARCHAR(15)        NULL, 
    [Email]             VARCHAR(70)        NULL, 
    [DateAdded]         DATETIME           NULL, 
    [UserIDAdded]       VARCHAR(15)        NULL, 
    [DateEdited]        DATETIME           NULL, 
    [UserIDEdited]      VARCHAR(15)        NULL
	CONSTRAINT [PK_tblEmployerAddress] PRIMARY KEY CLUSTERED ([EmployerAddressID] ASC)
)
