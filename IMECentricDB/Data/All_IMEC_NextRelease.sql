-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 131

-- IMEC-14081 - data patch for Nationwide cases that sets a date for emails sent for cases that apply so they will not be sent again
UPDATE tblCase SET DateEmailSentForLateReport = '2024-03-01 00:00:00.000' 
WHERE CaseNbr IN
(
select C.CaseNbr
from tblCase AS C
left join tblclient as CL on C.ClientCode = CL.ClientCode
left join tblclient AS CLB on C.BillClientCode = CLB.ClientCode
left join tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
left join tblCompany AS COB on CLB.CompanyCode = COB.CompanyCode
left join tblServices AS S on c.ServiceCode = s.ServiceCode
left join tblEWServiceType AS ST on S.EWServiceTypeID = ST.EWServiceTypeID
where C.casetype = 10 and C.status not in (8,9) and (CO.ParentCompanyID = 34 or COB.ParentCompanyID = 34)  and c.RptSentDate is null
and (C.ApptDate <= '2024-02-29 00:00:00.000' OR C.DateMedsRecd <= '2024-02-29 00:00:00.000')
)

GO

