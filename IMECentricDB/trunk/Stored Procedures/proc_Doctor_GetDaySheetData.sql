
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
		distinct LocationCode, LocationOffice, DoctorOffice 
		into #daysheetdatanew 
	from (
		select 
			ca.CaseApptID as SchedCode,
			ca.DoctorCode ,            
			ca.LocationCode ,
			c.CaseNbr, 
			c.ExtCaseNbr, 
			c.OfficeCode,
			lo.OfficeCode as LocationOffice,
			dro.OfficeCode as DoctorOffice

		from tblcaseappt as ca with (nolock)
			inner join tblcase as c  with (nolock)on ca.caseapptid = c.caseapptid			
			left join tblcaseapptpanel as cap  with (nolock)on cap.caseapptid = c.caseapptid
			inner join tbldoctor as dr  with (nolock)on dr.doctorcode = isnull(ca.doctorcode, cap.doctorcode)
			inner join tbllocation as l  with (nolock)on ca.locationcode = l.locationcode
			inner join tbldoctoroffice as dro  with (nolock)on dr.doctorcode = dro.doctorcode
			inner join tbllocationoffice as lo  with (nolock)on lo.officecode = dro.officecode and lo.locationcode = l.locationcode			
			inner join tblapptstatus as aps  with (nolock)on aps.apptstatusid = ca.apptstatusid and ca.apptstatusid = 10

		where
			(cast(ca.ApptTime as date) >= @fromDate and cast(ca.ApptTime as date) <= @toDate)	
			and aps.Name = 'Scheduled'
			and (c.CaseType = (COALESCE(NULLIF(@casetype, '-1'), c.CaseType)) or c.CaseType is null)
			and ca.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), ca.DoctorCode))
			and ca.LocationCode = (COALESCE(NULLIF(@location, '-1'), ca.LocationCode))
	) x
	;

	select 
		x.*, 
		isnull(cpc.OfficeCode, c.OfficeCode) as OfficeCode, 
		isnull(cpc.CaseNbr, c.CaseNbr) as CaseNbr, 
		isnull(cpc.ExtCaseNbr, c.ExtCaseNbr) as ExtCaseNbr
		
		into #daysheetdata
	from (

		select 

			tblDoctorSchedule.SchedCode,		
			tblDoctorSchedule.DoctorCode,
			tblDoctorSchedule.LocationCode,		
			tblLocation.Location,
			(rtrim(tblLocation.Addr1 + ' ' + isnull(tblLocation.Addr2, '')) +  ', ' + tblLocation.City + ' ' + tblLocation.State + ' ' + tblLocation.Zip) as DoctorAddress,				
			tblDoctorSchedule.date as ApptDate,
			tblDoctorSchedule.StartTime as ApptDateTime,
			stuff(replace(right(convert(varchar(19), tblDoctorSchedule.StartTime, 0), 7), ' ', '0'), 6, 0, ' ') as ApptTime,		
			ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.Credentials, '') as DoctorName,		
			(case when ltrim(rtrim(tblDoctor.EmailAddr)) <> '' then ltrim(rtrim(tblDoctor.EmailAddr)) else null end) as DoctorEmail,		
			tblLocation.Phone as LocationPhone,
			tblLocation.Fax as LocationFax,
			tblLocation.ContactLast,
			tblLocation.ContactFirst,
			tblLocation.ExtName as LocationExtName,
			tblLocationOffice.OfficeCode as LocationOffice, 
			tblDoctorOffice.OfficeCode as DoctorOffice,
			tblDoctorSchedule.CaseNbr1,
			tblDoctorSchedule.CaseNbr2,
			tblDoctorSchedule.CaseNbr3,
			tblDoctorSchedule.CaseNbr4,
			tblDoctorSchedule.CaseNbr5,
			tblDoctorSchedule.CaseNbr6

		FROM tblDoctorSchedule with (nolock)
			inner join tblDoctor with (nolock) on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
			inner join tblLocation with (nolock) on tblDoctorSchedule.LocationCode = tblLocation.LocationCode 
			inner join tblDoctorOffice with (nolock) on tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
			inner join tblLocationOffice with (nolock) on tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode	

		WHERE 					
			(tblDoctorSchedule.date >= @fromDate and tblDoctorSchedule.date <= @toDate)			
			and tblDoctorSchedule.Status = 'Scheduled'		
			and tblDoctorSchedule.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), tblDoctorSchedule.DoctorCode))
			and tblDoctorSchedule.LocationCode = (COALESCE(NULLIF(@location, '-1'), tblDoctorSchedule.LocationCode))

	) x
		left outer join tblCasePanel cp with (nolock) 
			join tblCase cpc with (nolock) on cp.PanelNbr = cpc.PanelNbr
			on cp.SchedCode = x.SchedCode and cpc.CaseNbr in (x.CaseNbr1, x.CaseNbr2, x.CaseNbr3, x.CaseNbr4, x.CaseNbr5, x.CaseNbr6)

		left outer join tblCase c with (nolock) on c.SchedCode = x.SchedCode and c.CaseNbr in (x.CaseNbr1, x.CaseNbr2, x.CaseNbr3, x.CaseNbr4, x.CaseNbr5, x.CaseNbr6)

	;

	with
	ddata as (

		select 
			distinct 
			SchedCode, OfficeCode, DoctorCode, LocationCode, Location, DoctorAddress, CaseNbr, ExtCaseNbr, ApptDate, ApptDateTime, ApptTime,  
			DoctorName, DoctorEmail, LocationPhone, LocationFax, ContactLast, ContactFirst, LocationExtName
		from #daysheetdata
		where 
		(1=1 and 
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

	)

	select 
		d.*,
		tblOffice.ShortDesc as OfficeName,
		tblExaminee.FirstName + ' ' + tblExaminee.LastName as Examinee,
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
		tblEWFacility.Logo as LogoURL
	from ddata d
			inner join tblCase with (nolock) on tblCase.CaseNbr = d.CaseNbr
			inner join tblClient with (nolock) on tblCase.ClientCode = tblClient.ClientCode
			inner join tblCompany with (nolock) on tblClient.CompanyCode = tblCompany.CompanyCode
			inner join tblOffice with (nolock) on tblCase.OfficeCode = tblOffice.OfficeCode
			inner join tblEWFacility with (nolock) on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
			inner join tblServices with (nolock) on tblCase.ServiceCode = tblServices.ServiceCode 
			inner join tblExaminee with (nolock) on tblCase.ChartNbr = tblExaminee.ChartNbr
			inner join tblCaseType with (nolock) on tblCase.CaseType = tblCaseType.Code		
			left outer join tblLanguage with (nolock) on tblLanguage.LanguageID = tblcase.LanguageID
	;

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

	if object_id('tempdb..#daysheetdatanew') is not null drop table #daysheetdatanew; 


end
go