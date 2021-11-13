CREATE TABLE [dbo].[tblDegree] (
    [DegreeCode]  VARCHAR (20) NOT NULL,
    [Description] VARCHAR (50) NULL,
    [EWDegreeID]  INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblDegree] PRIMARY KEY CLUSTERED ([EWDegreeID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDegree_DegreeCode]
    ON [dbo].[tblDegree]([DegreeCode] ASC);

