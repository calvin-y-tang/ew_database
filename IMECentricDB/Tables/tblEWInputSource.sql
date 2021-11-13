CREATE TABLE [dbo].[tblEWInputSource] (
    [InputSourceID] INT          NOT NULL,
    [Name]          VARCHAR (20) NULL,
    [Mapping1]      VARCHAR (40) NULL,
    [Note1]         VARCHAR (70) NULL,
    [Mapping2]      VARCHAR (40) NULL,
    [Note2]         VARCHAR (70) NULL,
    CONSTRAINT [PK_tblEWInputSource] PRIMARY KEY CLUSTERED ([InputSourceID] ASC)
);

