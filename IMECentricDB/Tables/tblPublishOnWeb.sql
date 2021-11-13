CREATE TABLE [dbo].[tblPublishOnWeb] (
    [PublishID]    INT          IDENTITY (1, 1) NOT NULL,
    [TableType]    VARCHAR (50) NULL,
    [TableKey]     INT          NULL,
    [UserID]       VARCHAR (50) NULL,
    [UserType]     VARCHAR (50) NULL,
    [UserCode]     INT          NULL,
    [PublishOnWeb] BIT          CONSTRAINT [DF_tblPublishOnWeb_PublishOnWeb] DEFAULT (0) NOT NULL,
    [Notify]       BIT          CONSTRAINT [DF_tblPublishOnWeb_Notify] DEFAULT (0) NOT NULL,
    [PublishAsPDF] BIT          CONSTRAINT [DF_tblPublishOnWeb_PublishAsPDF] DEFAULT (0) NOT NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (50) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    [Viewed]       BIT          NULL,
    [CaseNbr]      INT          NULL,
    [UseWidget]	   BIT			CONSTRAINT [DF_tblPublishOnWeb_UseWidget] DEFAULT (1) NOT NULL, 
    [DateViewed] DATETIME NULL, 
    CONSTRAINT [PK_tblPublishOnWeb] PRIMARY KEY CLUSTERED ([PublishID] ASC)
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_tblPublishOnWeb_TableTypeUserTypeUserCodePublishOnWebTableKey]
    ON [dbo].[tblPublishOnWeb]([TableType] ASC, [UserType] ASC, [UserCode] ASC, [PublishOnWeb] ASC, [TableKey] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblPublishOnWeb_TableTypeTableKey]
    ON [dbo].[tblPublishOnWeb]([TableType] ASC, [TableKey] ASC);

