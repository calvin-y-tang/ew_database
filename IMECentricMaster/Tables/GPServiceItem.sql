CREATE TABLE [dbo].[GPServiceItem] (
    [NaturalAcct] INT          NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    [ItemNum]     VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_GPServiceItem] PRIMARY KEY CLUSTERED ([NaturalAcct] ASC)
);

