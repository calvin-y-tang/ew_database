CREATE TABLE [dbo].[tblQueueForms] (
    [FormName]    VARCHAR (20) NOT NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblQueueForms] PRIMARY KEY CLUSTERED ([FormName] ASC)
);

