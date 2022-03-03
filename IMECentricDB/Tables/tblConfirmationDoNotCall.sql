CREATE TABLE [dbo].[tblConfirmationDoNotCall]
(
	[ConfirmationDoNotCallID] INT IDENTITY (1, 1) NOT NULL,
	[PhoneNumber]             VARCHAR (15) NOT NULL,
	[PhoneNumberDashes]       VARCHAR (15) NOT NULL,
	[PhoneNumberParen]        VARCHAR (15) NOT NULL,
	[RequestedBy]             VARCHAR(100) NULL,
	[PhoneCall]               BIT CONSTRAINT [DF_tblConfirmationDoNotCall_PhoneCall] DEFAULT ((0)) NOT NULL,
	[Fax]                     BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Fax] DEFAULT ((0)) NOT NULL,
	[Email]                   BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Email] DEFAULT ((0)) NOT NULL,
	[Text]                    BIT CONSTRAINT [DF_tblConfirmationDoNotCall_Text] DEFAULT ((0)) NOT NULL,
	[ConfirmationCall]        BIT CONSTRAINT [DF_tblConfirmationDoNotCall_ConfirmationCall] DEFAULT ((0)) NOT NULL,
	[DateAdded]               DATETIME NOT NULL,
	[UserIDAdded]             VARCHAR (15) NOT NULL,
	[ConfirmationListID]      INT NULL, 
	CONSTRAINT [PK_tblConfirmationDoNotCall] PRIMARY KEY CLUSTERED ([ConfirmationDoNotCallID] ASC)
)
GO

CREATE NONCLUSTERED INDEX [IX_tblConfirmationDoNotCall_PhoneNumberFormats]
    ON [dbo].[tblConfirmationDoNotCall]([PhoneNumber] ASC, [PhoneNumberDashes] ASC, [PhoneNumberParen] ASC);
GO

