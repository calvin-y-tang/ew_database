CREATE TABLE [dbo].[InfoUserSecurityGroup] (
    [UserID]          INT NOT NULL,
    [SecurityGroupID] INT NOT NULL,
    CONSTRAINT [PK_InfoUserSecurityGroup] PRIMARY KEY CLUSTERED ([UserID] ASC, [SecurityGroupID] ASC) WITH (FILLFACTOR = 90)
);

