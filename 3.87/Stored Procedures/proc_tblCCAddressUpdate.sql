

CREATE PROCEDURE [proc_tblCCAddressUpdate]
(
 @cccode int,
 @prefix varchar(5) = NULL,
 @lastname varchar(50) = NULL,
 @firstname varchar(50) = NULL,
 @company varchar(70) = NULL,
 @address1 varchar(50) = NULL,
 @address2 varchar(50) = NULL,
 @city varchar(50) = NULL,
 @state varchar(2) = NULL,
 @zip varchar(15) = NULL,
 @phone varchar(15) = NULL,
 @phoneextension varchar(15) = NULL,
 @fax varchar(15) = NULL,
 @email varchar(70) = NULL,
 @status varchar(10) = NULL,
 @useridadded varchar(15) = NULL,
 @dateadded datetime = NULL,
 @useridedited varchar(15) = NULL,
 @dateedited datetime = NULL,
 @officecode int = NULL,
 @WebUserID int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCCAddress]
 SET
  [prefix] = @prefix,
  [lastname] = @lastname,
  [firstname] = @firstname,
  [company] = @company,
  [address1] = @address1,
  [address2] = @address2,
  [city] = @city,
  [state] = @state,
  [zip] = @zip,
  [phone] = @phone,
  [phoneextension] = @phoneextension,
  [fax] = @fax,
  [email] = @email,
  [status] = @status,
  [useridadded] = @useridadded,
  [dateadded] = @dateadded,
  [useridedited] = @useridedited,
  [dateedited] = @dateedited,
  [officecode] = @officecode,
  [WebUserID] = @WebUserID
 WHERE
  [cccode] = @cccode


 SET @Err = @@Error


 RETURN @Err
END


