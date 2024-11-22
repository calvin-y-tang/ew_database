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
		select tc.CaseNbr, tc.MasterCaseNbr
			, tc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, 0 as MedsIncoming, isnull(Pages, 0) as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
		join tblCaseDocuments tcd on tc.CaseNbr = tcd.CaseNbr
		where tc.CaseNbr = @CaseNbr and MedsToDoctor = 1
		union		
		select 	tc.CaseNbr
			, tc.MasterCaseNbr
			, mc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, isnull(Pages, 0) as MedsIncoming, 0 as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit
			, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
			join tblCase mc on  tc.CaseNbr = mc.CaseNbr --or tc.MasterCaseNbr = mc.MasterCaseNbr 
			join tblCaseDocuments tcd on mc.CaseNbr = tcd.CaseNbr
		where (tc.CaseNbr = @CaseNbr and MedsIncoming = 1)  and ((mc.CaseNbr <>  @CaseNbr and tcd.SharedDoc = 1) or (mc.CaseNbr = @CaseNbr))	
		union
		select 	tc.CaseNbr
			, tc.MasterCaseNbr
			, mc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, isnull(Pages, 0) as MedsIncoming, 0 as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit
			, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
			join tblCase mc on  tc.MasterCaseNbr = mc.MasterCaseNbr 
			join tblCaseDocuments tcd on mc.CaseNbr = tcd.CaseNbr
		where (tc.CaseNbr = @CaseNbr and MedsIncoming = 1)  and ((mc.CaseNbr <>  @CaseNbr and tcd.SharedDoc = 1) or (mc.CaseNbr = @CaseNbr))
	) u
);
GO
