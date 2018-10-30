
CREATE VIEW vwPDFLocationData
AS
    SELECT  LocationCode ,
			ExtName AS ServiceLocationName ,
            Addr1 AS ServiceLocationAddr1 ,
            Addr2 AS ServiceLocationAddr2 ,
            City AS ServiceLocationCity ,
            State AS ServiceLocationState ,
            Zip AS ServiceLocationZip ,
            City + ', ' + State + '  ' + Zip AS ServiceLocationCityStateZip ,

			B.BlankValueLong AS ServiceLocationFullAddress ,
			B.BlankValueLong AS ServiceLocationAddress ,

            Phone AS ServiceLocationPhone ,
            Phone AS ServiceLocationPhoneAreaCode ,
            Phone AS ServiceLocationPhoneNumber ,
            Fax AS ServiceLocationFax
    FROM    tblLocation
			LEFT OUTER JOIN tblBlank AS B ON 1=1
