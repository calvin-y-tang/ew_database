CREATE VIEW vwCCs
AS
    SELECT  ccCode ,
            COALESCE(Company, LastName + ', ' + FirstName, LastName, FirstName) AS CompanyOrderDisplayName ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName) AS Contact ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName, Company) AS ContactOrderDisplayName ,
            Company ,
            City ,
            State ,
            Status,
			Email,
			Phone,
			Fax,
            Address1 + ' ' + City + ', ' + State + ' ' + zip AS Address
    FROM    tblCCAddress
