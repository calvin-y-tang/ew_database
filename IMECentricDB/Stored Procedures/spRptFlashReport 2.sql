CREATE PROCEDURE [dbo].[spRptFlashReport2]
@Month int,
@Year int,
@EWFacilityID int , 
@OfficeCode int ,
@runID varchar(50)
AS 

set nocount on

	DECLARE @Month2 INT
	DECLARE @Year2 INT
	DECLARE @dateMonthYear varchar(10)
	DECLARE @dateMonthYear2 varchar(10)
	DECLARE @sReportLabel varchar(15)
	DECLARE @sReportLabel2 varchar(15)


if @Month = 12 begin
 select @Month2 = 1
 select @Year2 = @Year + 1
end
else
begin
 select @Month2 = @Month + 1
end

set @dateMonthYear = CONVERT(varchar(4), @Year) + '/' + CONVERT(varchar(2), @Month) +'/01'
set @dateMonthYear2 = CONVERT(varchar(4), @Year2) + '/' + CONVERT(varchar(2), @Month2) +'/01'
set @sReportLabel = DATENAME(MONTH, @dateMonthYear) + ' ' + CONVERT(varchar(4), @Year)
set @sReportLabel2 = DATENAME(MONTH, @dateMonthYear2) + ' ' + CONVERT(varchar(4), @Year2)



Create table #lineItems
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

select ReportCategory, sum(FRUnits)as SumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin,
     'CurrentBilled' AS ReportType, 'Invoiced in ' + @sReportLabel AS ReportLabel, @runID AS runID from 
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


UNION ALL

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments, -1 AS SumRevenue, -1 AS SumExpense, -1 AS SumMargin, 'CurrentScheduled' AS ReportType, 'Forecasted for ' + @sReportLabel AS ReportLabel, @runID AS runID 
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

UNION ALL

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments,  -1 AS SumRevenue, -1 AS SumExpense, -1 AS SumMargin, 'FutureScheduled' AS ReportType, 'Forecasted for ' + @sReportLabel2 AS ReportLabel, @runID AS runID 
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
                    AND MONTH(dbo.tblcase.ForecastDate) = @month2
                    AND YEAR(dbo.tblcase.ForecastDate) = @year2
					and dbo.tblOffice.OfficeCode  = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

order by ReportType, ReportCategory

drop table #lineItems

