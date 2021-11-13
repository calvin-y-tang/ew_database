
-------------------------------------------------
--Schema changes for Doctor Search
-------------------------------------------------

Alter TABLE [dbo].[tblavailDoctor] add
                [SortDate] [datetime] NULL
go

Alter TABLE [dbo].[tblavailDoctor] add
                [SortProximity] [int] NULL
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwavailablepaneldrswithnotes]
AS
SELECT     TOP (100) PERCENT dbo.tblDoctor.notes, dbo.tblavaildoctor.*
FROM         dbo.tblavaildoctor INNER JOIN
                      dbo.tblDoctor ON dbo.tblavaildoctor.doctorcode = dbo.tblDoctor.doctorcode
ORDER BY dbo.tblavaildoctor.starttime, dbo.tblavaildoctor.location, dbo.tblavaildoctor.doctorname
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwavailabledoctorswithnotes]
AS
SELECT     TOP (100) PERCENT dbo.tblDoctor.notes, dbo.tblDoctor.usdmoney1, dbo.tblDoctor.usdmoney2, dbo.tblavaildoctor.*
FROM         dbo.tblavaildoctor INNER JOIN
                      dbo.tblDoctor ON dbo.tblavaildoctor.doctorcode = dbo.tblDoctor.doctorcode
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


-------------------------------------
--Web Portal Changes
-------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_getActiveCases]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_getActiveCases];
GO

CREATE PROCEDURE [proc_getActiveCases]
@WebUserID int

AS 

SELECT DISTINCT
	COUNT(DISTINCT CaseNbr) AS NbrofCases, 
	tblWebQueues.statuscode AS WebStatus, 
	tblWebQueues.description AS WebDescription, 
    tblWebQueues.displayorder
FROM tblCase
	INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
	INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
	INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
		AND tblPublishOnWeb.tabletype = 'tblCase'
		AND tblPublishOnWeb.PublishOnWeb = 1 
	INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
		AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType	
		AND tblWebUserAccount.WebUserID = @WebUserID
WHERE (tblCase.status <> 0)
GROUP BY 
	tblWebQueues.statuscode, 
	tblWebQueues.description, 
	tblWebQueues.displayorder
ORDER BY 
	tblWebQueues.displayorder
GO



update tblControl set DBVersion='1.43'
GO
