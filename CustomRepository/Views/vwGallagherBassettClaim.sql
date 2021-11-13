CREATE VIEW dbo.vwGallagherBassettClaim
AS
SELECT        dbo.GallagherBassettClaim.*, dbo.GallagherBassettClaimSupplemental.VendorID, dbo.GallagherBassettClaimSupplemental.ClaimNumber, dbo.GallagherBassettClaimSupplemental.InsurerCode, 
                         dbo.GallagherBassettClaimSupplemental.InsurerName, dbo.GallagherBassettClaimSupplemental.InsurerFEIN, dbo.GallagherBassettClaimSupplemental.InsurerZip, dbo.GallagherBassettClaimSupplemental.EmployerName, 
                         dbo.GallagherBassettClaimSupplemental.EmployerAddr1, dbo.GallagherBassettClaimSupplemental.EmployerAddr2, dbo.GallagherBassettClaimSupplemental.EmployerCity, 
                         dbo.GallagherBassettClaimSupplemental.EmployerState, dbo.GallagherBassettClaimSupplemental.EmployerZip, dbo.GallagherBassettClaimSupplemental.BenefitState AS Expr1, 
                         dbo.GallagherBassettClaimSupplemental.MPNFlag, dbo.GallagherBassettClaimSupplemental.MPNDate, dbo.GallagherBassettClaimSupplemental.JurisdictionClaimNumber, 
                         dbo.GallagherBassettClaimSupplemental.EmployerFEIN, dbo.GallagherBassettClaimSupplemental.ReportingLocation, dbo.GallagherBassettClaimSupplemental.NCCIPartOfBody, 
                         dbo.GallagherBassettClaimSupplemental.NCCINatureOfInjury, dbo.GallagherBassettClaimSupplemental.GBBranchNum, dbo.GallagherBassettClaimSupplemental.ReportToState, 
                         dbo.GallagherBassettClaimSupplemental.ClaimantIDType, dbo.GallagherBassettClaimSupplemental.ClaimantID, dbo.GallagherBassettClaimSupplemental.PolicyNumber, dbo.GallagherBassettClaimSupplemental.DOB, 
                         dbo.GallagherBassettClaimSupplemental.Gender, dbo.GallagherBassettClaimSupplemental.ClaimAdminName, dbo.GallagherBassettClaimSupplemental.ClaimAdminFEIN, dbo.GallagherBassettClaimSupplemental.OrgID, 
                         dbo.GallagherBassettClaimSupplemental.StateRptType, dbo.GallagherBassettClaimSupplemental.ClaimAdminZip, dbo.GallagherBassettClaimSupplemental.ClaimantPhone AS Expr2, 
                         dbo.GallagherBassettClaimSupplemental.ClaimAdminID, dbo.GallagherBassettClaimSupplemental.ClaimantCountryCode, dbo.GallagherBassettClaimSupplemental.EmployerCountryCode, 
                         dbo.GallagherBassettClaimSupplemental.TreatingPhyName, dbo.GallagherBassettClaimSupplemental.TreatingPhyLicense, dbo.GallagherBassettClaimSupplemental.TreatingPhyNPI, 
                         dbo.GallagherBassettClaimSupplemental.InsurerAddr1, dbo.GallagherBassettClaimSupplemental.InsurerAddr2, dbo.GallagherBassettClaimSupplemental.InsurerAddr3, dbo.GallagherBassettClaimSupplemental.InsurerCity, 
                         dbo.GallagherBassettClaimSupplemental.InsurerState, dbo.GallagherBassettClaimSupplemental.ClaimPK
FROM            dbo.GallagherBassettClaim INNER JOIN
                         dbo.GallagherBassettClaimSupplemental ON dbo.GallagherBassettClaim.PrimaryKey = dbo.GallagherBassettClaimSupplemental.ClaimPK