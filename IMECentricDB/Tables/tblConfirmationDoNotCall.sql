CREATE TABLE [dbo].[tblConfirmationDoNotCall]
(
	[ConfirmationDoNotCallID] INT IDENTITY (1, 1) NOT NULL,
	[PhoneNumber]             VARCHAR (15) NOT NULL,
	[RequestedBy]             VARCHAR(100) NULL,
	[PhoneCall]               BIT CONSTRAINT [DF_tblConfirmationDoNotCall_PhoneCall] DEFAULT ((0)) NULL,
	[Fax]                     BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Fax] DEFAULT ((0)) NULL,
	[Email]                   BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Email] DEFAULT ((0)) NULL,
	[Text]                    BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Text] DEFAULT ((0)) NULL,
	[ConfirmationCall]        BIT CONSTRAINT [DF_tblConfirmationDoNotCall_ConfirmationCall] DEFAULT ((0)) NULL,
	[DateAdded]               DATETIME NOT NULL,
	[UserIDAdded]             VARCHAR (15) NOT NULL,
	[ConfirmationListID]      INT NULL, 
	CONSTRAINT [PK_tblConfirmationDoNotCall] PRIMARY KEY CLUSTERED ([ConfirmationDoNotCallID] ASC)
)

GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationDoNotCall_PhoneNumber]
    ON [dbo].[tblConfirmationDoNotCall]([PhoneNumber] ASC);

