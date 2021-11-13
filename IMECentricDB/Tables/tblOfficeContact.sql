CREATE TABLE [dbo].[tblOfficeContact]
(
    [OfficeContactCode] INT          IDENTITY (1, 1) NOT NULL,
    [OfficeCode]        INT          NOT NULL,
    [EWBusLineID]       INT          NULL,
    [Department]        INT          NULL,
    [Email]             VARCHAR (70) NOT NULL,
    [Phone]             VARCHAR (15) NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDAdded]       VARCHAR (30) NULL,
    [UserIDEdited]      VARCHAR (30) NULL,
    [Priority]          INT          CONSTRAINT [DF_tblOfficeContact_Priority] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [PK_tblOfficeContact] PRIMARY KEY CLUSTERED ([OfficeContactCode] ASC)
);


GO


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblOfficeContact_OfficeCodeDepartmentEWBusLineID]
    ON [dbo].[tblOfficeContact]([OfficeCode] ASC, [Department] ASC, [EWBusLineID] ASC);

