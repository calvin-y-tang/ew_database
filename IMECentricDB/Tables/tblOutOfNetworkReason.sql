CREATE TABLE [dbo].[tblOutOfNetworkReason] (
    [OutOfNetworkReasonID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]          VARCHAR (32) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    [UserIDAdded]          VARCHAR (15) NOT NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblOutOfNetworkReason] PRIMARY KEY CLUSTERED ([OutOfNetworkReasonID] ASC)
);

