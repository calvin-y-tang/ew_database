CREATE TABLE [dbo].[EWAuthor] (
    [EWAuthorID]    INT          IDENTITY (1000, 1) NOT FOR REPLICATION NOT NULL,
    [DBID]          INT          NOT NULL,
    [DoctorCode]    INT          NOT NULL,
    [EWTransDeptID] INT          NOT NULL,
    [LastName]      VARCHAR (50) NULL,
    [FirstName]     VARCHAR (50) NULL,
    CONSTRAINT [PK_EWAuthor] PRIMARY KEY CLUSTERED ([EWAuthorID] ASC)
);

