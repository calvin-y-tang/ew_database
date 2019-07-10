CREATE PROCEDURE [proc_DoctorSchedulePortalCalendarMonth]  

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ApptDate, Service, Sum(CaseCount) CaseCount FROM
	(
	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(tblCase.casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION ALL

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(tblCase.casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCasePanel.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name
	)
	as sq group by sq.ApptDate, sq.Service, sq.CaseCount
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END