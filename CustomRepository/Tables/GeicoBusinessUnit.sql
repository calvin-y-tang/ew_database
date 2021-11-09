CREATE TABLE [dbo].[GeicoBusinessUnit] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]     VARCHAR (128) NOT NULL,
    [IsActive] BIT           NOT NULL,
    CONSTRAINT [PK_GeicoBusinessUnit] PRIMARY KEY CLUSTERED ([Id] ASC)
);

