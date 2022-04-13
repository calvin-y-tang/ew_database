
-- Sprint 82

-- IMEC-11749 - TeamMembers security token and set URL for WebCompany
INSERT INTO tblUserFunction
VALUES('TeamMembers','Web Portal - Maintain Team Members', getDate())
GO
-- IMEC-11749
UPDATE tblWebCompany SET TeamMembersURL = 'https://portaladmin.examworks.com/login/tokenlogin?token=' 
GO
