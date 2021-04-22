CREATE TABLE [dbo].[tblAutoProvisionLog] (
    [APLogID]            INT            IDENTITY (1, 1) NOT NULL,
    [EntityType]         CHAR (2)       NOT NULL,
    [EntityID]           INT            NULL,
    [WebUserID]          INT            NULL,
    [APType]             CHAR (8)       NOT NULL,
    [Result]             VARCHAR (32)   NULL,
    [Details]            VARCHAR (4096) NULL,
    [Param1Name]         VARCHAR (32)   NULL,
    [Param1Value]        VARCHAR (255)  NULL,
    [Param2Name]         VARCHAR (32)   NULL,
    [Param2Value]        VARCHAR (255)  NULL,
    [Param3Name]         VARCHAR (32)   NULL,
    [Param3Value]        VARCHAR (255)  NULL,
    [Param4Name]         VARCHAR (32)   NULL,
    [Param4Value]        VARCHAR (255)  NULL,
    [Param5Name]         VARCHAR (32)   NULL,
    [Param5Value]        VARCHAR (255)  NULL,
    [DateAdded]          DATETIME       NOT NULL,
    [UserIDAdded]        VARCHAR (20)   NOT NULL,
    [DateAcknowledged]   DATETIME       NULL,
    [UserIDAcknowledged] VARCHAR (20)   NULL,
    CONSTRAINT [PK_tblAutoProvisionLog] PRIMARY KEY CLUSTERED ([APLogID] ASC)
);


