

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[fnGetRibbonXML]...';


GO
ALTER FUNCTION fnGetRibbonXML
(
	@startFromScratch BIT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	--To disable Ribbon Bar, return an empty string
	--RETURN ''

	DECLARE @xml VARCHAR(MAX)
	DECLARE @header VARCHAR(MAX)
	DECLARE @content VARCHAR(MAX)

	SET @header='<?xml version="1.0"?>
<customUI xmlns="http://schemas.microsoft.com/office/2006/01/customui" onLoad="Ribbon_OnLoad">

	<ribbon startFromScratch="false">

		<tabs>
%startFromScratch%

%content%

		</tabs>
	</ribbon>
</customUI>
'

	SET @content = '
<tab id="Tab_110000" getVisible="Ribbon_GetVisible" label="Home">
<group id="Grp_111000" getVisible="Ribbon_GetVisible" label="Main">
<button id="Btn_111100" getEnabled="Ribbon_GetEnabled" label="Tracker" getImage="Ribbon_GetImage" tag="None|Call_ToolbarTracker|File_Sherlock.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_111200" getEnabled="Ribbon_GetEnabled" label="SLA Monitor" getImage="Ribbon_GetImage" tag="SLAMonitor|Call_ToolbarSLAMonitor|Mso_SlideShowRehearseTimings" onAction="Ribbon_ButtonAction" size="large" />

<separator id="Spr_111300" />
<button id="Btn_111400" getEnabled="Ribbon_GetEnabled" screentip="Transcription Tracker" label="Transcription" getImage="Ribbon_GetImage" tag="TransTracker|Open_frmTranscriptionTracker|File_Headphones.png" onAction="Ribbon_ButtonAction" size="large" />

<splitButton id="Spb_111500" getEnabled="Ribbon_GetEnabled" tag="None|None|None" size="large">
<menu id="Mnu_111510" getEnabled="Ribbon_GetEnabled" tag="None|None|None" itemSize="large">
<button id="Btn_111511" getEnabled="Ribbon_GetEnabled" label="Confirmation" getImage="Ribbon_GetImage" tag="None|Call_ToolbarConfirmation|Mso_AutoDial" onAction="Ribbon_ButtonAction" />

<button id="Btn_111512" getEnabled="Ribbon_GetEnabled" label="Do Not Call" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsConfirmationDoNotCall|Mso_FilePermissionRestrictMenu" onAction="Ribbon_ButtonAction" />

</menu>
</splitButton>
<button id="Btn_111600" getEnabled="Ribbon_GetEnabled" label="File Manager" getImage="Ribbon_GetImage" tag="FileManager|Open_frmFileManager|File_File Manager.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_Scan" getEnabled="Ribbon_GetEnabled" screentip="Scan" label="Scanning" getImage="Ribbon_GetImage" tag="DefaultDisabled|Call_OpenCaseSearchForScanning|File_scanner.png" onAction="Ribbon_ButtonAction" size="large" />

<separator id="Spr_111800" />
<button id="Btn_111900" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Cases" label="New Case" getImage="Ribbon_GetImage" tag="None|Open_frmexamineeselection|File_Custom-Case.png" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_112000" getVisible="Ribbon_GetVisible" label="Search">
<labelControl id="Lbl_112101" getEnabled="Ribbon_GetEnabled" label="Case Nbr /" tag="None|None|None" />

<labelControl id="Lbl_112200" getEnabled="Ribbon_GetEnabled" label="Examinee" tag="None|None|None" />

<comboBox id="Cbx_CaseSearch" getEnabled="Ribbon_GetEnabled" tag="None|None|None" sizeString="1234567890123456" getItemCount="Ribbon_ComboBoxGetItemCount" getItemID="Ribbon_ComboBoxGetItemID" getItemLabel="Ribbon_ComboBoxGetItemLabel" onChange="Ribbon_ComboBoxOnChange" showLabel="false">
</comboBox>
<splitButton id="Spb_112400" getEnabled="Ribbon_GetEnabled" tag="None|None|None" size="large">
<button id="Btn_112410" getEnabled="Ribbon_GetEnabled" label="Case Search" getImage="Ribbon_GetImage" tag="None|Call_RibbonCaseSearch|File_Case Search.png" onAction="Ribbon_ButtonAction" />

<menu id="Mnu_112420" getEnabled="Ribbon_GetEnabled" tag="None|None|None" itemSize="large">
<button id="Btn_112421" getEnabled="Ribbon_GetEnabled" label="Advance Search" getImage="Ribbon_GetImage" tag="None|Call_OpenCaseSearch|File_Cases.png" onAction="Ribbon_ButtonAction" />

</menu>
</splitButton>
<separator id="Spr_112500" />
<button id="Btn_112600" getEnabled="Ribbon_GetEnabled" screentip="Search for Doctors" label="Doctor Search" getImage="Ribbon_GetImage" tag="None|Open_frmdoctorsearch|File_Custom-Doctor Search.png" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_113000" getVisible="Ribbon_GetVisible" label="Entity">
<button id="Btn_113100" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Companies" label="Company" getImage="Ribbon_GetImage" tag="None|Open_frmcompany|File_Company.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_113200" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Clients" label="Client" getImage="Ribbon_GetImage" tag="None|Open_frmclient|File_Man-Blue.png" onAction="Ribbon_ButtonAction" size="large" />

<splitButton id="Spb_113300" getEnabled="Ribbon_GetEnabled" tag="None|None|None" size="large">
<menu id="Mnu_113310" getEnabled="Ribbon_GetEnabled" tag="None|None|None" itemSize="large">
<button id="Btn_113311" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Doctors" label="Doctor" getImage="Ribbon_GetImage" tag="None|Open_frmdoctor|File_Custom-Doctor.png" onAction="Ribbon_ButtonAction" />

<button id="Btn_113312" getEnabled="Ribbon_GetEnabled" label="Open Doctor Schedule" getImage="Ribbon_GetImage" tag="MenuOpenDrSched|Open_frmOpenDrSchedule|File_Date-Time.png" onAction="Ribbon_ButtonAction" />

<button id="Btn_113313" getEnabled="Ribbon_GetEnabled" label="Reassign Doctor Schedule" getImage="Ribbon_GetImage" tag="None|Open_frmReAssignDoctor|Mso_AddOrRemoveAttendees" onAction="Ribbon_ButtonAction" />

</menu>
</splitButton>
<button id="Btn_113400" getEnabled="Ribbon_GetEnabled" label="Exam Location" getImage="Ribbon_GetImage" tag="None|Open_frmLocationMaintenance|File_EWFacility Groups.png" onAction="Ribbon_ButtonAction" size="large" />

<menu id="Mnu_113500" getEnabled="Ribbon_GetEnabled" label="Other" tag="None|Call_MMenuListsDoctorAssistant|None" itemSize="normal">
<button id="Btn_113510" getEnabled="Ribbon_GetEnabled" label="Doctor Assistant" tag="None|Call_MMenuListsDoctorAssistant|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113520" getEnabled="Ribbon_GetEnabled" label="Employer" tag="None|Call_MMenuListsEmployer|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113530" getEnabled="Ribbon_GetEnabled" label="Attorney/CC" tag="None|Open_frmAttorneyMaintenance|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113540" getEnabled="Ribbon_GetEnabled" label="Obtainment Facility" tag="None|Open_frmFacilityMaintenance|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113550" getEnabled="Ribbon_GetEnabled" label="Other Party" tag="None|Open_frmOtherParty|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113560" getEnabled="Ribbon_GetEnabled" label="Parent Company" tag="None|Call_MMenuListsParentCompany|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113570" getEnabled="Ribbon_GetEnabled" label="Transcription Group" tag="None|Open_FrmTranscription|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113580" getEnabled="Ribbon_GetEnabled" label="Medical Records" tag="None|Open_frmExamineeRecords|None" onAction="Ribbon_ButtonAction" />

</menu>
<menu id="Mnu_113600" getEnabled="Ribbon_GetEnabled" label="Merge" tag="None|Call_MMenuListsDoctorAssistant|None" itemSize="normal">
<button id="Btn_113610" getEnabled="Ribbon_GetEnabled" label="Company" tag="MergeCompany|Call_MMenuListsMergeToolsCompany|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113620" getEnabled="Ribbon_GetEnabled" label="Client" tag="MergeClient|Call_MMenuListsMergeToolsClient|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113630" getEnabled="Ribbon_GetEnabled" label="Attorney" tag="MergeAttorney|Call_MMenuListsMergeToolsAttorney|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113640" getEnabled="Ribbon_GetEnabled" label="Employer" tag="MergeEmployer|Call_MMenuListsMergeToolsEmployer|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113650" getEnabled="Ribbon_GetEnabled" label="Exam Location" tag="MergeExamLocation|Call_MMenuListsMergeToolsExamLocation|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_113660" getEnabled="Ribbon_GetEnabled" label="Examinee" tag="MergeExaminee|Call_MMenuListsMergeToolsExaminee|None" onAction="Ribbon_ButtonAction" />

</menu>
</group>
<group id="Grp_114000" getVisible="Ribbon_GetVisible" label="Office">
<toggleButton id="Tgb_114100" getEnabled="Ribbon_GetEnabled" label="Use Favorites" getImage="Ribbon_GetImage" tag="None|Call_MMenuChangeOffice|Mso_CustomActionsMenu" onAction="Ribbon_ToggleButtonAction" />

<labelControl id="Lbl_114200" getEnabled="Ribbon_GetEnabled" label="Current Office" tag="None|None|None" />

<dropDown id="Drp_SelectedOffice" getEnabled="Ribbon_GetEnabled" tag="None|Call_MMenuChangeOffice|None" sizeString="WWWWWWWWWWWWWWWW" getItemCount="Ribbon_DropdownGetItemCount" getItemID="Ribbon_DropdownGetItemID" getItemLabel="Ribbon_DropdownGetItemLabel" getSelectedItemIndex="Ribbon_DropdownGetSelectedItemIndex" onAction="Ribbon_DropdownOnAction" showLabel="false">
</dropDown>
</group>
<group id="Grp_115000" getVisible="Ribbon_GetVisible" label="Apps">
<button id="Btn_115100" getEnabled="Ribbon_GetEnabled" label="Info*Centric" getImage="Ribbon_GetImage" tag="None|Call_RunInfoCentric|File_InfoCentric.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_115200" getEnabled="Ribbon_GetEnabled" label="DICOM Extractor" getImage="Ribbon_GetImage" tag="DicomExtractor|Call_RunDicomExtractor|Mso_FilePackageForCD" onAction="Ribbon_ButtonAction" size="large" />

</group>
</tab>
<tab id="Tab_120000" getVisible="Ribbon_GetVisible" label="Maintenance">
<group id="Grp_121000" getVisible="Ribbon_GetVisible" label="Workflow">
<button id="Btn_121100" getEnabled="Ribbon_GetEnabled" label="Case Types" getImage="Ribbon_GetImage" tag="None|Open_frmcasetype|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121200" getEnabled="Ribbon_GetEnabled" label="Queues" getImage="Ribbon_GetImage" tag="None|Open_frmqueues|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121300" getEnabled="Ribbon_GetEnabled" label="Services" getImage="Ribbon_GetImage" tag="None|Open_frmservices|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121400" getEnabled="Ribbon_GetEnabled" label="Service Workflow" getImage="Ribbon_GetImage" tag="None|Open_frmServiceWorkflowList|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_122000" getVisible="Ribbon_GetVisible" label="Setup">
<menu id="Mnu_122100" getEnabled="Ribbon_GetEnabled" label="Confirmation" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122110" getEnabled="Ribbon_GetEnabled" label="System" showImage="false" tag="None|Call_MMenuListsConfirmationSetup|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122120" getEnabled="Ribbon_GetEnabled" label="Rule" showImage="false" tag="None|Call_MMenuListsConfirmationRule|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122130" getEnabled="Ribbon_GetEnabled" label="Message" showImage="false" tag="None|Call_MMenuListsConfirmationMessage|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122140" getEnabled="Ribbon_GetEnabled" label="Result" showImage="false" tag="None|Call_MMenuListsConfirmationResult|None" onAction="Ribbon_ButtonAction" />

</menu>
<menu id="Mnu_122200" getEnabled="Ribbon_GetEnabled" label="SLA" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122210" getEnabled="Ribbon_GetEnabled" label="Rule" showImage="false" tag="None|Call_MMenuListsSLADefinitionSLARule|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122220" getEnabled="Ribbon_GetEnabled" label="Exception" showImage="false" tag="None|Call_MMenuListsSLADefinitionSLAException|None" onAction="Ribbon_ButtonAction" />

</menu>
<menu id="Mnu_122300" getEnabled="Ribbon_GetEnabled" label="Doctor" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122310" getEnabled="Ribbon_GetEnabled" label="Degree" showImage="false" tag="NonNDB|Open_frmDegree|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122320" getEnabled="Ribbon_GetEnabled" label="Keyword" showImage="false" tag="None|Open_frmKeyWord|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122330" getEnabled="Ribbon_GetEnabled" label="Provider Types" showImage="false" tag="None|Open_frmProviderTypes|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122340" getEnabled="Ribbon_GetEnabled" label="Specialty" showImage="false" tag="NonNDB|Open_frmSpecialty|None" onAction="Ribbon_ButtonAction" />

</menu>
<button id="Btn_122400" getEnabled="Ribbon_GetEnabled" screentip="Define Exceptions" label="Exceptions" showImage="false" tag="None|Open_frmExceptionDefinition|None" onAction="Ribbon_ButtonAction" size="normal" />

<menu id="Mnu_122500" getEnabled="Ribbon_GetEnabled" label="Other" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122510" getEnabled="Ribbon_GetEnabled" label="Cancel Reason" showImage="false" tag="None|Call_MMenuListsSetupCancelReason|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122520" getEnabled="Ribbon_GetEnabled" label="Client Type" showImage="false" tag="None|Open_frmClientType|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122530" getEnabled="Ribbon_GetEnabled" label="DICOM Retention Rule" showImage="false" tag="None|Call_MMenuListsSetupDICOMRetentionRule|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122540" getEnabled="Ribbon_GetEnabled" label="ICD Code" showImage="false" tag="None|Open_frmICDCodes|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122550" getEnabled="Ribbon_GetEnabled" label="Issues" showImage="false" tag="None|Open_frmissues|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122560" getEnabled="Ribbon_GetEnabled" label="Other Party Type" showImage="false" tag="None|Open_frmOtherPartyType|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122570" getEnabled="Ribbon_GetEnabled" label="Problem" showImage="false" tag="None|Open_frmproblem|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_122580" getEnabled="Ribbon_GetEnabled" label="Standard Case History Note" showImage="false" tag="None|Open_frmStdCaseHistoryNotes|None" onAction="Ribbon_ButtonAction" />

</menu>
</group>
<group id="Grp_123000" getVisible="Ribbon_GetVisible" label="Document/Report">
<button id="Btn_123100" getEnabled="Ribbon_GetEnabled" label="Document Maintenance" getImage="Ribbon_GetImage" tag="None|Open_FrmDocumentMaintenance|Mso_FileSaveAsWordDocx" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_123150" getEnabled="Ribbon_GetEnabled" label="Dynamic Bookmark" showImage="false" tag="None|Open_frmBusRuleDynamicBookmark|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123200" getEnabled="Ribbon_GetEnabled" label="Med Record Action" showImage="false" tag="None|Open_frmRecordActions|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123300" getEnabled="Ribbon_GetEnabled" label="Med Record Status" showImage="false" tag="None|Open_frmRecordStatus|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123400" getEnabled="Ribbon_GetEnabled" label="Obtainment Type" showImage="false" tag="None|Open_frmObtainmentType|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123500" getEnabled="Ribbon_GetEnabled" label="Report Status Code" showImage="false" tag="None|Open_frmRptStatus|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_124000" getVisible="Ribbon_GetVisible" label="Web">
<button id="Btn_124100" getEnabled="Ribbon_GetEnabled" label="Portal User" getImage="Ribbon_GetImage" tag="None|Open_frmWebUser|File_Users-2.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_124200" getEnabled="Ribbon_GetEnabled" label="Queue" showImage="false" tag="None|Open_frmWebQueues|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124400" getEnabled="Ribbon_GetEnabled" screentip="Set Web Events to Automatically Publish" label="Event" showImage="false" tag="None|Open_frmWebEvents|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124500" getEnabled="Ribbon_GetEnabled" label="Version Rule" showImage="false" tag="None|Call_MMenuListsWebPortalWebVersionRule|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124600" getEnabled="Ribbon_GetEnabled" label="Office Contact" showImage="false" tag="WebOfficeContactsAddEdit|Call_MMenuListsWebPortalOfficeContact|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_125000" getVisible="Ribbon_GetVisible" label="Security">
<button id="Btn_125100" getEnabled="Ribbon_GetEnabled" label="User" getImage="Ribbon_GetImage" tag="None|Open_FrmUserSecurity|Mso_AccessOnlineLists" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_125200" getEnabled="Ribbon_GetEnabled" label="Group" showImage="false" tag="None|Open_frmusergroup|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_125300" getEnabled="Ribbon_GetEnabled" label="Function" showImage="false" tag="None|Open_FrmUserFunctions|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_125400" getEnabled="Ribbon_GetEnabled" label="Assignment" showImage="false" tag="None|Open_FrmGrpFunctions|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_126000" getVisible="Ribbon_GetVisible" label="Office">
<button id="Btn_126100" getEnabled="Ribbon_GetEnabled" screentip="Maintain Offices" label="Office" getImage="Ribbon_GetImage" tag="None|Open_frmOffice|File_EWFacility.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_126200" getEnabled="Ribbon_GetEnabled" label="Setup Information" getImage="Ribbon_GetImage" tag="None|Open_frmSetupInformation|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

</group>
</tab>
<tab id="Tab_140000" getVisible="Ribbon_GetVisible" label="Accounting">
<group id="Grp_141000" getVisible="Ribbon_GetVisible" label="Setup">
<button id="Btn_141200" getEnabled="Ribbon_GetEnabled" label="Fee Schedule V1" showImage="false" tag="ViewFeeSchedule|Open_frmFeeSchedule|None" onAction="Ribbon_ButtonAction" size="normal" />

<menu id="Mnu_141300" getEnabled="Ribbon_GetEnabled" label="Fee Schedule V2" tag="None|Call_MMenuListsAccountingFeeScheduleNetwork|None" itemSize="normal">
<button id="Btn_141310" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Network)" showImage="false" tag="None|Call_MMenuListsAccountingFeeScheduleNetwork|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_141320" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Company)" showImage="false" tag="ViewFeeScheduleCompany|Call_MMenuListsAccountingFeeScheduleCompany|None" onAction="Ribbon_ButtonAction" />

<button id="Btn_141330" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Office)" showImage="false" tag="ViewFeeScheduleOffice|Call_MMenuListsAccountingFeeScheduleOffice|None" onAction="Ribbon_ButtonAction" />

</menu>
<button id="Btn_141400" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Abeton)" showImage="false" tag="ViewFeeScheduleAbeton|Open_frmFeeScheduleAbeton|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141500" getEnabled="Ribbon_GetEnabled" label="Flash Report Setup" showImage="false" tag="None|Open_frmFlashReportSetup|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141600" getEnabled="Ribbon_GetEnabled" screentip="Product Maintenance" label="Products" showImage="false" tag="None|Open_frmProduct|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141700" getEnabled="Ribbon_GetEnabled" label="Quote Rule" showImage="false" tag="None|Call_MMenuListsAccountingQuoteRule|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141800" getEnabled="Ribbon_GetEnabled" label="Tax Exempt" showImage="false" tag="None|Call_MMenuListsTaxExemptCompanyEmployer|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141802" getEnabled="Ribbon_GetEnabled" label="Tax Tables" showImage="false" tag="None|Open_frmTaxTable|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141900" getEnabled="Ribbon_GetEnabled" label="Terms" showImage="false" tag="None|Open_frmTerms|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_142000" getVisible="Ribbon_GetVisible" label="Action">
<button id="Btn_142100" getEnabled="Ribbon_GetEnabled" label="Generate Corrected Invoice" getImage="Ribbon_GetImage" tag="None|Open_frmGenerateCorrectedInvoice|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_142200" getEnabled="Ribbon_GetEnabled" label="Re-Export Batch" getImage="Ribbon_GetImage" tag="None|Open_frmReExportBatch|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_142300" getEnabled="Ribbon_GetEnabled" label="Unfinalize Document" getImage="Ribbon_GetImage" tag="None|Open_frmunfinalizedocument|Mso_TableEffectsCellBevelGallery" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_143000" getVisible="Ribbon_GetVisible" label="Report/Export">
<button id="Btn_143300" getEnabled="Ribbon_GetEnabled" label="Flash Report" showImage="false" tag="None|Open_frmFlashReportParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143400" getEnabled="Ribbon_GetEnabled" label="Invoice Register" showImage="false" tag="None|Open_FrmInvoiceRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143500" getEnabled="Ribbon_GetEnabled" label="Voucher Register" showImage="false" tag="None|Open_FrmVoucherRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143600" getEnabled="Ribbon_GetEnabled" screentip="Print Fee Schedule Listing" label="Fee Schedule Listing" showImage="false" tag="None|Open_frmFeeSchedRptParam|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>
<tab id="Tab_150000" getVisible="Ribbon_GetVisible" label="Report">
<group id="Grp_151000" getVisible="Ribbon_GetVisible" label="Appointment">
<button id="Btn_151100" getEnabled="Ribbon_GetEnabled" label="Appointment Log" showImage="false" tag="None|Open_FrmApptLogParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151200" getEnabled="Ribbon_GetEnabled" screentip="Appointments on Hold Report" label="Appointments on Hold" showImage="false" tag="None|Open_frmApptOnHoldParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151400" getEnabled="Ribbon_GetEnabled" screentip="Run Cancelled Cases Report" label="Cancelled Appts" showImage="false" tag="None|Open_frmCancelCase|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151500" getEnabled="Ribbon_GetEnabled" label="Confirmation Result" showImage="false" tag="None|Call_MMenuReportsAppointmentConfirmationResult|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_152000" getVisible="Ribbon_GetVisible" label="Doctor">
<button id="Btn_152200" getEnabled="Ribbon_GetEnabled" label="Day Sheet" showImage="false" tag="None|Open_frmDaySheetParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152300" getEnabled="Ribbon_GetEnabled" label="Doctor Schedules" showImage="false" tag="None|Call_MMenuReportsDoctorRptDoctorsScheds|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152500" getEnabled="Ribbon_GetEnabled" label="Schedule Summary" showImage="false" tag="None|Open_FrmDoctorScheduleSummary|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_153000" getVisible="Ribbon_GetVisible" label="Export">
<button id="Btn_153100" getEnabled="Ribbon_GetEnabled" label="Export Data to Excel" showImage="false" tag="None|Open_frmExportParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_153200" getEnabled="Ribbon_GetEnabled" label="Export Liberty Data To Excel" showImage="false" tag="AMP88|Open_FrmLibertyExportParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_153300" getEnabled="Ribbon_GetEnabled" label="Export ATIC Data" showImage="false" tag="CustomATICExport|Call_MMenuListsExportATICData|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_154000" getVisible="Ribbon_GetVisible" label="Custom">

<button id="Btn_154300" getEnabled="Ribbon_GetEnabled" label="Progressive" showImage="false" tag="RptProgressiveRpts|Call_MMenuReportsProgressiveReports|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_154400" getEnabled="Ribbon_GetEnabled" label="Notification Report" showImage="false" tag="CustomMEIProgram|Open_frmMEINotificationParams|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>

</tab>
<tab id="Tab_ISOnly" getVisible="Ribbon_GetVisible" label="IS Only">
<group id="Grp_127000" getVisible="Ribbon_GetVisible" label="System">
<button id="Btn_127100" getEnabled="Ribbon_GetEnabled" label="Configuration" showImage="false" tag="ISOnly|Open_frmSystemConfiguration|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127200" getEnabled="Ribbon_GetEnabled" label="State/Province" showImage="false" tag="None|Open_frmStateMaintenance|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127300" getEnabled="Ribbon_GetEnabled" label="Non Work Days" showImage="false" tag="None|Open_frmNonWorkDays|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127500" getEnabled="Ribbon_GetEnabled" label="Folder Office Setup" showImage="false" tag="ISOnly|Open_frmFolderOffice|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127600" getEnabled="Ribbon_GetEnabled" label="Cover Letter Manager" showImage="false" tag="ISOnly|Call_MMenuToolsCoverLtrMgr|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127700" getEnabled="Ribbon_GetEnabled" label="Referral Assignment Rule" showImage="false" tag="ISOnly|Open_frmReferralAssignmentRule|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127800" getEnabled="Ribbon_GetEnabled" label="Referral Form Manager" showImage="false" tag="ISOnly|Call_MMenuToolsReferralFormMgr|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127900" getEnabled="Ribbon_GetEnabled" label="Referral Form Rule" showImage="false" tag="ISOnly|Call_MMenuToolsReferralFormRule|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>

'
	
	IF @startFromScratch = 1
		SELECT @xml = REPLACE(@header, '%startFromScratch%', '
		    <tab idMso="TabHomeAccess" visible="false" />
			<tab idMso="TabCreate" visible="false" />
			<tab idMso="TabExternalData" visible="false" />
			<tab idMso="TabDatabaseTools" visible="false" />
			<tab idMso="TabSourceControl" visible="false" />
			<tab idMso="TabAddIns" visible="false" />
')
	ELSE
		SELECT @xml = REPLACE(@header, '%startFromScratch%', '')

	SET @xml = REPLACE(@xml, '%content%', @content)

	RETURN @xml

END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_PatchData]
	@feeDetailOption Int
AS 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsExaminee

-- check if we need to add Exam Fee and Other Fee to result set
IF (@feeDetailOption = 1) 
BEGIN
  print 'Fee Detail Option 1 choosen ... linking in basic fee data'

  UPDATE GI SET 
	GI.FeeDetailExam = LI.FeeDetailExam, 
	GI.FeeDetailOther = LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		sum(case when tEWFC.Mapping6 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
		sum(case when tEWFC.Mapping6 = 'Other' or tEWFC.Mapping6 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
	 ) LI on GI.HeaderID = LI.HeaderID
END

-- check if we need to add all the fees to the result set
IF (@feeDetailOption = 2) 
BEGIN
  print 'Fee Detail Option 2 choosen ... linking in detailed fee data'

  UPDATE GI SET 	
	GI.FeeDetailExam		=		LI.FeeDetailExam,
	GI.FeeDetailExamUnit    =		LI.FeeDetailExamUnit,
	GI.FeeDetailBillReview	=		LI.FeeDetailBillReview,
	GI.FeeDetailBillRvwUnit =		LI.FeeDetailBillRvwUnit,
	GI.FeeDetailPeer		=		LI.FeeDetailPeer,
	GI.FeeDetailPeerUnit	=		LI.FeeDetailPeerUnit,
	GI.FeeDetailAdd			=		LI.FeeDetailAdd,
	GI.FeeDetailAddUnit		=		LI.FeeDetailAddUnit,
	GI.FeeDetailLegal		=		LI.FeeDetailLegal,
	GI.FeeDetailLegalUnit	=		LI.FeeDetailLegalUnit,
	GI.FeeDetailProcServ	=		LI.FeeDetailProcServ,
	GI.FeeDetailProvServUnit=		LI.FeeDetailProvServUnit,
	GI.FeeDetailDiag		=		LI.FeeDetailDiag,
	GI.FeeDetailDiagUnit	=		LI.FeeDetailDiagUnit,
	GI.FeeDetailNurseServ	=		LI.FeeDetailNurseServ,
	GI.FeeDetailPhone		=		LI.FeeDetailPhone,
	GI.FeeDetailMSA			=		LI.FeeDetailMSA,
	GI.FeeDetailClinical	=		LI.FeeDetailClinical,
	GI.FeeDetailTech		=		LI.FeeDetailTech,
	GI.FeeDetailMedicare	=		LI.FeeDetailMedicare,
	GI.FeeDetailOPO			=		LI.FeeDetailOPO,
	GI.FeeDetailRehab		=		LI.FeeDetailRehab,
	GI.FeeDetailAddRev		=		LI.FeeDetailAddRev,
	GI.FeeDetailAddRevUnit	=		LI.FeeDetailAddRevUnit,
	GI.FeeDetailTrans		=		LI.FeeDetailTrans,
	GI.FeeDetailTransUnit	=		LI.FeeDetailTransUnit,
	GI.FeeDetailMileage		=		LI.FeeDetailMileage,
	GI.FeeDetailMileageUnit	=		LI.FeeDetailMileageUnit,
	GI.FeeDetailTranslate	=		LI.FeeDetailTranslate,
	GI.FeeDetailTranslateUnit =		LI.FeeDetailTranslateUnit,
	GI.FeeDetailAdminFee	=		LI.FeeDetailAdminFee,
	GI.FeeDetailAdminFeeUnit=		LI.FeeDetailAdminFeeUnit,
	GI.FeeDetailFacFee		=		LI.FeeDetailFacFee,
	GI.FeeDetailOther       =		LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		    sum(case when tEWFC.Mapping4 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
			sum(case when tEWFC.Mapping4 = 'Exam' then tAD.Unit else 0 end) as FeeDetailExamUnit,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.ExtAmountUS else 0 end) as FeeDetailBillReview,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.Unit else 0 end) as FeeDetailBillRvwUnit,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.ExtAmountUS else 0 end) as FeeDetailPeer,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.Unit else 0 end) as FeeDetailPeerUnit,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.ExtAmountUS else 0 end) as FeeDetailAdd,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.Unit else 0 end) as FeeDetailAddUnit,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.ExtAmountUS else 0 end) as FeeDetailLegal,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.Unit else 0 end) as FeeDetailLegalUnit,			
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.ExtAmountUS else 0 end) as FeeDetailProcServ,
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.Unit else 0 end) as FeeDetailProvServUnit,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.ExtAmountUS else 0 end) as FeeDetailDiag,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.Unit else 0 end) as FeeDetailDiagUnit,
			sum(case when tEWFC.Mapping4 = 'Nurse Svc' then tAD.ExtAmountUS else 0 end) as FeeDetailNurseServ,
			sum(case when tEWFC.Mapping4 = 'Phone' then tAD.ExtAmountUS else 0 end) as FeeDetailPhone,
			sum(case when tEWFC.Mapping4 = 'MSA' then tAD.ExtAmountUS else 0 end) as FeeDetailMSA,
			sum(case when tEWFC.Mapping4 = 'Clinical' then tAD.ExtAmountUS else 0 end) as FeeDetailClinical,
			sum(case when tEWFC.Mapping4 = 'Tech' then tAD.ExtAmountUS else 0 end) as FeeDetailTech,
			sum(case when tEWFC.Mapping4 = 'Medicare' then tAD.ExtAmountUS else 0 end) as FeeDetailMedicare,
			sum(case when tEWFC.Mapping4 = 'OPO' then tAD.ExtAmountUS else 0 end) as FeeDetailOPO,
			sum(case when tEWFC.Mapping4 = 'Rehab' then tAD.ExtAmountUS else 0 end) as FeeDetailRehab,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.ExtAmountUS else 0 end) as FeeDetailAddRev,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.Unit else 0 end) as FeeDetailAddRevUnit,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.ExtAmountUS else 0 end) as FeeDetailTrans,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.Unit else 0 end) as FeeDetailTransUnit,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.ExtAmountUS else 0 end) as FeeDetailMileage,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.Unit else 0 end) as FeeDetailMileageUnit,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.ExtAmountUS else 0 end) as FeeDetailTranslate,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.Unit else 0 end) as FeeDetailTranslateUnit,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.ExtAmountUS else 0 end) as FeeDetailAdminFee,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.Unit else 0 end) as FeeDetailAdminFeeUnit,
			sum(case when tEWFC.Mapping4 = 'FacFee' then tAD.ExtAmountUS else 0 end) as FeeDetailFacFee,
			sum(case when tEWFC.Mapping4 = 'Other' or tEWFC.Mapping4 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
		) LI on GI.HeaderID = LI.HeaderID
END

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_GenericConfirmationsExaminee
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) EXGROUPS
	WHERE EXGROUPS.[ROW_NUM]  = 1
	ORDER BY EXGROUPS.CaseApptID

SELECT *
   INTO ##tmp_GenericConfirmationsAtty
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) ATYGROUPS
	WHERE ATYGROUPS.[ROW_NUM]  = 1
	ORDER BY ATYGROUPS.CaseApptID

-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'

-- update the main table with the most recent quote information
print 'Get Most recent FeeQuote for Case'
UPDATE gi SET gi.FeeQuoteAmount = CASE (ISNULL(gi.InvApptStatus, gi.ApptStatus))
									WHEN 'Late Canceled' THEN tbl.LateCancelAmt
									WHEN 'Canceled' THEN tbl.NoShowAmt
									WHEN 'No Show' THEN tbl.NoShowAmt
									WHEN 'Show' THEN 
										CASE
											WHEN tbl.ApprovedAmt IS NOT NULL THEN tbl.ApprovedAmt
											ELSE ISNULL(tbl.FeeAmtTo, tbl.FeeAmtFrom)
										END
									END,
	          gi.OutOfNetworkReason = tbl.OutOfNetworkReason
  FROM ##tmp_GenericInvoices  as gi
	INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY AQ.CaseNbr ORDER BY AQ.AcctQuoteID DESC) as ROWNUM,
					AQ.CaseNbr,
					CONVERT(VARCHAR(12), AQ.LateCancelAmt)	AS LateCancelAmt,
					CONVERT(VARCHAR(12), AQ.NoShowAmt)		AS NoShowAmt,		
					CONVERT(VARCHAR(12), AQ.FeeAmtFrom)		AS FeeAmtFrom,
					CONVERT(VARCHAR(12), AQ.FeeAmtTo)		AS FeeAmtTo,
					CONVERT(VARCHAR(12), AQ.ApprovedAmt)	AS ApprovedAmt,
					ISNULL(NR.Description, '')              AS OutOfNetworkReason
	              FROM tblAcctQuote as AQ 
					LEFT OUTER JOIN tblOutOfNetworkReason as NR on AQ.OutOfNetworkReasonID = NR.OutOfNetworkReasonID
			      WHERE AQ.QuoteType = 'IN') as tbl ON tbl.CaseNbr = gi.CaseNbr
				  WHERE tbl.ROWNUM = 1

-- custom Sedgwick handling for customer data values
print 'Custom Sedgwick Handling for Customer data values'
 UPDATE ginv SET 
		ginv.ClaimUniqueId		= dbo.fnGetParamValue(CD.[Param], 'ClaimUniqueId'),
		ginv.CMSClaimNumber		= dbo.fnGetParamValue(CD.[Param], 'CMSClaimNumber'),
		ginv.ShortVendorId		= dbo.fnGetParamValue(CD.[Param], 'ShortVendorId'),
		ginv.ProcessingOfficeId = dbo.fnGetParamValue(CD.[Param], 'OfficeNumber'),
		ginv.ReferralUniqueId	= dbo.fnGetParamValue(CD.[Param], 'ReferralUniqueId')
   FROM ##tmp_GenericInvoices as ginv
	    INNER JOIN tblCustomerData as CD on CD.TableType = 'tblCase' AND CD.TableKey = ginv.CaseNbr AND CD.CustomerName = 'Sedgwick CMS'
   WHERE ginv.ParentCompanyID = 44

-- get medrec page counts
print 'Get Medical Page Counts'
UPDATE geninv SET MedRecPages = IIF(ISNULL(tblCD.Pages, '') = '', 'N/A', CONVERT(VARCHAR(12), tblCD.Pages))
   FROM ##tmp_GenericInvoices as geninv
		INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY CD.CaseNbr ORDER BY CD.SeqNo DESC) as ROWNUM,
					CD.CaseNbr,
					CD.Pages
					FROM tblCaseDocuments as CD
					WHERE CD.Description like '%MedIndex%') as tblCD ON tblCD.CaseNbr = geninv.CaseNbr
		WHERE tblCD.ROWNUM = 1

-- addendum 
print 'Flag addendums'
UPDATE tmp SET tmp.AddendumNeeded = 1
  FROM ##tmp_GenericInvoices as tmp
where CaseNbr in (
select GI.MasterCaseNbr
	from ##tmp_GenericInvoices as GI
		inner join tblCase as C on (GI.MasterCaseNbr = C.CaseNbr) AND (C.DoctorCode = GI.DoctorID)
	where (GI.ServiceType = 'Addendum')
	  and ((GI.MasterCaseNbr is not null) and (GI.CaseNbr <> GI.MasterCaseNbr))
	  and (GI.CaseStatus <> 9)
)
UPDATE gi SET gi.AddendumNeeded = 0
  FROM ##tmp_GenericInvoices as gi
WHERE gi.AddendumNeeded IS NULL

-- return the main table
print 'return final query results'
SELECT * 
  FROM ##tmp_GenericInvoices
ORDER BY InvoiceNo

SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
AS 
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericInvoices') IS NOT NULL DROP TABLE ##tmp_GenericInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @xmlCompany XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
SET @xmlCompany = CAST('<X>' + REPLACE(@companyCodeList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;
print 'Company Code List: ' + @companyCodeList;

WITH SLADetailsCTE AS
(SELECT DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr
  FROM tblCaseSLARuleDetail as sla
LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID
LEFT OUTER JOIN tblSLARuleDetail as srd on sla.SLARuleDetailID = srd.SLARuleDetailID
LEFT OUTER JOIN tblTATCalculationMethod as tcm on srd.TATCalculationMethodID = tcm.TATCalculationMethodID
LEFT OUTER JOIN tblDataField as DF1 on tcm.StartDateFieldID = DF1.DataFieldID
LEFT OUTER JOIN tblDataField as DF2 on tcm.EndDateFieldID = DF2.DataFieldID
INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr
INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr
INNER JOIN tblClient as cli on cli.ClientCode = ah.ClientCode
INNER JOIN tblCompany as com on com.CompanyCode = cli.CompanyCode
WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0))
  AND (AH.DocumentType = 'IN'
  AND AH.DocumentStatus = 'Final'
  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)  
GROUP BY (DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr
)
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  C.MasterCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  COM.IntName as CaseCompanyInt,
  COM.ExtName as CaseCompanyExt,
  case when isnull(CLI.LastName, '') = '' then isnull(CLI.FirstName, '') else CLI.LastName+', '+isnull(CLI.FirstName, '') end as CaseClient,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  D.DoctorCode as DoctorID, 
  D.Zip as DoctorZip,
  CASE 
  WHEN c.PanelNbr IS NOT NULL THEN c.DoctorName 
  ELSE case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end
  END as Doctor, 
  C.DoctorReason,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  Inv.ClaimNbr as ClaimNo,
  C.SInternalCaseNbr as InternalCaseNbr,
  Inv.Examinee as Examinee,
  CASE ISNULL(C.EmployerID, 0)
    WHEN 0 THEN E.Employer
    ELSE EM.Name
  END AS Employer,
  E.DOB as "Examinee DOB",
  E.SSN as "Examinee SSN",
  O.ShortDesc as Office,
  EL.Location as ExamLocationName,
  EL.Addr1 as ExamLocationAddress1,
  EL.Addr2 as ExamLocationAddress2,
  EL.City as ExamLocationCity,
  EL.State as ExamLocationState,
  EL.Zip as ExamLocationZip,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  EWF.GPFacility as GPFacility,
  Inv.Finalized as DateFinalized,
  Inv.UserIDFinalized as UserFinalized,
  Inv.BatchNbr as GPBatchNo,
  Inv.ExportDate as GPBatchDate,
  BB.Descrip as BulkBilling,
  DOC.Description as InvoiceDocument,
  APS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CB.ExtName as CanceledBy,
  CA.Reason as CancelReason,
  isnull(Inv.ClientRefNbr, '') as ClientRefNo,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.Jurisdiction,
  EWIS.Name as InputSource,
  EWIS.Mapping1 as SedgwickSource,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  CA.DateAdded as ApptMadeDate,
  C.OrigApptTime as OrigAppt,
  ISNULL(inv.CaseApptID, c.CaseApptID) as CaseApptID,
  CA.ApptTime as [ApptDate],
  C.RptFinalizedDate,
  C.RptSentDate,    
  C.DateMedsRecd as DateMedsReceived,
  C.OCF25Date,
  c.TATAwaitingScheduling,  
  c.TATEnteredToAcknowledged,
  c.TATEnteredToMRRReceived,
  c.TATEnteredToScheduled,
  c.TATExamToClientNotified,
  c.TATExamToRptReceived,
  c.TATQACompleteToRptSent,
  c.TATReport, 
  c.TATRptReceivedToQAComplete,
  c.TATRptSentToInvoiced,
  c.TATScheduledToExam,
  c.TATServiceLifeCycle, 
  C.DateAdded as CaseDateAdded,
  Inv.CaseDocID,
  case
    when EWReferralType=0 then ''
    when EWReferralType=1 then 'Incoming'
    when EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  '' as CaseIssues,
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as TaxTotal,
  Inv.DocumentTotalUS-cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as Revenue,
  Inv.DocumentTotalUS as InvoiceTotal,
  isnull(VO.Expense, 0) as Expense,
  VO.VoucherCount as Vouchers,
  VO.VoucherDateMin as VoucherDate1,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMin as varchar(15)) as VoucherNo1,
  VO.VoucherDateMax as VoucherDate2,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMax as varchar(15)) as VoucherNo2,
  (select count(LI.LineNbr) from tblAcctDetail as LI where LI.HeaderID = Inv.HeaderID) as LineItems,
 STUFF((SELECT '; ' + SLAReason FROM SLADetailsCTE
    WHERE SLADetailsCTE.CaseNbr = inv.CaseNbr
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as SLAReasons,
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts,  
  CONVERT(MONEY, NULL) AS   FeeDetailExam,
  CONVERT(INT,   NULL) AS   FeeDetailExamUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailBillReview,
  CONVERT(INT,   NULL) AS   FeeDetailBillRvwUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailPeer,
  CONVERT(INT,   NULL) AS   FeeDetailPeerUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailAdd,
  CONVERT(INT,   NULL) AS   FeeDetailAddUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailLegal,
  CONVERT(INT,   NULL) AS   FeeDetailLegalUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailProcServ,
  CONVERT(INT,   NULL) AS   FeeDetailProvServUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailDiag,
  CONVERT(INT,   NULL) AS   FeeDetailDiagUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailNurseServ,
  CONVERT(MONEY, NULL) AS   FeeDetailPhone,
  CONVERT(MONEY, NULL) AS   FeeDetailMSA,
  CONVERT(MONEY, NULL) AS   FeeDetailClinical,
  CONVERT(MONEY, NULL) AS   FeeDetailTech,
  CONVERT(MONEY, NULL) AS   FeeDetailMedicare,
  CONVERT(MONEY, NULL) AS   FeeDetailOPO,
  CONVERT(MONEY, NULL) AS   FeeDetailRehab,
  CONVERT(MONEY, NULL) AS   FeeDetailAddRev,
  CONVERT(INT,   NULL) AS   FeeDetailAddRevUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailTrans,
  CONVERT(INT,   NULL) AS   FeeDetailTransUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailMileage,
  CONVERT(INT,   NULL) AS   FeeDetailMileageUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailTranslate,
  CONVERT(INT,   NULL) AS   FeeDetailTranslateUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailAdminFee,
  CONVERT(INT,   NULL) AS   FeeDetailAdminFeeUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailFacFee,
  CONVERT(MONEY, NULL) AS   FeeDetailOther,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  ISNULL(C.Priority, 'Normal') AS CasePriority,
  CONVERT(DATE, C.AwaitingScheduling) as DateAwaitingScheduling,
  CO.ParentCompanyID,
  CONVERT(VARCHAR(32), NULL) AS ClaimUniqueId,
  CONVERT(VARCHAR(32), NULL) AS CMSClaimNumber,
  CONVERT(VARCHAR(8),  NULL) AS ShortVendorId,
  CONVERT(VARCHAR(12), NULL) AS ProcessingOfficeId,
  CONVERT(VARCHAR(32), NULL) AS ReferralUniqueId,
  CONVERT(VARCHAR(12), NULL) AS ClientCustomerId,
  CONVERT(VARCHAR(128),NULL) AS ClientCustomerName,
  C.ClaimNbrExt as ClaimNoExt,
  CONVERT(VARCHAR(32), NULL) as FeeQuoteAmount,
  CONVERT(VARCHAR(64), NULL) AS OutOfNetworkReason,
  CONVERT(VARCHAR(12), 'N/A') AS MedRecPages,
  CONVERT(BIT, NULL) AS AddendumNeeded,
  C.[Status] as CaseStatus
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode		-- invoice client (billing client)
left outer join tblCompany as CO on Inv.CompanyCode = CO.CompanyCode	-- invoice company (billing company)
left outer join tblClient as CLI on C.ClientCode = CLI.ClientCode		-- case client
left outer join tblCompany as COM on CLI.CompanyCode = COM.CompanyCode	-- case company
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblEWFacility as EWF on Inv.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on Inv.EWFacilityID = EFGS.EWFacilityID
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblDocument as DOC on Inv.DocumentCode = DOC.Document
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
left outer join tblCaseAppt as CA on isnull(Inv.CaseApptID, C.CaseApptID) = CA.CaseApptID
left outer join tblCaseAppt as AHCA on Inv.CaseApptID = AHCA.CaseApptID
left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
left outer join tblApptStatus as APS on isnull(Inv.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
left outer join tblLocation as EL on CA.LocationCode = EL.LocationCode
left outer join
  (select
     RelatedInvHeaderID, 
     sum(DocumentTotalUS)-sum(cast(Round(TaxTotal*ExchangeRate, 2) as Money)) as Expense,
     count(DocumentNbr) as VoucherCount,
     min(DocumentDate) as VoucherDateMin,  
     min(DocumentNbr) as VoucherNoMin,
     max(DocumentDate) as VoucherDateMax,
     max(DocumentNbr) as VoucherNoMax
   from tblAcctHeader
   where DocumentType='VO' and DocumentStatus='Final' 
         and (DocumentDate >= @startDate and DocumentDate <= @endDate )
   group by RelatedInvHeaderID
  ) as VO on Inv.HeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND CO.ParentCompanyID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND CO.ParentCompanyID > 0))

ORDER BY EWF.GPFacility, Inv.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
-- Sprint 92

-- IMEC-12984
-- Adding new setting to tblSetting to handle database context CommandTimeout value
-- Dev: Sam Chiang

INSERT INTO dbo.tblSetting (Name, Value)
VALUES (
'FeeSchedSyncTimeout', 
'1800' 
)
GO

