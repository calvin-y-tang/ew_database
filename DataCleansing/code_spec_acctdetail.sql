
declare 
    @rvExaminee varchar(100),
    @rvClaimNumber varchar(100),
    @rvalue varchar(200)
;

set @rvalue = 'VAR_REPLACEMENTVALUE';
set @rvExaminee = ltrim(rtrim(isnull(left(@rvalue, patindex('%,%', @rvalue) - 1), '')));
set @rvClaimNumber = ltrim(rtrim(isnull(substring(@rvalue, patindex('%,%', @rvalue)+1, len(@rvalue)),'')));

declare 
	@maxlen int,
	@ftype varchar(100)
;

select @ftype = d.name, @maxlen = c.max_length
from sys.objects a 
	inner join sys.schemas b on a.schema_id = b.schema_id 
	inner join sys.columns c on a.object_id = c.object_id
	inner join sys.types d on c.system_type_id = d.system_type_id
where a.type = 'U' and c.is_computed = 0
	and lower(a.name) = 'VAR_TABLENAME'
	and lower(c.name) = 'VAR_COLNAME'
	and d.name in ('char','nchar','nvarchar','varchar','text','ntext');


set rowcount 100000;

while (1 = 1)
begin
	begin transaction;

	

        if @ftype in ('text','ntext')	
        begin

            with 
            srcref as (
                select 
                    VAR_KEYCOLNAME, 
                    (left(VAR_COLNAME, patindex('%Examinee:%', VAR_COLNAME) + 8) 
                        + ' ' 
                        + @rvExaminee 
                        + ' ' 
                        + substring(VAR_COLNAME, patindex('%Claim#:%', VAR_COLNAME), 7) 
                        + ' ' 
                        + @rvClaimNumber
                        + ' ' 
                        + substring(VAR_COLNAME, patindex('%Annual Invoice%', VAR_COLNAME), len(VAR_COLNAME))) as val 
                from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
                where VAR_COLNAME is not null 
                    and ltrim(rtrim(VAR_COLNAME)) <> ''
                    and VAR_COLNAME not like ('VAR_REPLACEMENTVALUE%')
            )
            update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
                set VAR_COLNAME = x.val
            from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock)
                join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
            ;

        end
        else
        begin

            with 
            srcref as (
                select 
                    VAR_KEYCOLNAME, 
                    substring((left(VAR_COLNAME, patindex('%Examinee:%', VAR_COLNAME) + 8) 
                        + ' ' 
                        + @rvExaminee 
                        + ' ' 
                        + substring(VAR_COLNAME, patindex('%Claim#:%', VAR_COLNAME), 7) 
                        + ' ' 
                        + @rvClaimNumber
                        + ' ' 
                        + substring(VAR_COLNAME, patindex('%Annual Invoice%', VAR_COLNAME), len(VAR_COLNAME))), 1, @maxlen) as val
                from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
                where VAR_COLNAME is not null 
                    and ltrim(rtrim(VAR_COLNAME)) <> ''
                    and VAR_COLNAME not like ('VAR_REPLACEMENTVALUE%')
            )
            update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
                set VAR_COLNAME = x.val
            from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock)
                join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
            ;


        end

	if @@rowcount = 0
	begin
		commit transaction;
		break;
	end

	commit transaction;
end
set rowcount  0;
