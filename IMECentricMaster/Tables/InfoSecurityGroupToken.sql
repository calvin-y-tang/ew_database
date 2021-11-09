CREATE TABLE [dbo].[InfoSecurityGroupToken] (
    [SecurityGroupID] INT NOT NULL,
    [SecurityTokenID] INT NOT NULL,
    CONSTRAINT [PK_InfoSecurityGroupToken] PRIMARY KEY CLUSTERED ([SecurityGroupID] ASC, [SecurityTokenID] ASC) WITH (FILLFACTOR = 90)
);

