CREATE TABLE [dbo].[tblCCAddressEntity]
(
	[CCAddressEntityID] INT          IDENTITY (1, 1) NOT NULL, 
	[ccCode]            INT          NOT NULL, 
	[EntityType]        VARCHAR(2)   NOT NULL, 
	[EntityID]          INT          NOT NULL, 
	[DateAdded]         DATETIME     NULL,
	[UserIDAdded]       VARCHAR (15) NULL,
	[DateEdited]        DATETIME     NULL,
	[UserIDEdited]      VARCHAR (15) NULL,
	CONSTRAINT [PK_tblCCAddressEntity] PRIMARY KEY CLUSTERED ([CCAddressEntityID] ASC)
)
