CREATE TABLE [dbo].[tblWebCompany] 
(
    [WebCompanyID]      INT           NOT NULL,
    [Name]              VARCHAR (25)  NULL,
	[URL]               VARCHAR (200) NULL,
	[WebActionLinkPage] VARCHAR (50)  NULL,
    [TeamMembersURL]    VARCHAR(100)  NULL,
    CONSTRAINT [PK_tblWebCompany] PRIMARY KEY CLUSTERED ([WebCompanyID] ASC)
);

