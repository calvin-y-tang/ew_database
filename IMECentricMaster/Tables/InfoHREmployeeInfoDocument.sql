CREATE TABLE [dbo].[InfoHREmployeeInfoDocument] (
    [EmployeeID] INT NOT NULL,
    [DocumentID] INT NOT NULL,
    CONSTRAINT [PK_InfoHREmployeeInfoDocument] PRIMARY KEY CLUSTERED ([EmployeeID] ASC, [DocumentID] ASC) WITH (FILLFACTOR = 90)
);

