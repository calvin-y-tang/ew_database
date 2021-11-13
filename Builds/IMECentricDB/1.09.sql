-- Update Database to ver. 1.09. Generated on 5/17/2010
exec sp_rename 'TblAcctDetail', 'tblAcctDetail'
GO
exec sp_rename 'TblAcctHeader', 'tblAcctHeader'
GO
exec sp_rename 'tblacctingtrans', 'tblAcctingTrans'
GO
exec sp_rename 'tblavaildoctor', 'tblAvailDoctor'
GO
exec sp_rename 'TblBatch', 'tblBatch'
GO
exec sp_rename 'tblbillstatus', 'tblBillStatus'
GO
exec sp_rename 'tblcasedefdocument', 'tblCaseDefDocument'
GO
exec sp_rename 'tblcaseissue', 'tblCaseIssue'
GO
exec sp_rename 'TblCaseOtherParty', 'tblCaseOtherParty'
GO
exec sp_rename 'tblcaseproblem', 'tblCaseProblem'
GO
exec sp_rename 'TblCaseTrans', 'tblCaseTrans'
GO
exec sp_rename 'tblclientdefdocument', 'tblClientDefDocument'
GO
exec sp_rename 'tblcompanyccEnvelope', 'tblCompanyccEnvelope'
GO
exec sp_rename 'tblcompanydefdocument', 'tblCompanyDefDocument'
GO
exec sp_rename 'tbldegree', 'tblDegree'
GO
exec sp_rename 'tbldoctordocuments', 'tblDoctorDocuments'
GO
exec sp_rename 'tblExamineecc', 'tblExamineeCC'
GO
exec sp_rename 'tblfeedetail', 'tblFeeDetail'
GO
exec sp_rename 'tblfeeheader', 'tblFeeHeader'
GO
exec sp_rename 'tblnameprefix', 'tblNamePrefix'
GO
exec sp_rename 'tblproblem', 'tblProblem'
GO
exec sp_rename 'tblproduct', 'tblProduct'
GO
exec sp_rename 'tblstate', 'tblState'
GO
exec sp_rename 'TblTaxTable', 'tblTaxTable'
GO
exec sp_rename 'tbluserdefined', 'tblUserDefined'
GO


update tblControl set DBVersion='1.09'
GO
