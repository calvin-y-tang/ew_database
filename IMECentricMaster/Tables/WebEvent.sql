CREATE TABLE [dbo].[WebEvent] (
    [WebEventID]  INT          NOT NULL,
    [Type]        VARCHAR (10) NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_WebEvent] PRIMARY KEY CLUSTERED ([WebEventID] ASC)
);

