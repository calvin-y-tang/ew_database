CREATE PROCEDURE [dbo].[spRptDrDistribution]  @officecode int,
@fromdate datetime,
@todate datetime,
@company varchar (100),	
@DefAttny varchar (100)
AS
BEGIN
select doctorlocation, location, apptdate, tblcase.casenbr, tblcase.dateadded,doctorname, claimnbr, sinternalcasenbr,doctorspecialty, tbllocation.zip , tblexaminee.lastname + ', ' + tblexaminee.firstname as examineename,
isnull((select top 1 scountyname from tblzipcode where szip = tbllocation.zip),' Not Specified') as county , tblcompany.extname, tblccaddress.company as LawOffice
from tblcase
inner join tbllocation on locationcode = tblcase.doctorlocation
inner join tblexaminee on tblexaminee.chartnbr = tblcase.chartnbr
inner join tblclient on tblclient.clientcode = tblcase.clientcode
inner join tblcompany on tblcompany.companycode = tblclient.companycode
left outer join tblccaddress on tblccaddress.cccode = tblcase.defenseattorneycode
where 
(tblcase.officecode = @officecode or @officecode = -1) and 
(tblcase.dateadded >= CONVERT(VARCHAR(10),@fromdate,111) and tblcase.dateadded <= CONVERT(VARCHAR(10),@todate,111)) and
(tblcompany.extname like @Company or @company = '<All>') and 
(tblccaddress.company = @DefAttny or @DefAttny = '<All>') and
(tblcase.servicecode = 3)
order by county, doctorname, apptdate

end
