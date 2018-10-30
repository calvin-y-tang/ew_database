CREATE TABLE [dbo].[tblHCAIControl] (
    [DBID]                INT           NOT NULL,
    [PMSUserName]         VARCHAR (30)  NOT NULL,
    [PMSPassword]         VARCHAR (30)  NOT NULL,
    [FacilityRegistryID]  VARCHAR (30)  NOT NULL,
    [PMSSoftware]         VARCHAR (30)  NOT NULL,
    [MakeChequePayableTo] VARCHAR (100) NOT NULL,
    [StartDate]           SMALLDATETIME NOT NULL,
    [EndDate]             SMALLDATETIME NOT NULL,
    [NewVersionPath]      VARCHAR (255) NOT NULL,
    [OCF21Version]        VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblHCAIControl] PRIMARY KEY CLUSTERED ([DBID] ASC)
);

