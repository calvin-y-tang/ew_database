CREATE TABLE [dbo].[EWFacilityGroupCategory] (
    [CategoryID]   INT          NOT NULL,
    [CategoryName] VARCHAR (20) NULL,
    [SeqNo]        INT          NULL,
    CONSTRAINT [PK_EWFacilityGroupCategory] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

