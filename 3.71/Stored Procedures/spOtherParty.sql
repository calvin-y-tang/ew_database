CREATE PROCEDURE [dbo].[spOtherParty]
AS SELECT     dbo.tblDoctor.*
FROM         dbo.tblDoctor
WHERE     (OPType = 'OP')
ORDER BY companyname
