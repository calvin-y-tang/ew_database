CREATE TABLE [dbo].[tblOutOfNetworkReason] (
    [OutOfNetworkReasonID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]          VARCHAR (64) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    [UserIDAdded]          VARCHAR (15) NOT NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    [Status]               VARCHAR (50)  CONSTRAINT [DF_tblOutOfNetworkReason_status] DEFAULT ('Active') NULL,
    CONSTRAINT [PK_tblOutOfNetworkReason] PRIMARY KEY CLUSTERED ([OutOfNetworkReasonID] ASC)
);

