CREATE TABLE [dbo].[tblEWFacilityGroupCategory] (
    [CategoryID]   INT          NOT NULL,
    [CategoryName] VARCHAR (20) NULL,
    [SeqNo]        INT          NULL,
    CONSTRAINT [PK_tblEWFacilityGroupCategory] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

