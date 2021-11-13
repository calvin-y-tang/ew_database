CREATE TABLE [dbo].[tblActions] (
    [ActionID]               UNIQUEIDENTIFIER CONSTRAINT [DF_tblActions_ActionID] DEFAULT (newid()) NOT NULL,
    [Action_AddedDate]       DATETIME         CONSTRAINT [DF_tblActions_action_AddedDate] DEFAULT (getdate()) NOT NULL,
    [Action_UserGUID]        UNIQUEIDENTIFIER NULL,
    [Action_command]         VARCHAR (15)     NOT NULL,
    [Action_Param1]          VARCHAR (255)    NOT NULL,
    [Action_Param2]          VARCHAR (255)    NULL,
    [Action_Param3]          VARCHAR (255)    NULL,
    [Action_Param4]          VARCHAR (255)    NULL,
    [Action_Param5]          TEXT             NULL,
    [Action_ResponseDate]    DATETIME         NULL,
    [Action_ResponseCode]    INT              NULL,
    [Action_ResponseMessage] TEXT             NULL,
    [Action_LocalID]         INT              NULL,
    [Action_LocalIDType]     INT              NULL,
    CONSTRAINT [PK_tblActions] PRIMARY KEY CLUSTERED ([ActionID] ASC)
);

