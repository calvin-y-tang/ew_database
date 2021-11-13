CREATE TABLE [dbo].[InfoSecurityGroup] (
    [SecurityGroupID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]            VARCHAR (60) NOT NULL,
    [SeqNo]           INT          NULL,
    [GroupType]       INT          NULL,
    [ReferenceID]     INT          NULL,
    CONSTRAINT [PK_InfoSecurityGroup] PRIMARY KEY CLUSTERED ([SecurityGroupID] ASC) WITH (FILLFACTOR = 90)
);

