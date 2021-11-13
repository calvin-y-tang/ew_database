CREATE TABLE [dbo].[GeicoExpert] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [GeicoExpertID]   INT          NULL,
    [ExpertLastName]  VARCHAR (30) NULL,
    [ExpertFirstName] VARCHAR (30) NULL,
    [IsActive]        BIT          NOT NULL,
    CONSTRAINT [PK_GeicoExpert] PRIMARY KEY CLUSTERED ([Id] ASC)
);

