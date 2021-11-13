CREATE TABLE [dbo].[InfoLayout] (
    [LayoutID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [InheritedLayoutID]  INT           NULL,
    [OwnerUserID]        INT           NULL,
    [InfoCentricVersion] VARCHAR (15)  NULL,
    [DateModified]       DATETIME      NULL,
    [LayoutName]         VARCHAR (50)  NULL,
    [LayoutType]         INT           NULL,
    [LayoutClass]        INT           NULL,
    [LayoutDataset]      INT           NULL,
    [LayoutIni]          VARCHAR (MAX) NULL,
    CONSTRAINT [PK_InfoLayout] PRIMARY KEY CLUSTERED ([LayoutID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoLayout_LayoutClass]
    ON [dbo].[InfoLayout]([LayoutClass] ASC) WITH (FILLFACTOR = 90);

