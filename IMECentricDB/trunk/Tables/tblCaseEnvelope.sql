CREATE TABLE [dbo].[tblCaseEnvelope]
(
    [CaseEnvelopeID]     INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]            INT           NOT NULL,
    [EnvelopeID]         VARCHAR(32)  NOT NULL,
    [AddressedToEntity]  VARCHAR(2)   NOT NULL,
    [EntityID]           INT           NOT NULL,
    [IsCertifiedMail]    BIT           NOT NULL,
    [CertifiedMailNbr]   VARCHAR(32)  NULL,
    [DateAdded]          DATETIME      NOT NULL,
    [UserIDAdded]        VARCHAR(15)  NOT NULL,
    [DateImported]       DATETIME      NULL,
    [DateAcknowledged]   DATETIME      NULL,
    [UserIDAcknowledged] VARCHAR(15)  NULL,
    [ImportFileName]     VARCHAR(255) NULL,
    [PageCount]          INT           NULL,
    CONSTRAINT [PK_tblCaseEnvelope] PRIMARY KEY CLUSTERED ([CaseEnvelopeID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCaseEnvelope_CaseNbrIsCertifiedMailDateAcknowledgedAddressedToEntityDateImported]
    ON [dbo].[tblCaseEnvelope]([CaseNbr] ASC, [IsCertifiedMail] ASC, [DateAcknowledged] ASC, [AddressedToEntity] ASC, [DateImported] ASC);

