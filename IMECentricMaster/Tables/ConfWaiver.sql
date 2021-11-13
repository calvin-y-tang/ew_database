CREATE TABLE [dbo].[ConfWaiver] (
    [ConfirmationWaiverID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DateAdded]            DATETIME      NOT NULL,
    [AddedBy]              VARCHAR (15)  NOT NULL,
    [Action]               VARCHAR (16)  NOT NULL,
    [ConfirmationType]     VARCHAR (8)   NOT NULL,
    [DateEdited]           DATETIME      NOT NULL,
    [EditedBy]             VARCHAR (15)  NOT NULL,
    [Active]               BIT           NOT NULL,
    [Phone]                VARCHAR (18)  NOT NULL,
    [Sid]                  VARCHAR (128) NULL,
    CONSTRAINT [PK_ConfWaiver] PRIMARY KEY CLUSTERED ([ConfirmationWaiverID] ASC) WITH (FILLFACTOR = 90)
);

