CREATE TABLE [dbo].[EWFlashCategory] (
    [EWFlashCategoryID] INT           NOT NULL,
    [Category]          VARCHAR (25)  NULL,
    [Descrip]           VARCHAR (100) NULL,
    [Active]            BIT           NULL,
    [Mapping1]          VARCHAR (10)  NULL,
    [Mapping2]          VARCHAR (10)  NULL,
    [Mapping3]          VARCHAR (10)  NULL,
    [Mapping7]          VARCHAR (10)  NULL,
    [Mapping4]          VARCHAR (10)  NULL,
    [Mapping5]          VARCHAR (10)  NULL,
    [Mapping6]          VARCHAR (10)  NULL,
    CONSTRAINT [PK_EWFlashCategory] PRIMARY KEY CLUSTERED ([EWFlashCategoryID] ASC)
);

