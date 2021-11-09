CREATE TABLE [dbo].[InfoProduct] (
    [ProductID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]      VARCHAR (30) NULL,
    [Brand]     VARCHAR (5)  NULL,
    [SeqNo]     INT          NULL,
    CONSTRAINT [PK_InfoProduct] PRIMARY KEY CLUSTERED ([ProductID] ASC)
);

