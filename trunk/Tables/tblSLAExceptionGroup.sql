CREATE TABLE [dbo].[tblSLAExceptionGroup] (
    [SLAExceptionGroupID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]        INT          NOT NULL,
    [Active]              BIT          CONSTRAINT [DF_tblSLAExceptionGroup_Active] DEFAULT ((1)) NOT NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [ParentCompanyID]     INT          NULL,
    CONSTRAINT [PK_tblSLAExceptionGroup] PRIMARY KEY CLUSTERED ([SLAExceptionGroupID] ASC)
);

