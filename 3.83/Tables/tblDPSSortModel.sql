CREATE TABLE [dbo].[tblDPSSortModel] (
    [SortModelID]      INT          IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (50) NULL,
    [ExtSortModelCode] VARCHAR (30) NULL,
    [Explanation] VARCHAR(100) NULL, 
    [PublishOnWeb] BIT NULL, 
    [DisplayOrder] INT NULL, 
    CONSTRAINT [PK_tblDPSSortModel] PRIMARY KEY CLUSTERED ([SortModelID] ASC)
);

