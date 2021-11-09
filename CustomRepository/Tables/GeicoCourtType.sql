CREATE TABLE [dbo].[GeicoCourtType] (
    [Id]                INT          IDENTITY (1, 1) NOT NULL,
    [GeicoDescription]  VARCHAR (30) NULL,
    [ProperDescription] VARCHAR (50) NULL,
    CONSTRAINT [PK_GeicoCourtType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

