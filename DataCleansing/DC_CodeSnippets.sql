--// random integer value between 12 and 6
select (floor(rand()*(12-6)+6));


--// generate 16 alphanumeric value with fix length
select left(replace(convert(varchar(255), newid()), '-', ''), 16)


--// generate 16 alphanumeric value with length between 6-12 characters
select left(replace(convert(varchar(255), newid()), '-', ''), (floor(rand()*(12-6)+6)))


--// random phone formatted generate
with 
    cte_n1 (n) as (select 1 from (values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) n (n)), 
    cte_n2 (n) as (select 1 from cte_n1 a cross join cte_n1 b),     -- 100 rows
    cte_n3 (n) as (select 1 from cte_n2 a cross join cte_n2 b),     -- 10,000 rows
    cte_tally (n) as (
        select top 1 -- set the number of row you wanr here...
            row_number() over (order by (select null))
        from
            cte_n3 a cross join cte_n3 b                            -- 100,000,000 rows
        )
select 
    phoneformatted = '(' + stuff(stuff(pn.phonenumber, 7, 0, '-'), 4, 0, ') ')
from
    cte_tally
    cross apply ( values (cast(abs(checksum(newid())) % 9999999999 + 1000000001 as varchar(14))) ) pn (phonenumber);



--// email partial - replace with alphnumeric to the left of the @ symbol in email
declare @email varchar(100) = 'sam.chiang@firstchoiceevaluations.com';
select lower(stuff(@email, 1, charindex('@', @email)-1, left(replace(cast(newid() as varchar(36)), '-', ''), (floor(rand()*(12-6)+6)))));


--// email generate
select 
    lower(
        (left(replace(convert(varchar(255), newid()), '-', ''), (floor(rand()*(8-4)+4)))) 
        + '@' 
        + left(replace(convert(varchar(255), newid()), '-', ''), (floor(rand()*(12-6)+6))) + '.com'
    );


--// ssn random generate
select 
    (cast(cast(100 + (898 * rand()) as int) as varchar(3)) 
    + '-' 
    + cast(cast(10 + (88 * rand()) as int) as varchar(2)) 
    + '-' 
    + cast(cast(1000 + (8998 * rand()) as int) as varchar(4)));



--// ssn partial masking
declare @ssn varchar(100) = '123-44-5567';
select (case when len(@ssn) = 11 and @ssn like '___-__-____' then '***-**-' + right(@ssn, 4) else null end);



--// detect valid email
with 
x as (
	select 'here is a bad email string in a note. test @abc.com is a bad email string.' as xx
	union all
	select 'here is a GOOD email string in a note. test@abc.com is a bad email string.' as xx
	union all
	select 'here is a another bad email string in a note. te@st@abc is a bad email string.' as xx
)
select xx ,
patindex('%[^a-z,0-9,@,.,_]%', replace(convert(varchar(max),xx)))
from x 
where 
	convert(varchar(max), xx) like '%_@__%.__%'
	
	--and patindex('%[^a-z,0-9,@,.,_]%', replace(convert(varchar(max),xx), '-', 'a')) = 0
;


--// detecting a valid ssn string in a body of text
with 
x as (
	select 'here is a bad ssn string in a note. 3344-44-3333 is a bad ssn string.' as xx
	union all
	select 'here is a GOOD ssn string in a note. 923-45-6666 is a bad ssn string.' as xx
	union all
	select 'here is a another bad ssn string in a note. 232-22-233-2 is a bad ssn string.' as xx
)
select 
	convert(varchar(max), xx) 
from x 
where xx is not null and (
	convert(varchar(max), xx) like '%000-__-____%'
	or convert(varchar(max), xx) like '%___-00-____%'
	or convert(varchar(max), xx) like '%___-__-0000%'
	or convert(varchar(max), xx) like '%666-__-____%'
	or convert(varchar(max), xx) like '%9[0-9][0-9]-__-____%'
	)
;


--// detecting a valid phone number string in a body of text
with 
x as (
	select 'here is a bad phone number string in a note. (716) 23-23422 is a bad phone number string.' as xx
	union all
	select 'here is a GOOD phone number string in a note. (716) 123-4567 is a bad phone number string.' as xx
	union all
	select 'here is a another GOOD phone number string in a note. 234-234-2342 is a bad phone number string.' as xx
)
select 
	convert(varchar(max), xx) 
from x 
where xx is not null and (
	convert(varchar(max), xx) like '%(___) ___-____%'
	or convert(varchar(max), xx) like '%___-___-____%'
	)
;