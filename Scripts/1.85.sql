
--Changes for WinScribe Author ID Assignment

ALTER TABLE tblEWTransDept
 ADD WinScribeDept INT
GO

CREATE TABLE [tblDoctorAuthor] (
  [DoctorCode] INTEGER NOT NULL,
  [EWTransDeptID] INTEGER NOT NULL,
  [EWAuthorID] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(15),
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblDoctorAuthor] PRIMARY KEY ([DoctorCode],[EWTransDeptID])
)
GO

insert into tbluserfunction (functioncode, functiondesc)
 select 'DoctorAssignAuthorID', 'Doctor - Assign Author ID'
 where not exists (select functionCode from tblUserFunction where functionCode='DoctorAssignAuthorID')

GO

insert into tbluserfunction (functioncode, functiondesc)
 select 'DoctorViewAuthorID', 'Doctor - View Author ID'
 where not exists (select functionCode from tblUserFunction where functionCode='DoctorViewAuthorID')

GO

UPDATE tblControl SET DBVersion='1.85'
GO
