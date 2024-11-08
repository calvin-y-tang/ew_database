-- imec-14490-voucher-form-changes
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
