
CREATE proc [dbo].[proc_Doctor_GetDaySheetData]
	@fromDate datetime,
	@toDate datetime,
	@office int,
	@casetype int, 
	@doctor int,
	@location int,
	@alloffices int,
	@usenewdata int,
	@userid varchar(15)
as
begin
	

	if @alloffices is null or @alloffices < 0
	begin
		set @alloffices = -1;
	end

	if @usenewdata is null or @usenewdata <= 0
	begin
		set @usenewdata = -1;
	end

	if @userid is null 
	begin
		set @userid = '';
	end

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

	if object_id('tempdb..#daysheetdatanew') is not null drop table #daysheetdatanew;   

	select 
		
		tblDoctorSchedule.SchedCode,		
		tblCase.OfficeCode,
		tblDoctorSchedule.DoctorCode,
		tblDoctorSchedule.LocationCode,
		tblOffice.ShortDesc as OfficeName,
		tblLocation.Location,
		(rtrim(tblLocation.Addr1 + ' ' + isnull(tblLocation.Addr2, '')) +  ', ' + tblLocation.City + ' ' + tblLocation.State + ' ' + tblLocation.Zip) as DoctorAddress,				
		tblCase.ExtCaseNbr as CaseNbr,
		tblDoctorSchedule.date as ApptDate,
		tblDoctorSchedule.StartTime as ApptDateTime,
		stuff(replace(right(convert(varchar(19), tblDoctorSchedule.StartTime, 0), 7), ' ', '0'), 6, 0, ' ') as ApptTime,
		tblExaminee.FirstName + ' ' + tblExaminee.LastName as Examinee,
		ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.Credentials, '') as DoctorName,
		
		(case when ltrim(rtrim(tblDoctor.EmailAddr)) <> '' then ltrim(rtrim(tblDoctor.EmailAddr)) else null end) as DoctorEmail,			

		tblLocation.Phone as LocationPhone,
		tblLocation.Fax as LocationFax,
		tblLocation.ContactLast,
		tblLocation.ContactFirst,
		tblLocation.ExtName as LocationExtName,
		tblCaseType.Description as CaseType,
		tblCaseType.ExternalDesc as CaseTypeShort,
		tblServices.Description as [Service],
		tblServices.ShortDesc as [ServiceShort],
		tblCase.DoctorSpecialty as Specialty,
		(tblServices.ShortDesc + ' / ' + tblCase.DoctorSpecialty) as ServiceSpecialty,		
		(case when tblCase.PhotoRqd is not null and tblCase.PhotoRqd = 1 then convert(bit, 1) else convert(bit, 0) end) as PhotoRequired,
		(case when tblCase.InterpreterRequired = 1 then 'Interpreter' else '' end) as Interpreter,
		(case when tblCase.LanguageID > 0 then tblLanguage.Description else '' end) as [InterpreterLanguage],
		(case when (select top 1 [Type] from tblRecordHistory with (nolock) where [Type] = 'F' and CaseNbr = tblCase.CaseNbr) = 'F' then 'Films' else '' end) as Comments,
		tblEWFacility.Logo as LogoURL,

		tblLocationOffice.OfficeCode as LocationOffice, 
		tblDoctorOffice.OfficeCode as DoctorOffice

		into #daysheetdata

	FROM tblDoctorSchedule with (nolock)
		inner join tblDoctor with (nolock) on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
		inner join tblLocation with (nolock) on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
		inner join tblDoctorOffice with (nolock) on tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
		inner join tblLocationOffice with (nolock) on tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode		
		left outer join tblCase with (nolock)
			inner join tblClient with (nolock) on tblCase.ClientCode = tblClient.ClientCode
			inner join tblCompany with (nolock) on tblClient.CompanyCode = tblCompany.CompanyCode
			inner join tblOffice with (nolock) on tblCase.OfficeCode = tblOffice.OfficeCode
			inner join tblEWFacility with (nolock) on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
			inner join tblServices with (nolock) on tblCase.ServiceCode = tblServices.ServiceCode 
			inner join tblExaminee with (nolock) on tblCase.ChartNbr = tblExaminee.ChartNbr
			inner join tblCaseType with (nolock) on tblCase.CaseType = tblCaseType.Code		
			left outer join tblLanguage with (nolock) on tblLanguage.LanguageID = tblcase.LanguageID			
			left outer join tblCasePanel with (nolock) on tblCasePanel.PanelNbr = tblCase.PanelNbr 
		on tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)

	WHERE 					
		(tblDoctorSchedule.date >= @fromDate and tblDoctorSchedule.date <= @toDate)			
		and tblCase.CaseNbr is not null
		and tblDoctorSchedule.Status = 'Scheduled'
		and (tblCase.CaseType = (COALESCE(NULLIF(@casetype, '-1'), tblCase.CaseType)) or tblCase.CaseType is null)
		and tblDoctorSchedule.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), tblDoctorSchedule.DoctorCode))
		and tblDoctorSchedule.LocationCode = (COALESCE(NULLIF(@location, '-1'), tblDoctorSchedule.LocationCode))
	;


	select distinct LocationCode, LocationOffice, DoctorOffice into #daysheetdatanew from (
		select 
			ca.CaseApptID as SchedCode,
			ca.DoctorCode ,            
			ca.LocationCode ,
			cast(cast(ca.ApptTime as date) as datetime) as ApptDate,
			ca.ApptTime as StartTime, 
			aps.Name as [Status],
			c.CaseNbr, 
			c.ExtCaseNbr, 
			c.OfficeCode,
			ee.FirstName + ' ' + ee.LastName as ExamineeName,
			co.ExtName as Company,
			cl.FirstName + ' ' + cl.LastName as ClientName,
			lo.OfficeCode as LocationOffice,
			l.Location,
			ewf.LegalName as CompanyName,
			isnull(dr.FirstName, '') + ' ' + isnull(dr.LastName, '') + ', ' + isnull(dr.Credentials, '') as DoctorName,
			dro.OfficeCode as DoctorOffice

		from tblcaseappt as ca
			inner join tblcase as c on ca.caseapptid = c.caseapptid
			inner join tblexaminee as ee on c.chartnbr = ee.chartnbr
			inner join tblclient as cl on c.clientcode = cl.clientcode
			inner join tblcompany as co on cl.companycode = co.companycode
			inner join tblcasetype as ct on c.casetype = ct.code		
			inner join tblservices as s on c.servicecode = s.servicecode 
			inner join tbloffice as o on c.officecode = o.officecode
			inner join tblewfacility as ewf on o.ewfacilityid = ewf.ewfacilityid
			left join tblcaseapptpanel as cap on cap.caseapptid = c.caseapptid
			inner join tbldoctor as dr on dr.doctorcode = isnull(ca.doctorcode, cap.doctorcode)
			inner join tbllocation as l on ca.locationcode = l.locationcode
			inner join tbldoctoroffice as dro on dr.doctorcode = dro.doctorcode
			inner join tbllocationoffice as lo on lo.officecode = dro.officecode and lo.locationcode = l.locationcode
			left join tbllanguage as la on la.languageid = c.languageid	
			inner join tblapptstatus as aps on aps.apptstatusid = ca.apptstatusid and ca.apptstatusid = 10

		where
			(cast(ca.ApptTime as date) >= @fromDate and cast(ca.ApptTime as date) <= @toDate)	
			and aps.Name = 'Scheduled'
			and (c.CaseType = (COALESCE(NULLIF(@casetype, '-1'), c.CaseType)) or c.CaseType is null)
			and ca.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), ca.DoctorCode))
			and ca.LocationCode = (COALESCE(NULLIF(@location, '-1'), ca.LocationCode))
	) x
	;

	
	

	select 

		distinct
		SchedCode, OfficeCode, DoctorCode, LocationCode, OfficeName, Location, DoctorAddress, CaseNbr, ApptDate, ApptDateTime, ApptTime, Examinee, 
		DoctorName, DoctorEmail, LocationPhone, LocationFax, ContactLast, ContactFirst, LocationExtName, CaseType, CaseTypeShort, Service, ServiceShort, Specialty, ServiceSpecialty,
		PhotoRequired, Interpreter, InterpreterLanguage, Comments, LogoURL
  
	from #daysheetdata
	where 1=1 
		and (

			--// favorites
			(
				1 = (case when @alloffices = 0 then 1 else 0 end) 
				and	OfficeCode in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
				and LocationOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid) 
				and DoctorOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
			)

			or

			----// default
			(
				2 = (case when @alloffices = -1 then 2 else 0 end) 
				and	OfficeCode = @office
				and LocationOffice = @office 
				and DoctorOffice = @office
			)

			or
			
			----// all offices
			(
				3 = (case when @alloffices = 1 then 3 else 0 end) 
				and LocationOffice = @office 
				and DoctorOffice = @office
				and (
					(1 = (case when @usenewdata = 1 then 0 else 1 end) and (LocationCode in (select distinct LocationCode from #daysheetdata x where LocationOffice = @office and DoctorOffice = @office and OfficeCode = @office)))
					or
					(1 = (case when @usenewdata = 1 then 1 else 0 end) and (LocationCode in (select distinct LocationCode from #daysheetdatanew x where  LocationOffice = @office and DoctorOffice = @office and OfficeCode = @office)))
				)						
			)


		)
	;

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

	if object_id('tempdb..#daysheetdatanew') is not null drop table #daysheetdatanew; 


end
go