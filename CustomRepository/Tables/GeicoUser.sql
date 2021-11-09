CREATE TABLE [dbo].[GeicoUser] (
    [Id]              INT          NOT NULL,
    [IsAdmin]         BIT          NOT NULL,
    [IsManager]       BIT          NOT NULL,
    [IsActive]        BIT          NOT NULL,
    [BusUnitId]       INT          NOT NULL,
    [WindowsUserName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_GeicoUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_GeicoUser_GeicoBusinessUnit] FOREIGN KEY ([BusUnitId]) REFERENCES [dbo].[GeicoBusinessUnit] ([Id])
);

