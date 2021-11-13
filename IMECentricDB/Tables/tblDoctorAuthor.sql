CREATE TABLE [dbo].[tblDoctorAuthor] (
    [DoctorCode]    INT          NOT NULL,
    [EWTransDeptID] INT          NOT NULL,
    [EWAuthorID]    INT          NOT NULL,
    [UserIDAdded]   VARCHAR (15) NULL,
    [DateAdded]     DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorAuthor] PRIMARY KEY CLUSTERED ([DoctorCode] ASC, [EWTransDeptID] ASC)
);

