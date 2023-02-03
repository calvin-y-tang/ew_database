CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_PatchData]
	@startDate Date,
	@endDate Date	
AS

UPDATE T 
	set T.[EHQ-Rcvd] = [dbo].[fnGetParamValue](CD.Param, 'EHQReceived=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[EHQ-Sent] = [dbo].[fnGetParamValue](CD.Param, 'EHQSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARecommend] = [dbo].[fnGetParamValue](CD.Param, 'TMHARecommend=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARequestSent] = [dbo].[fnGetParamValue](CD.Param, 'TMHARequestSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHAService] = [dbo].[fnGetParamValue](CD.Param, 'TMHAService=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GPContactDate] = [dbo].[fnGetParamValue](CD.Param, 'GPContactDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWDate] = [dbo].[fnGetParamValue](CD.Param, 'RTWDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Diagnosis] = (SELECT  STUFF((SELECT  ',' + icd.description from tblcase c with (nolock)
										left join tblICDCode icd with (nolock) on icd.Code in (icdcodea, icdcodeb, icdcodec,icdcoded,ICDCodeE,icdcodeF,icdcodeg,ICDCodeH,ICDCodeI, icdcodej,icdcodek,icdcodel)
										where c.casenbr = t.casenbr
										FOR XML PATH('')), 1, 1, ''))
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWExplained] = [dbo].[fnGetParamValue](CD.Param, 'Comments=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARescheduled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHACancelled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr and ca.apptstatusid in (50,51)) --Cancelled or Late Cancelled
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

	
UPDATE T 
	set T.[TMHARescheduledDate] = (select top 1 ca.dateadded from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr  order by ca.dateadded desc)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Claims Received Date] = [dbo].[fnGetParamValue](CD.Param, 'ClaimReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GP Comm Fax Received] = [dbo].[fnGetParamValue](CD.Param, 'FaxReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'
Select
	Casenbr,
	[Service File Type],
	[Referral Date],
	CM,
	Surname,
	[First Name],
	Client,
	[Client Location],
	[Group Number],
	[Claim Number],
	isnull([Group or Employer],'') as 'Group or Employer',
	[Case Manager 1],
	[Disability Date],
	isnull(convert(varchar,[Claims Received Date],101),'') as [Claims Received Date],
	isnull([EHQ-Rcvd],'') as 'Scales In',
	isnull([EHQ-Sent],'') as 'Scales Out',

	isnull([TMHARecommend],'') as 'TMHA Recommend (Yes/No)',
	isnull([TMHARequestSent],'') as 'Service Request Date',
	isnull([TMHAService],'') as 'TMHA Date',
	case when [TMHARescheduled] > 1 then 'Yes' else 'No' end as 'TMHA Rescheduled',
	Case when [TMHACancelled] > 1 then 'Yes' else 'No' end as 'TMHA Cancelled',
	case when [TMHARescheduled] > 1 then isnull(convert(varchar,TMHARescheduledDate,101),'') else '' end  as 'TMHA Rescheduled Date',
	isnull(convert(varchar,[Final Sent],101),'') as 'Final Sent',
	isnull(Diagnosis,'') as Diagnosis,
	isnull([GP Contact],'') as 'GP Contact',
	isnull([GPContactDate],'') as 'Date GP Contact',
	isnull(Psychiatrist,'') as Psychiatrist,
	isnull(convert(varchar,[GP Comm Fax Received],101),'') as 'GP Comm Fax Received',
	isnull([RTWDate],'') as RTWDate,
	isnull(RTWExplained,'') as RTWExplained,
	convert(varchar,ServiceFileModified,101) as 'Service File Last Modified'
from ##Temp_MedacaCases
order by [Referral Date]

IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases