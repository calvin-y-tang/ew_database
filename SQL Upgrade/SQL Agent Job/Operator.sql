USE [msdb]
GO

/****** Object:  Operator [DBA]    Script Date: 3/9/2020 5:04:02 PM ******/
EXEC msdb.dbo.sp_add_operator @name=N'DBA', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'calvin.tang@examworks.com', 
		@category_name=N'[Uncategorized]'
GO

/****** Object:  Operator [IME Centric Admins]    Script Date: 3/9/2020 5:04:02 PM ******/
EXEC msdb.dbo.sp_add_operator @name=N'IME Centric Admins', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'IMECentricAdminsDL@examworks.com', 
		@category_name=N'[Uncategorized]'
GO


