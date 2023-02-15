CREATE PROCEDURE [proc_CasePeerBill_Insert]
(
	@PeerBillId int = NULL output,
	@CaseNbr int,
	@DateBillReceived datetime = NULL,
	@ServiceDate datetime = NULL,
	@BillNumber varchar(50) = NULL,
	@BillAmount money = NULL,
	@ReferringProviderName varchar(50) = NULL,
	@ReferringProviderTIN varchar(11) = NULL,
	@ProviderName varchar(50) = NULL,
	@ProviderTIN varchar(11) = NULL,
	@ProviderSpecialtyCode varchar(500) = NULL,
	@ServiceRendered varchar(250) = NULL,
	@CPTCode varchar(50) = NULL,
	@BillAmountApproved money = NULL,
	@BillAmountDenied money = NULL,
	@DateAdded datetime = NULL,
	@UserIDAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(15) = NULL,
	@ProviderZip varchar(10) = NULL,
	@ServiceEndDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCasePeerBill]
 (
	[CaseNbr],
	[DateBillReceived],
	[ServiceDate],
	[BillNumber],
	[BillAmount],
	[ReferringProviderName],
	[ReferringProviderTIN],
	[ProviderName],
	[ProviderTIN],
	[ProviderSpecialtyCode],
	[ServiceRendered],
	[CPTCode],
	[BillAmountApproved],
	[BillAmountDenied],
	[DateAdded],
	[UserIDAdded],
	[DateEdited],
	[UserIDEdited],
	[ProviderZip],
	[ServiceEndDate]
 )
 VALUES
 (
	@CaseNbr,
	@DateBillReceived,
	@ServiceDate,
	@BillNumber,
	@BillAmount,
	@ReferringProviderName,
	@ReferringProviderTIN,
	@ProviderName,
	@ProviderTIN,
	@ProviderSpecialtyCode,
	@ServiceRendered,
	@CPTCode,
	@BillAmountApproved,
	@BillAmountDenied,
	@DateAdded,
	@UserIDAdded,
	@DateEdited,
	@UserIDEdited,
	@ProviderZip,
	@ServiceEndDate
 )

 SET @Err = @@Error

 SELECT @PeerBillId = SCOPE_IDENTITY()

 RETURN @Err
END