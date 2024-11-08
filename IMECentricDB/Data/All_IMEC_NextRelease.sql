-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 142
-- IMEC-14425 - No Show Letter template based on number of no show appts for case
     INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
     VALUES (137, 'NoShowTemplateToUse', 'Case', 'Determine No Show Template to use for a case based on the # of no shows', 1, 1107, 0, 'MinNoShowApptCnt', 'MaxNoShowApptCnt', 'NoShowDocument', NULL, NULL, 0, NULL)
     GO

     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (137, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, '1', '1', 'AllState1stNS', NULL, NULL, 0, NULL, 0),
            (137, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, NULL, NULL, 'AllState2ndNS', NULL, NULL, 0, NULL, 0)
    GO

-- imec-14490-voucher-form-changes
/****** Object:  UserDefinedFunction [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase] ******/
DROP FUNCTION [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase]
GO

/****** Object:  UserDefinedFunction [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase] (@CaseNbr int)
returns table
as
return (
	select sum(u.MedsIncoming) as MedsIncoming, sum(u.MedsToDoctor) as MedsToDoctor
	from (
		select mc.CaseNbr, isnull(Pages, 0) as MedsIncoming, 0 as MedsToDoctor
		from tblCase tc
		join tblCase mc on tc.MasterCaseNbr = mc.MasterCaseNbr
		join tblCaseDocuments tcd on mc.CaseNbr = tcd.CaseNbr
		where (
			tc.CaseNbr = @CaseNbr and MedsIncoming = 1
		)
		and (
			(mc.CaseNbr <>  @CaseNbr and tcd.SharedDoc = 1)
			or
			(mc.CaseNbr = @CaseNbr)
		)
		union
		select tc.CaseNbr, 0 as MedsIncoming, isnull(Pages, 0) as MedsToDoctor
		from tblCase tc
		join tblCaseDocuments tcd on tc.CaseNbr = tcd.CaseNbr
		where tc.CaseNbr = @CaseNbr and MedsToDoctor = 1 and tcd.SharedDoc = 0
	) u
);
GO

