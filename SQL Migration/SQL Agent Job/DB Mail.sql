EXEC msdb.dbo.sp_configure @configname = 'show advanced options',
                           @configvalue = 1;
RECONFIGURE;
EXEC msdb.dbo.sp_configure @configname = 'Database Mail XPs',
                           @configvalue = 1;
RECONFIGURE;





EXECUTE msdb.dbo.sysmail_add_profile_sp @profile_name = 'DBA',
                                        @description = 'Database Administration Mail Account';

EXEC msdb.dbo.sysmail_add_account_sp @account_name = 'DBA',
                                     @email_address = 'donotreply@examworks.com',
                                     @display_name = 'IME Centric DBA Notification Service',
                                     @replyto_address = 'donotreply@examworks.com',
                                     @description = 'Database Admdbinistration Mail Account',
                                     @mailserver_name = 'internalopenrelay.examworks.local',
                                     @mailserver_type = 'SMTP',
                                     @port = '25',
                                     @username = NULL,
                                     @password = NULL,
                                     @use_default_credentials = 0,
                                     @enable_ssl = 0;

EXEC msdb.dbo.sysmail_add_profileaccount_sp @profile_name = 'DBA',
                                            @account_name = 'DBA',
                                            @sequence_number = 1;
