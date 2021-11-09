CREATE TABLE [dbo].[EWLocation] (
    [EWLocationID] INT          NOT NULL,
    [Name]         VARCHAR (30) NULL,
    [GPLocation]   VARCHAR (3)  NULL,
    [Active]       BIT          NULL,
    [Accting]      VARCHAR (5)  NULL,
    CONSTRAINT [PK_EWLocation] PRIMARY KEY CLUSTERED ([EWLocationID] ASC)
);

