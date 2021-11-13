CREATE TABLE [dbo].[ISDataTransportProfile] (
    [DataTransportProfileID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Host]                   NVARCHAR (2048) NOT NULL,
    [UserID]                 VARCHAR (64)    NOT NULL,
    [Password]               VARCHAR (64)    NOT NULL,
    [Active]                 BIT             NOT NULL,
    [PortNumber]             INT             NULL,
    [CustomerID]             INT             NOT NULL,
    [DTPDescription]         VARCHAR (64)    CONSTRAINT [DF_ISDataTransportProfile_DTPDescription] DEFAULT ('') NOT NULL,
    [UseSFTP]                BIT             CONSTRAINT [DF_ISDataTransportProfile_UseSFTP] DEFAULT ((0)) NOT NULL,
    [SFTPFingerprint]        VARCHAR (256)   NULL,
    CONSTRAINT [PK_ISDataTransportProfile] PRIMARY KEY CLUSTERED ([DataTransportProfileID] ASC),
    CONSTRAINT [FK_ISDataTransportProfile_ISCustomer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[ISCustomer] ([CustomerID])
);

