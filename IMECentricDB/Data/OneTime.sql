
-- Issue 12422 - added new integration for Liberty referrals with a required NY MCMC office

INSERT INTO IMECentricMaster.dbo.ISExtIntegration
 (ExtIntegrationID, Name, Type, Active, SrcPath, DestPath, Param)
VALUES (3020,'LibertyXML NY-MCMC', 'LibertyXML', 1, '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\XMLInput_MCMC',
 '\\dev4.ew.domain.local\ISIntegrations\ERP\Liberty\New\',
 'DBID=23;UnknownClientCode=791347;ParentCompanyID=31;DefaultOfficeCode=28;Tags=UseMCMCOffice')

 GO


 -- Issue 12441 - changes to ExtIntegrations for automatic fee quote distributions - new input parameters
  update ISExtIntegration set Param = 'DBID=23;PCID=4;AttachQuote=true;ActiveCasesOnly=true;InNetworkQuotes=false;Subject=Second Request - %ClaimNbr% - %ExamineeName% IME Quote;Body=Dear %ClientFirstName%,<br /><br />This is a second request for the quote approval originally sent to you on %CaseDocDateAdded%. <br /><br />This request will serve as acknowledgement and approval of the quote (attached). <br /><br />If you have any questions, please contact our office at %OfficePhone%'
  where ExtIntegrationID = 6000

  GO

  insert into ISExtIntegration (ExtIntegrationID, Name, Type, Active, NotifyEmail, Param)
  Values (6001, 'Hartford Fee Quote Dist', 'FeeQuoteDist', 1, 'terri.lyde@examworks.com',
  'DBID=23;PCID=30;AttachQuote=true;ActiveCasesOnly=true;Subject=Second Request - %ClaimNbr% - %ExamineeName% IME Quote;Body=Dear %ClientFirstName%,<br /><br />This is a second request for the quote approval originally sent to you on %CaseDocDateAdded%. <br /><br />This request will serve as acknowledgement and approval of the quote (attached). <br /><br />If you have any questions, please contact our office at %OfficePhone%')

  GO


