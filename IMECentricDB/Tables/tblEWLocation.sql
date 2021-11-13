CREATE TABLE [dbo].[tblEWLocation] (
    [EWLocationID] INT          NOT NULL,
    [Name]         VARCHAR (30) NULL,
    [GPLocation]   VARCHAR (3)  NULL,
    [Active]       BIT          NULL,
    [Accting]      VARCHAR (5)  NULL,
    CONSTRAINT [PK_tblEWLocation] PRIMARY KEY CLUSTERED ([EWLocationID] ASC)
);

