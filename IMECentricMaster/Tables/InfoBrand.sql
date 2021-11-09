CREATE TABLE [dbo].[InfoBrand] (
    [BrandID]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]      VARCHAR (15) NULL,
    [ShortName] VARCHAR (5)  NULL,
    [SeqNo]     INT          NULL,
    CONSTRAINT [PK_InfoBrand] PRIMARY KEY CLUSTERED ([BrandID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_InfoBrand_ShortName]
    ON [dbo].[InfoBrand]([ShortName] ASC);

