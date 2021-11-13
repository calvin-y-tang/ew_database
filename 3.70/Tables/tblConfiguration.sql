CREATE TABLE [dbo].[tblConfiguration] (
    [ConfigurationID]   INT           NOT NULL,
    [Name]              VARCHAR (30)  NULL,
    [Active]            BIT           CONSTRAINT [DF_tblConfiguration_Active] DEFAULT ((1)) NOT NULL,
    [ConfigurationType] VARCHAR (15)  NULL,
    [DateEdited]        DATETIME      CONSTRAINT [DF_tblConfiguration_DateEdited] DEFAULT (getdate()) NOT NULL,
    [UserIDEdited]      VARCHAR (15)  NULL,
    [Param]             VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblConfiguration] PRIMARY KEY CLUSTERED ([ConfigurationID] ASC)
);

