use [VAR_DBINSTANCE];

if object_id('VAR_DBINSTANCE.dbo.DCTableFieldAction') is not null
drop table VAR_DBINSTANCE.dbo.DCTableFieldAction;

if object_id('VAR_DBINSTANCE.dbo.DCAction') is not null
drop table VAR_DBINSTANCE.dbo.DCAction;