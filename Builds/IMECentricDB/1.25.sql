
---------------------------------------------------------------------------------
--Add a new security token for setting marketer code on Company, Client and Case
---------------------------------------------------------------------------------

INSERT INTO tbluserfunction (functioncode, functiondesc)
 SELECT 'SetMarketer', 'Marketer - Set on Company, Client and Case'
 WHERE NOT EXISTS (SELECT functionCode FROM tblUserFunction WHERE functionCode='SetMarketer')

GO

---------------------------------------------------------------------------------
--Add a new column that will the effective marketer for case
--Use the client marketer code if it is set, otherwise use the marketer from company
---------------------------------------------------------------------------------

DROP VIEW [dbo].[vwclientdefaults]
go	
CREATE VIEW [dbo].[vwClientDefaults]
AS
SELECT     tblClient.marketercode AS clientmarketer, dbo.tblCompany.intname, dbo.tblClient.reportphone, dbo.tblClient.priority, dbo.tblClient.clientcode, 
                      dbo.tblClient.fax, dbo.tblClient.email, dbo.tblClient.phone1, dbo.tblClient.documentemail AS emailclient, dbo.tblClient.documentfax AS faxclient, 
                      dbo.tblClient.documentmail AS mailclient, dbo.tblClient.casetype, dbo.tblClient.feeschedule, dbo.tblCompany.credithold, dbo.tblCompany.preinvoice, 
                      dbo.tblClient.billaddr1, dbo.tblClient.billaddr2, dbo.tblClient.billcity, dbo.tblClient.billstate, dbo.tblClient.billzip, dbo.tblClient.billattn, 
                      dbo.tblClient.ARKey, dbo.tblClient.addr1, dbo.tblClient.addr2, dbo.tblClient.city, dbo.tblClient.state, dbo.tblClient.zip, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblClient.prefix AS clientprefix, dbo.tblClient.suffix AS clientsuffix, 
                      dbo.tblClient.lastname, dbo.tblClient.firstname, dbo.tblClient.billfax, dbo.tblClient.QARep, dbo.tblClient.photoRqd, dbo.tblClient.CertifiedMail, 
                      dbo.tblClient.PublishOnWeb, dbo.tblClient.UseNotificationOverrides, dbo.tblClient.CSR1, dbo.tblClient.CSR2, dbo.tblClient.AutoReschedule, 
                      dbo.tblClient.DefOfficeCode, ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer 
FROM         dbo.tblClient INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
GO


update tblControl set DBVersion='1.25'
GO