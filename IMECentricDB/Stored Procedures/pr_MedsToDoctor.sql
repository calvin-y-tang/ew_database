USE [IMECentricEW]
GO

/****** Object:  StoredProcedure [dbo].[pr_MedsToDoctor]    Script Date: 10/6/2024 3:35:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Doug Leveille
-- Create date: 2024-09-03
-- Description:	This stored procedure will generate a list of cases to publish med records to the portal for doctors

-- DML 09/26/2024 Added CaseType of Third Party (20) and Workers Comp (140)


-- =============================================
CREATE PROCEDURE [dbo].[pr_MedsToDoctor] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Temp_Cases') IS NOT NULL DROP TABLE #Temp_Cases
	--use IMECentricEW

	select
	c.Casenbr,
	o.description as Office,
	co.intname as Company,
	ct.description as CaseType,
	s.description as Service,
	q.statusdesc as Queue,
	d.FirstName,
	d.LastName,
	c.ApptDate,
		-- if doctor has days in advance to receive med recs on doctor profile, use that, otherwise use 10 calendar days
	case when d.DrMedRecsInDays > 0 then  getdate() + d.DrMedRecsInDays else getdate() + 10 end as SelectDate

	into #temp_cases
	from tblCase c with (nolock)
	inner join tblCaseAppt ca with (nolock) on ca.CaseApptID = c.CaseApptID
	inner join tbldoctor d with (nolock) on d.doctorcode = ca.doctorcode
	inner join tblWebUser wu with (nolock) on wu.IMECentricCode = d.doctorcode and wu.UserType = 'DR' and wu.StatusID = 1 --Active
	inner join tbloffice o with (nolock) on o.officecode = c.officecode
	inner join tblcasetype ct with (nolock) on ct.code = c.casetype
	inner join tblservices s with (nolock) on s.servicecode = c.servicecode
	inner join tblqueues q with (nolock) on q.statuscode = c.status
	inner join tblclient cl with (nolock) on cl.clientcode = c.clientcode
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	where
		c.OfficeCode in (26,28)  and -- Uniondale, Woodbury
		c.CaseType in (10,20,140) and -- First Party, Third Party, Workers Comp
		c.Status = 1130 and -- Meds To Doctor
		c.servicecode in (2070,4121,3290) -- Independent Medical Evaluation, Medical Examination, Re-Evaluation 

	select --top 10
	CaseNbr,
	Company,
	Office,
	CaseType,
	Service, 
	Queue,
	FirstName,
	LastName,
	convert(varchar,ApptDate,101) as ApptDate
	from #temp_cases T
	where 
		t.apptdate < t.SelectDate
	order by t.ApptDate

END
GO

