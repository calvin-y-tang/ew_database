CREATE TABLE [dbo].[tblSLAException] (
    [SLAExceptionID]      INT           IDENTITY (1, 1) NOT NULL,
    [SLAExceptionGroupID] INT           NOT NULL,
    [Descrip]             VARCHAR (150) NULL,
    [Active]              BIT           CONSTRAINT [DF_tblSLAException_Active] DEFAULT ((1)) NOT NULL,
    [DateAdded]           DATETIME      NULL,
    [UserIDAdded]         VARCHAR (15)  NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDEdited]        VARCHAR (15)  NULL,
    [ExternalCode]        VARCHAR (10)  NULL,
    [RequireExplanation]  BIT           CONSTRAINT [DF_tblSLAException_RequireExplanation] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblSLAException] PRIMARY KEY CLUSTERED ([SLAExceptionID] ASC)
);



