CREATE TABLE [dbo].[tblGPVoucher] (
    [PrimaryKey] INT      IDENTITY (1, 1) NOT NULL,
    [DoctorCode] INT      CONSTRAINT [DF_tblGPVoucher_DoctorCode] DEFAULT ((0)) NOT NULL,
    [Exported]   BIT      NULL,
    [ExportDate] DATETIME NULL,
    [VoHeaderID] INT      NOT NULL,
    CONSTRAINT [PK_tblGPVoucher] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
GO

CREATE NONCLUSTERED INDEX [IX_tblGPVoucher_VoHeaderID] ON [dbo].[tblGPVoucher] (VoHeaderID)
GO
