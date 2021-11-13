CREATE TABLE [dbo].[tblDoctorFeeSchedule] (
    [DoctorFeeScheduleID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]          INT          NOT NULL,
    [EWNetworkID]         INT          NULL,
    [ProdCode]            INT          NOT NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [EWBusLineID]         INT          NULL,
    [EWSpecialtyID]       INT          NULL,
    [LocationCode]        INT          NULL,
    [EffDate]             DATETIME     NULL,
    [Prepay]              BIT          CONSTRAINT [DF_tblDoctorFeeSchedule_Prepay] DEFAULT ((0)) NOT NULL,
    [FeeAmount]           MONEY        CONSTRAINT [DF_tblDoctorFeeSchedule_FeeAmount] DEFAULT ((0)) NOT NULL,
    [CancelDays]          INT          CONSTRAINT [DF_tblDoctorFeeSchedule_CancelDays] DEFAULT ((0)) NOT NULL,
    [LateCancelAmount]    MONEY        CONSTRAINT [DF_tblDoctorFeeSchedule_LateCancelAmount] DEFAULT ((0)) NOT NULL,
    [NoShow1Amount]       MONEY        CONSTRAINT [DF_tblDoctorFeeSchedule_NoShow1Amount] DEFAULT ((0)) NOT NULL,
    [NoShow2Amount]       MONEY        CONSTRAINT [DF_tblDoctorFeeSchedule_NoShow2Amount] DEFAULT ((0)) NOT NULL,
    [NoShow3Amount]       MONEY        CONSTRAINT [DF_tblDoctorFeeSchedule_NoShow3Amount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblDoctorFeeSchedule] PRIMARY KEY CLUSTERED ([DoctorFeeScheduleID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorFeeSchedule_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate]
    ON [dbo].[tblDoctorFeeSchedule]([DoctorCode] ASC, [EWNetworkID] ASC, [ProdCode] ASC, [EWBusLineID] ASC, [EWSpecialtyID] ASC, [LocationCode] ASC, [EffDate] ASC);

