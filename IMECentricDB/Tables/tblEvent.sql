CREATE TABLE [dbo].[tblEvent] (
    [EventID]  INT           NOT NULL,
    [Descrip]  VARCHAR (100) NULL,
    [Category] VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblEvent] PRIMARY KEY CLUSTERED ([EventID] ASC)
);

