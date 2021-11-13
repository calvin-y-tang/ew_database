CREATE TABLE [dbo].[tblEWTransDept] (
    [EWTransDeptID] INT           NOT NULL,
    [Name]          VARCHAR (20)  NULL,
    [DBID]          INT           NOT NULL,
    [FolderPath]    VARCHAR (260) NULL,
    [Active]        BIT           NOT NULL,
    [WinScribeDept] INT           NULL,
    [EWTimeZoneID]  INT           NULL,
    [FolderID]      INT           NULL,
    [EnableAdditionalDocuments] BIT NULL, 
    CONSTRAINT [PK_tblEWTransDept] PRIMARY KEY CLUSTERED ([EWTransDeptID] ASC)
);





