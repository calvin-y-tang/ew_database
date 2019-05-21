
set rowcount 100000;

while (1 = 1)
begin
	begin transaction;

	
                with 
                srcref as (
                        select 
                                VAR_KEYCOLNAME, 
                                'This is a Note' as Notes,
                                'This is a Scheduling Note' as ScheduleNotes,
                                'This is a Special Instruction' as SpecialInstructions,
                                'This is a Attorney Note' as AttorneyNote,
                                'This is a Billing Note' as BillingNote,
                                'This is an Expert comments' as ExpertComments,
                                'This is a Recommendation' as Recommendation,
                                'This is a Litigation Note' as LitigationNotes,
                                'This is a Allegation' as Allegation
                        from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
                        where 
                                (Notes is not null and convert(varchar(max), Notes) <> 'This is a Note')
                                or (ScheduleNotes is not null and convert(varchar(max), ScheduleNotes) <> 'This is a Scheduling Note')
                                or (SpecialInstructions is not null and convert(varchar(max), SpecialInstructions) <> 'This is a Special Instruction')
                                or (AttorneyNote is not null and convert(varchar(max), AttorneyNote) <> 'This is a Attorney Note')
                                or (BillingNote is not null and convert(varchar(max), BillingNote) <> 'This is a Billing Note')
                                or (ExpertComments is not null and convert(varchar(max), ExpertComments) <> 'This is an Expert comments')
                                or (Recommendation is not null and convert(varchar(max), Recommendation) <> 'This is a Recommendation')
                                or (LitigationNotes is not null and convert(varchar(max), LitigationNotes) <> 'This is a Litigation Note')
                                or (Allegation is not null and convert(varchar(max), Allegation) <> 'This is a Allegation')
                )
                update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
                        set 
                                Notes = x.Notes,
                                ScheduleNotes = x.ScheduleNotes,
                                SpecialInstructions = x.SpecialInstructions,
                                AttorneyNote = x.AttorneyNote,
                                BillingNote = x.BillingNote,
                                ExpertComments = x.ExpertComments,
                                Recommendation = x.Recommendation,
                                LitigationNotes = x.LitigationNotes,
                                Allegation = x.Allegation
                from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock)
                        join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
                ;

	if @@rowcount = 0
	begin
		commit transaction;
		break;
	end

	commit transaction;
end
set rowcount  0;
