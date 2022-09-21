-- Sprint 94

-- IMEC-13002 
-- Adding new status field with a default value of 0 to GPCompanyPrepay table 
-- Dev: Sam Chiang
alter table GPCompanyPrepay
add [Status] int null default ((0))
go

-- IMEC-13002 
-- Back filling the new status field with a default value of 0 in GPCompanyPrepay table 
-- Dev: Sam Chiang
update GPCompanyPrepay set [Status] = 0
go