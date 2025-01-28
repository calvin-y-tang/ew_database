
if exists (select * from sysobjects where id = object_id('FK_tblCase_tblClient') ) 
  ALTER TABLE tblCase
  DROP CONSTRAINT [FK_tblCase_tblClient]
GO

if exists (select * from sysobjects where id = object_id('FK_tblCase_tblExaminee') ) 
  ALTER TABLE tblCase
  DROP CONSTRAINT [FK_tblCase_tblExaminee]
GO


ALTER TABLE [tblAcctingTrans]
  DROP CONSTRAINT [PK_tblacctingtrans]
GO

ALTER TABLE [tblAcctingTrans]
  ADD CONSTRAINT [PK_tblAcctingTrans] PRIMARY KEY CLUSTERED ([SeqNO])
GO


ALTER TABLE [tblCaseHistory]
  DROP CONSTRAINT [PK_casestatus]
GO

ALTER TABLE [tblCaseHistory]
  ADD CONSTRAINT [PK_tblCaseHistory] PRIMARY KEY CLUSTERED ([ID])
GO


ALTER TABLE [tblCaseSpecialty]
  ADD CONSTRAINT [PK_tblCaseSpecialty] PRIMARY KEY ([CaseSpecialtyID])
GO


ALTER TABLE [tblClient]
  DROP CONSTRAINT [PK_adjuster]
GO

ALTER TABLE [tblClient]
  ADD CONSTRAINT [PK_tblClient] PRIMARY KEY CLUSTERED ([ClientCode])
GO


ALTER TABLE [tblExaminee]
  DROP CONSTRAINT [PK_patient]
GO

ALTER TABLE [tblExaminee]
  ADD CONSTRAINT [PK_tblExaminee] PRIMARY KEY CLUSTERED ([ChartNbr])
GO


ALTER TABLE [tblFacility]
  DROP CONSTRAINT [PK_TblFacility]
GO

ALTER TABLE [tblFacility]
  ADD PRIMARY KEY CLUSTERED ([FacilityID])
GO


ALTER TABLE [tblIMEData]
  DROP CONSTRAINT [PK_IMEData]
GO

ALTER TABLE [tblIMEData]
  ADD CONSTRAINT [PK_tblIMEData] PRIMARY KEY CLUSTERED ([IMECode])
GO


ALTER TABLE [tblLocation]
  DROP CONSTRAINT [PK_location]
GO

ALTER TABLE [tblLocation]
  ADD CONSTRAINT [PK_tblLocation] PRIMARY KEY CLUSTERED ([LocationCode])
GO


ALTER TABLE [tblUser]
  DROP CONSTRAINT [PK_user]
GO

ALTER TABLE [tblUser]
  ADD CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED ([UserID],[UserType])
GO

ALTER TABLE [tblWebPasswordHistory]
  ADD CONSTRAINT [PK_tblWebPasswordHistory] PRIMARY KEY ([WebPasswordHistoryID])
GO

DELETE tblWebUserAccount
 FROM tblWebUserAccount AS wua
 INNER JOIN
(
SELECT WebUserID, UserType, UserCode
 FROM tblWebUserAccount
 GROUP BY WebUserID, UserType, UserCode
 HAVING COUNT(*)>1
) AS tmp ON tmp.UserType = wua.UserType AND tmp.WebUserID = wua.WebUserID AND tmp.UserCode=wua.UserCode
GO


DROP INDEX [tblWebUserAccount].[IdxtblWebUserAccount_BY_WebUserIDUserCodeUserType]
GO

DROP INDEX [tblWebUserAccount].[IdxtblWebUserAccount_BY_UserCodeUserTypeIsActive]
GO

ALTER TABLE [tblWebUserAccount]
  ALTER COLUMN [UserType] CHAR(2) NOT NULL
GO

if exists (select * from sysobjects where id = object_id('PK_tblWebUserAccount') ) 
  ALTER TABLE tblWebUserAccount
  DROP CONSTRAINT [PK_tblWebUserAccount]
GO

ALTER TABLE [tblWebUserAccount]
  ADD CONSTRAINT [PK_tblWebUserAccount] PRIMARY KEY CLUSTERED ([WebUserID],[UserCode],[UserType])
GO

CREATE NONCLUSTERED INDEX [IdxtblWebUserAccount_BY_UserCodeUserTypeIsActive] ON [tblWebUserAccount]([UserCode],[UserType],[IsActive])
GO


ALTER TABLE [tblCase] WITH NOCHECK
  ADD CONSTRAINT [FK_tblCase_tblExaminee] FOREIGN KEY ([ChartNbr]) REFERENCES [tblExaminee]([ChartNbr])
     ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [tblCase] WITH NOCHECK
  ADD CONSTRAINT [FK_tblCase_tblClient] FOREIGN KEY ([ClientCode]) REFERENCES [tblClient]([ClientCode])
     ON DELETE NO ACTION ON UPDATE NO ACTION
GO





UPDATE tblControl SET DBVersion='2.41'
GO
