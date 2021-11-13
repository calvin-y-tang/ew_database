PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [VendorGPEntityPrefix] VARCHAR (3) NULL;


GO

UPDATE tblControl SET VendorGPEntityPrefix=FacilityID
GO



PRINT N'Altering [dbo].[vwDoctorSchedule]...';


GO
ALTER VIEW vwDoctorSchedule
AS
     select  tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films , 
			tblLocationOffice.OfficeCode as LocationOffice 
from tblDoctorSchedule 
	inner join tblDoctorOffice on tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
	inner join tblDoctor on tblDoctorOffice.DoctorCode = tblDoctor.DoctorCode	
	inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
	inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
	left outer join tblCase
		inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
		inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
		inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
		inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
		inner join tblCaseType on tblCase.CaseType = tblCaseType.Code
		left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID
	on tblDoctorSchedule.SchedCode = tblCase.SchedCode	
    UNION
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc , 
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode,			
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films , 
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule 
				inner join tblDoctorOffice on tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
				inner join tblDoctor on tblDoctorOffice.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
				inner join tblCasePanel on tblDoctorSchedule.SchedCode = tblCasePanel.SchedCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code		
					left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID			
				on tblCasePanel.PanelNbr = tblCase.PanelNbr
    WHERE   tblCase.PanelNbr IS NOT NULL
GO
PRINT N'Altering [dbo].[spRptFlashReport]...';


GO
ALTER PROCEDURE [dbo].[spRptFlashReport]
@Month int,
@Year int,
@sReport varchar (20) ,
@EWFacilityID int , 
@OfficeCode int 
AS 
if @sReport = 'CurrentBilled'
begin
set nocount on

create table #lineItems
(DocumentType varchar(2),
 DocumentNbr int not null,
 LineNbr int,
 Description varchar(100),
 ReportCategory varchar(25),
 Revenue money not null,
 Expense money not null,
 ExtendedAmount money not null)

insert into #lineItems
select  tblAcctHeader.DocumentType,
        tblAcctHeader.DocumentNbr,
        tblAcctDetail.LineNbr,
        '',
        ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory,
        case when tblacctheader.documenttype = 'IN'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Revenue,
        case when tblacctheader.documenttype = 'VO'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Expense,
        isnull(tblacctdetail.ExtendedAmount, 0) as ExtendedAmount
from    tblAcctHeader
        inner join tblAcctDetail on tblAcctHeader.HeaderID = tblAcctDetail.HeaderID
        left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
        left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType
                                         and TblAcctDetail.prodcode = tblFRCategory.ProductCode
        left outer JOIN tblEWFlashCategory ON tblFRCategory.EWFlashCategoryID = tblEWFlashCategory.EWFlashCategoryID
where   ( tblAcctHeader.documentstatus = 'Final' )
        and ( tblAcctHeader.EWFacilityID = @EWFacilityID
              or @EWFacilityID = -1
            )
        and month(tblAcctHeader.DocumentDate) = @month
        and year(tblAcctHeader.DocumentDate) = @year 
		and dbo.tblCase.OfficeCode = @OfficeCode  

select ReportCategory, sum(FRUnits)as sumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin from 
(
select
  ReportCategory,
  case
    when (select count(*) from #lineItems as counter
   where counter.DocumentType=#lineItems.DocumentType
   and counter.DocumentNbr=#lineItems.DocumentNbr
   and counter.ReportCategory=#lineItems.ReportCategory
   and counter.LineNbr<=#lineItems.LineNbr) = 1 then
      case  
        when DocumentType = 'IN' then
          case when ExtendedAmount < 0 then -1 else 1 end
        else 0
      end
    else 0 
  end as FRUnits,
  Revenue, Expense,
  case
    when DocumentType = 'IN' then ExtendedAmount
    else -ExtendedAmount
  end as Amount
from #lineItems
) as lines
group by ReportCategory
order by ReportCategory

drop table #lineItems

end

if @sReport = 'CurrentScheduled'
begin
SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
     ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
					left outer join (select MIN(tp.ProdCode) AS ProdCode, tp.Description as ProdDesc, po.OfficeCode
                                     FROM tblProduct as tp
								     inner join tblProductOffice as po on tp.ProdCode = po.ProdCode
									 GROUP BY tp.Description, po.OfficeCode
                     ) as PTO on tblCase.OfficeCode = PTO.OfficeCode and tblServices.Description = PTO.ProdDesc
					left outer join tblFRCategory as FRC on tblcase.CaseType = FRC.CaseType and PTO.ProdCode = FRC.ProductCode
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON FRC.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
     
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year 
					AND dbo.tblCase.OfficeCode = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

end

if @sReport = 'FutureScheduled'
begin
if @month = 12 begin
 select @month = 1
 select @year = @year + 1
end
else
begin
 select @month = @month + 1
end

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
					left outer join (select MIN(tp.ProdCode) AS ProdCode, tp.Description as ProdDesc, po.OfficeCode
                                     FROM tblProduct as tp
								     inner join tblProductOffice as po on tp.ProdCode = po.ProdCode
									 GROUP BY tp.Description, po.OfficeCode
                     ) as PTO on tblCase.OfficeCode = PTO.OfficeCode and tblServices.Description = PTO.ProdDesc
					left outer join dbo.tblFRCategory on tblCase.CaseType = tblFRCategory.CaseType and PTO.ProdCode = tblFRCategory.ProductCode
					AND dbo.tblFRCategory.ProductCode = PTO.prodcode AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
					and dbo.tblOffice.OfficeCode  = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

end
GO

UPDATE tblControl SET DBVersion='2.92'
GO
