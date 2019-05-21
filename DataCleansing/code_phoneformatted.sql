
with 
    cte_n1 (n) as (select 1 from (values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) n (n)), 
    cte_n2 (n) as (select 1 from cte_n1 a cross join cte_n1 b),     -- 100 rows
    cte_n3 (n) as (select 1 from cte_n2 a cross join cte_n2 b),     -- 10,000 rows
    cte_tally (n) as (
        select top 1000 -- set the number of row you wanr here...
            row_number() over (order by (select null))
        from
            cte_n3 a cross join cte_n3 b                            -- 100,000,000 rows
)
,
pd as (
    select 
        phoneformatted = '(' + stuff(stuff(pn.phonenumber, 7, 0, '-'), 4, 0, ') '),
		row_number() over (order by pn.phonenumber) as rn
    from
        cte_tally
        cross apply ( values (cast(abs(checksum(newid())) % 9999999999 + 1000000001 as varchar(14))) ) pn (phonenumber)
)
,
srcref as (
	select 
        VAR_KEYCOLNAME, 
        cast(rand(checksum(newid())) * 1000 as int) + 1 as rn
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
)

update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
    set VAR_COLNAME = z.phoneformatted
from VAR_DBINSTANCE.dbo.VAR_TABLENAME x with (nolock)
	left join srcref y with (nolock) on x.VAR_KEYCOLNAME = y.VAR_KEYCOLNAME
	left join pd z with (nolock) on y.rn = z.rn
;
