CREATE VIEW [dbo].[vwSLURequirementDetails_Verizon]
	AS 

	SELECT 
		ct.Code, 
		s.StateCode, 
		pe.ParentEmployer, 
		pe.EWParentEmployerID,
		pc.ParentCompanyID, 
		st.Name,
		c.IntName
		FROM 
			tblCaseType AS ct, tblState AS s, 
			tblEWParentEmployer AS pe, 
			tblEWParentCompany AS pc, 
			tblEWServiceType AS st,
			tblCompany AS c
			WHERE 
				ct.Code = 140 AND 
				s.StateCode in ('NY') AND 
				pe.EWParentEmployerID = 1 AND 
				pc.ParentCompanyID = 44 AND 
				st.Name = 'IME' AND
				c.IntName Like '%Verizon%'