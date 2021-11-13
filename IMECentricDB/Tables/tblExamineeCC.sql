CREATE TABLE [dbo].[tblExamineeCC] (
    [ChartNbr] INT NOT NULL,
    [ccCode]   INT NOT NULL,
    CONSTRAINT [PK_tblExamineeCC] PRIMARY KEY CLUSTERED ([ChartNbr] ASC, [ccCode] ASC)
);

