CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
AS

--
-- Hartford Data patching 
--

set nocount on 

Print 'Fixing up Company Names'

-- fix up the Company Names 
UPDATE hi SET hi.IntName = isnull(hm.NewOfficeName, hi.IntName), hi.LitOrAppeal = IIF(hm.IsLawOffice = 1, 'Litigation', 'NA')
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordOfficeMap as hm on hi.IntName = hm.CurrentOfficeName

Print 'Fixing up Specialties and Sub-Specialties'
-- fix up the specialities
UPDATE hi SET hi.Specialty = isnull(sm.NewSpecialtyName, hi.Specialty)
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordSpecialtyMap as sm on hi.Specialty = sm.CurrentSpecialtyName

-- fix up the sub-specialities
UPDATE hi SET hi.SubSpecialty = isnull(ssm.NewSpecialtyName, hi.SubSpecialty)
	from ##tmp_HartfordInvoices as hi
 	left outer join ##tmp_HartfordSubSpecialtyMap as ssm on hi.SubSpecialty = ssm.CurrentSpecialtyName
	
Print 'Fixing up Service Types'
UPDATE hi SET hi.ServiceType = CASE 
								WHEN hi.ServiceTypeID = 1 THEN 'IME'
								WHEN hi.ServiceTypeID = 2 THEN 'MRR'
								WHEN hi.ServiceTypeID = 3 THEN 'MRR'
								WHEN hi.ServiceTypeID = 4 THEN 'MRR'
								WHEN hi.ServiceTypeID = 5 THEN 'MRR'
								WHEN hi.ServiceTypeID = 6 THEN 'MRR'
								WHEN hi.ServiceTypeID = 7 THEN 'Other'
								WHEN hi.ServiceTypeID = 8 THEN 'Addendum - IME'
								WHEN hi.ServiceTypeID = 9 THEN 'Other'
								ELSE 'Other'
							  END
FROM ##tmp_HartfordInvoices as hi

Print 'Check for FCE services via Sub-Speciality'
UPDATE hi SET hi.ServiceType = CASE
								WHEN hi.SubSpecialty like '%FCE%' THEN 'FCE'
								ELSE hi.ServiceType
							   END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Line of Business'
UPDATE hi SET hi.LOB = CASE hi.LOB
						WHEN '1' THEN 'PL'
						WHEN '2' THEN 'PL'
						WHEN '3' THEN 'P&C'
						WHEN '4' THEN 'GBC'
						WHEN '5' THEN 'PL'
						ELSE ''
                       END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Coverage Types'
UPDATE hi SET hi.CoverageType = CASE 
									WHEN hi.CoverageType = 'Workers Comp' THEN 'WC'
									WHEN hi.CoverageType like '%auto%' THEN 'Auto'
									WHEN hi.CoverageType = 'Liability' THEN 'Auto'
									WHEN hi.CoverageType = 'Disability' THEN 'LTD'									
									ELSE 'Other'
								END
from ##tmp_HartfordInvoices as hi

Print 'Fixing up Network and Juris TAT'
UPDATE hi SET hi.InOutNetwork = CASE 
									WHEN hi.InOutNetwork = '1' THEN 'Out'
									WHEN hi.InOutNetwork = '2' THEN 'In'
									ELSE ''
								END,
		      hi.JurisTAT = CASE 
								WHEN hi.ServiceVariance > 0 THEN 'No'
								ELSE 'Yes'				
		                    END			  
FROM ##tmp_HartfordInvoices as hi

Print 'Set Service Variance to NULL (per the spec)'
UPDATE hi SET ServiceVariance = NULL 
  FROM ##tmp_HartfordInvoices as hi
  
Print 'Getting Exception Data'
UPDATE hi SET hi.PrimaryException = CASE 
									WHEN (SRD.DisplayOrder = 1 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
									ELSE ''
								 END,
			  hi.SecondaryException = CASE
									WHEN (SRD.DisplayOrder = 2 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
								    ELSE ''
								 END,
			  Comments = ISNULL(Comments, '') + ISNULL(SE.Descrip + ' ', '')

FROM ##tmp_HartfordInvoices as hi
	LEFT OUTER JOIN tblSLARule as SR on hi.SLARuleID = SR.SLARuleID
	LEFT OUTER JOIN tblSLARuleDetail as SRD on SR.SLARuleID = SRD.SLARuleID
	LEFT OUTER JOIN tblCaseSLARuleDetail as CSRD ON (hi.CaseNbr = CSRD.CaseNbr AND SRD.SLARuleDetailID = CSRD.SLARuleDetailID)
	LEFT OUTER JOIN tblSLAException as SE ON CSRD.SLAExceptionID = SE.SLAExceptionID
	

Print 'Update Primary and Secondary Exceptions'
UPDATE hi SET PrimaryDriver = CASE 
									WHEN hi.PrimaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.PrimaryException = 'CL' THEN 'Provider'
									WHEN hi.PrimaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.PrimaryException = 'NS' THEN 'Claimant'
									WHEN hi.PrimaryException = 'SA' THEN 'Provider'
									WHEN hi.PrimaryException = 'SR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'AR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'C' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'NA' THEN 'NA'
                                 END,
				SecondaryDriver = CASE 
									WHEN hi.SecondaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.SecondaryException = 'CL' THEN 'Provider'
									WHEN hi.SecondaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.SecondaryException = 'NS' THEN 'Claimant'
									WHEN hi.SecondaryException = 'SA' THEN 'Provider'
									WHEN hi.SecondaryException = 'SR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'AR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'C' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'NA' THEN 'NA'
                                 END
FROM ##tmp_HartfordInvoices as hi

-- return file result set
select * 
	from ##tmp_HartfordInvoices

set nocount off