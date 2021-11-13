CREATE TABLE [dbo].[ISOperation] (
    [OperationID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Command]             TINYINT        NOT NULL,
    [Description]         VARCHAR (32)   NULL,
    [SeqNo]               INT            NOT NULL,
    [Param]               VARCHAR (8000) NULL,
    [ElectronicServiceID] INT            CONSTRAINT [DF_ISOperation_ElectronicServiceID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ISOperation] PRIMARY KEY CLUSTERED ([OperationID] ASC),
    CONSTRAINT [IS_FX_ISOperation_ISElectronicService_ElectronicServiceID] FOREIGN KEY ([ElectronicServiceID]) REFERENCES [dbo].[ISElectronicService] ([ElectronicServiceID])
);

