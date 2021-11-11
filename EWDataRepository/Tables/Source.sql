CREATE TABLE [dbo].[Source] (
    [SourceID]      INT           NOT NULL,
    [Descrip]       VARCHAR (40)  NULL,
    [EWFacilityID]  INT           NULL,
    [Contact_Email] VARCHAR (200) NULL,
    CONSTRAINT [PK_Source] PRIMARY KEY CLUSTERED ([SourceID] ASC)
);



