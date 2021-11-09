CREATE TABLE [dbo].[InfoHREmployee] (
    [EmployeeID]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IntegrationID]   VARCHAR (10) NULL,
    [FirstName]       VARCHAR (50) NULL,
    [LastName]        VARCHAR (50) NULL,
    [Department]      VARCHAR (5)  NULL,
    [Status]          VARCHAR (15) NULL,
    [JobTitle]        VARCHAR (50) NULL,
    [IntegrationCode] VARCHAR (8)  NULL,
    CONSTRAINT [PK_InfoHREmployee] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoHREmployee_LastNameFirstName]
    ON [dbo].[InfoHREmployee]([LastName] ASC, [FirstName] ASC) WITH (FILLFACTOR = 90);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_InfoHREmployee_IntegrationID]
    ON [dbo].[InfoHREmployee]([IntegrationID] ASC, [IntegrationCode] ASC) WITH (FILLFACTOR = 90);

