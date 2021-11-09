CREATE TABLE [dbo].[ISElectronicService] (
    [ElectronicServiceID]    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]                   TINYINT      NOT NULL,
    [Active]                 BIT          NOT NULL,
    [CustomerID]             INT          NOT NULL,
    [DataTransportProfileID] INT          NOT NULL,
    [FileVersion]            VARCHAR (16) NULL,
    [FileFormat]             VARCHAR (32) NULL,
    [EncryptionKeyID]        INT          NULL,
    [ScheduleID]             INT          CONSTRAINT [DF_ISElectronicService_ScheduleID] DEFAULT ((0)) NOT NULL,
    [Description]            VARCHAR (64) CONSTRAINT [DF_ISElectronicService_Description] DEFAULT ('NA') NOT NULL,
    CONSTRAINT [PK_ISElectronicService] PRIMARY KEY CLUSTERED ([ElectronicServiceID] ASC),
    CONSTRAINT [FK_ISElectronicService_ISCustomer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[ISCustomer] ([CustomerID]),
    CONSTRAINT [FK_ISElectronicService_ISDataTransportProfile] FOREIGN KEY ([DataTransportProfileID]) REFERENCES [dbo].[ISDataTransportProfile] ([DataTransportProfileID]),
    CONSTRAINT [FK_ISElectronicServices_ISEncryptionKeys] FOREIGN KEY ([EncryptionKeyID]) REFERENCES [dbo].[ISEncryptionKey] ([EncryptionKeyID])
);


GO

CREATE TRIGGER [dbo].[ISElectronicService_AfterInsertUpdate] ON [dbo].[ISElectronicService]
AFTER INSERT, UPDATE 
AS
	
	-- use schedule ID from INSERTED Table as it will be populated for both INSERT and UPDATE actions
	UPDATE ISSchedule
	SET Param = 'ElectronicServiceID='+CONVERT(VARCHAR(20),inserted.ElectronicServiceID)
	FROM inserted
	WHERE inserted.ScheduleID=ISSchedule.ScheduleID

	RETURN