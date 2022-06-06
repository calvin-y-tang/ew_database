CREATE FUNCTION fnGetRibbonXML
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

	<ribbon startFromScratch="%startFromScratch%">
		<tabs>
%content%
		</tabs>
	</ribbon>
</customUI>
'

	SET @content = '
<tab id="Tab_110000" label="Home">
<group id="Grp_111000" label="Main">
<button id="Btn_111100" getEnabled="Ribbon_GetEnabled" label="Tracker" getImage="Ribbon_GetImage" tag="None|Call_ToolbarTracker|File_Sherlock.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_111200" getEnabled="Ribbon_GetEnabled" label="SLA Monitor" getImage="Ribbon_GetImage" tag="SLAMonitor|Call_ToolbarSLAMonitor|Mso_SlideShowRehearseTimings" onAction="Ribbon_ButtonAction" size="large" />

<separator id="Spr_111300" />
<button id="Btn_111400" getEnabled="Ribbon_GetEnabled" screentip="Transcription Tracker" label="Transcription" getImage="Ribbon_GetImage" tag="TransTracker|Open_frmTranscriptionTracker|File_Headphones.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_111500" getEnabled="Ribbon_GetEnabled" label="Confirmation" getImage="Ribbon_GetImage" tag="None|Call_ToolbarConfirmation|Mso_AutoDial" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_111600" getEnabled="Ribbon_GetEnabled" label="File Manager" getImage="Ribbon_GetImage" tag="FileManager|Open_frmFileManager|File_File Manager.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_111700" getEnabled="Ribbon_GetEnabled" label="Scanning" getImage="Ribbon_GetImage" tag="DefaultInvisible|Call_OpenCaseSearchForScanning|File_scanner.png" onAction="Ribbon_ButtonAction" size="large" />

<separator id="Spr_111800" />
<button id="Btn_111900" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Cases" label="New Case" getImage="Ribbon_GetImage" tag="None|Open_frmexamineeselection|File_Custom-Case.png" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_112000" label="Search">
<button id="Btn_112101" getEnabled="Ribbon_GetEnabled" label="CaseSearch" getImage="Ribbon_GetImage" tag="None|Call_OpenCaseSearch|File_Custom-Case Search.png" onAction="Ribbon_ButtonAction" size="large" />

<separator id="Spr_112500" />
<button id="Btn_112600" getEnabled="Ribbon_GetEnabled" screentip="Search for Doctors" label="Doctor Search" getImage="Ribbon_GetImage" tag="None|Open_frmdoctorsearch|File_Custom-Doctor Search.png" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_113000" label="Entity">
<button id="Btn_113100" getEnabled="Ribbon_GetEnabled" screentip="Add/Edit Companies" label="Company" getImage="Ribbon_GetImage" tag="None|Open_frmcompany|File_Company.bmp" onAction="Ribbon_ButtonAction" size="large" />

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
<group id="Grp_114000" label="Office">
<toggleButton id="Tgb_114100" getEnabled="Ribbon_GetEnabled" label="Use Favorites" getImage="Ribbon_GetImage" tag="None|Call_MMenuChangeOffice|Mso_CustomActionsMenu" onAction="Ribbon_ToggleButtonAction" />

<labelControl id="Lbl_114200" getEnabled="Ribbon_GetEnabled" label="Current Office" tag="None|None|None" />

<dropDown id="Drp_SelectedOffice" getEnabled="Ribbon_GetEnabled" tag="None|Call_MMenuChangeOffice|None" sizeString="WWWWWWWWWWWWWWWW" getItemCount="Ribbon_DropdownGetItemCount" getItemID="Ribbon_DropdownGetItemID" getItemLabel="Ribbon_DropdownGetItemLabel" getSelectedItemIndex="Ribbon_DropdownGetSelectedItemIndex" onAction="Ribbon_DropdownOnAction" showLabel="false">
</dropDown>
</group>
<group id="Grp_115000" label="Apps">
<button id="Btn_115100" getEnabled="Ribbon_GetEnabled" label="Info*Centric" getImage="Ribbon_GetImage" tag="None|Call_RunInfoCentric|File_InfoCentric.png" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_115200" getEnabled="Ribbon_GetEnabled" label="DICOM Extractor" getImage="Ribbon_GetImage" tag="None|Call_RunInfoCentric|Mso_FilePackageForCD" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_117000" label="Exit">
<button id="Btn_117300" getEnabled="Ribbon_GetEnabled" getImage="Ribbon_GetImage" tag="None|Call_ExitIMEC|Mso_PrintPreviewClose" onAction="Ribbon_ButtonAction" size="large" />

</group>
</tab>
<tab id="Tab_120000" label="Maintenance">
<group id="Grp_121000" label="Workflow">
<button id="Btn_121100" getEnabled="Ribbon_GetEnabled" label="Case Types" getImage="Ribbon_GetImage" tag="None|Open_frmcasetype|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121200" getEnabled="Ribbon_GetEnabled" label="Queues" getImage="Ribbon_GetImage" tag="None|Open_frmqueues|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121300" getEnabled="Ribbon_GetEnabled" label="Services" getImage="Ribbon_GetImage" tag="None|Open_frmservices|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_121400" getEnabled="Ribbon_GetEnabled" label="Service Workflow" getImage="Ribbon_GetImage" tag="None|Open_frmServiceWorkflowList|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_122000" label="Setup">
<menu id="Mnu_122100" getEnabled="Ribbon_GetEnabled" label="Confirmation" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122110" getEnabled="Ribbon_GetEnabled" label="System" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsConfirmationSetup|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122120" getEnabled="Ribbon_GetEnabled" label="Rule" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsConfirmationRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122130" getEnabled="Ribbon_GetEnabled" label="Message" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsConfirmationMessage|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122140" getEnabled="Ribbon_GetEnabled" label="Result" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsConfirmationResult|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

</menu>
<menu id="Mnu_122200" getEnabled="Ribbon_GetEnabled" label="SLA" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122210" getEnabled="Ribbon_GetEnabled" label="Rule" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsSLADefinitionSLARule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122220" getEnabled="Ribbon_GetEnabled" label="Exception" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsSLADefinitionSLAException|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

</menu>
<menu id="Mnu_122300" getEnabled="Ribbon_GetEnabled" label="Doctor" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122310" getEnabled="Ribbon_GetEnabled" label="Degree" getImage="Ribbon_GetImage" tag="NonNDB|Open_frmDegree|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122320" getEnabled="Ribbon_GetEnabled" label="Keyword" getImage="Ribbon_GetImage" tag="None|Open_frmKeyWord|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122330" getEnabled="Ribbon_GetEnabled" label="Provider Types" getImage="Ribbon_GetImage" tag="None|Open_frmProviderTypes|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122340" getEnabled="Ribbon_GetEnabled" label="Specialty" getImage="Ribbon_GetImage" tag="NonNDB|Open_frmSpecialty|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

</menu>
<button id="Btn_122400" getEnabled="Ribbon_GetEnabled" screentip="Define Exceptions" label="Exceptions" getImage="Ribbon_GetImage" tag="None|Open_frmExceptionDefinition|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<menu id="Mnu_122500" getEnabled="Ribbon_GetEnabled" label="Other" tag="None|Call_MMenuListsConfirmationSetup|None" itemSize="normal">
<button id="Btn_122510" getEnabled="Ribbon_GetEnabled" label="Cancel Reason" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsSetupCancelReason|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122520" getEnabled="Ribbon_GetEnabled" label="Client Type" getImage="Ribbon_GetImage" tag="None|Open_frmClientType|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122530" getEnabled="Ribbon_GetEnabled" label="DICOM Retention Rule" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsSetupDICOMRetentionRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122540" getEnabled="Ribbon_GetEnabled" label="ICD Code" getImage="Ribbon_GetImage" tag="None|Open_frmICDCodes|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122550" getEnabled="Ribbon_GetEnabled" label="Issues" getImage="Ribbon_GetImage" tag="None|Open_frmissues|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122560" getEnabled="Ribbon_GetEnabled" label="Other Party Type" getImage="Ribbon_GetImage" tag="None|Open_frmOtherPartyType|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122570" getEnabled="Ribbon_GetEnabled" label="Problem" getImage="Ribbon_GetImage" tag="None|Open_frmproblem|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_122580" getEnabled="Ribbon_GetEnabled" label="Standard Case History Note" getImage="Ribbon_GetImage" tag="None|Open_frmStdCaseHistoryNotes|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

</menu>
</group>
<group id="Grp_123000" label="Document/Report">
<button id="Btn_123100" getEnabled="Ribbon_GetEnabled" label="Document Maintenance" getImage="Ribbon_GetImage" tag="None|Open_FrmDocumentMaintenance|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_123200" getEnabled="Ribbon_GetEnabled" label="Med Record Action" getImage="Ribbon_GetImage" tag="None|Open_frmRecordActions|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123300" getEnabled="Ribbon_GetEnabled" label="Med Record Status" getImage="Ribbon_GetImage" tag="None|Open_frmRecordStatus|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123400" getEnabled="Ribbon_GetEnabled" label="Obtainment Type" getImage="Ribbon_GetImage" tag="None|Open_frmObtainmentType|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_123500" getEnabled="Ribbon_GetEnabled" label="Report Status Code" getImage="Ribbon_GetImage" tag="None|Open_frmRptStatus|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_124000" label="Web">
<button id="Btn_124100" getEnabled="Ribbon_GetEnabled" label="Portal User" getImage="Ribbon_GetImage" tag="None|Open_frmWebUser|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_124200" getEnabled="Ribbon_GetEnabled" label="Queue" getImage="Ribbon_GetImage" tag="None|Open_frmWebQueues|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124300" getEnabled="Ribbon_GetEnabled" label="Sync Log" getImage="Ribbon_GetImage" tag="None|Open_frmSyncLogs|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124400" getEnabled="Ribbon_GetEnabled" screentip="Set Web Events to Automatically Publish" label="Event" getImage="Ribbon_GetImage" tag="None|Open_frmWebEvents|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124500" getEnabled="Ribbon_GetEnabled" label="Version Rule" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsWebPortalWebVersionRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_124600" getEnabled="Ribbon_GetEnabled" label="Office Contact" getImage="Ribbon_GetImage" tag="WebOfficeContactsAddEdit|Call_MMenuListsWebPortalOfficeContact|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_125000" label="Security">
<button id="Btn_125100" getEnabled="Ribbon_GetEnabled" label="User" getImage="Ribbon_GetImage" tag="None|Open_FrmUserSecurity|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_125200" getEnabled="Ribbon_GetEnabled" label="Group" getImage="Ribbon_GetImage" tag="None|Open_frmusergroup|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_125300" getEnabled="Ribbon_GetEnabled" label="Function" getImage="Ribbon_GetImage" tag="None|Open_FrmUserFunctions|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_125400" getEnabled="Ribbon_GetEnabled" label="Assignment" getImage="Ribbon_GetImage" tag="None|Open_FrmGrpFunctions|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_126000" label="Office">
<button id="Btn_126100" getEnabled="Ribbon_GetEnabled" screentip="Maintain Offices" label="Office" getImage="Ribbon_GetImage" tag="None|Open_frmOffice|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_126200" getEnabled="Ribbon_GetEnabled" label="Setup" getImage="Ribbon_GetImage" tag="None|Open_frmSetupInformation|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_127000" label="System">
<button id="Btn_127100" getEnabled="Ribbon_GetEnabled" label="Configuration" getImage="Ribbon_GetImage" tag="ISOnly|Open_frmSystemConfiguration|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127200" getEnabled="Ribbon_GetEnabled" label="State/Province" getImage="Ribbon_GetImage" tag="None|Open_frmStateMaintenance|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127300" getEnabled="Ribbon_GetEnabled" label="Non Work Days" getImage="Ribbon_GetImage" tag="None|Open_frmNonWorkDays|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127500" getEnabled="Ribbon_GetEnabled" label="Folder Office Setup" getImage="Ribbon_GetImage" tag="ISOnly|Open_frmFolderOffice|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127600" getEnabled="Ribbon_GetEnabled" label="Cover Letter Manager" getImage="Ribbon_GetImage" tag="ISOnly|Call_MMenuToolsCoverLtrMgr|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127700" getEnabled="Ribbon_GetEnabled" label="Referral Assignment Rule" getImage="Ribbon_GetImage" tag="ISOnly|Open_frmReferralAssignmentRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127800" getEnabled="Ribbon_GetEnabled" label="Referral Form Manager" getImage="Ribbon_GetImage" tag="ISOnly|Call_MMenuToolsReferralFormMgr|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_127900" getEnabled="Ribbon_GetEnabled" label="Referral Form Rule" getImage="Ribbon_GetImage" tag="ISOnly|Call_MMenuToolsReferralFormRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>
<tab id="Tab_130000" label="IS Only">
</tab>
<tab id="Tab_140000" label="Accounting">
<group id="Grp_141000" label="Setup">
<button id="Btn_141100" getEnabled="Ribbon_GetEnabled" label="Billing Company" getImage="Ribbon_GetImage" tag="DefaultInvisible|Open_frmBillingCompany|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_141200" getEnabled="Ribbon_GetEnabled" label="Fee Schedule V1" getImage="Ribbon_GetImage" tag="ViewFeeSchedule|Open_frmFeeSchedule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<menu id="Mnu_141300" getEnabled="Ribbon_GetEnabled" label="Fee Schedule V2" tag="None|Call_MMenuListsAccountingFeeScheduleNetwork|None" itemSize="normal">
<button id="Btn_141310" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Network)" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsAccountingFeeScheduleNetwork|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_141320" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Company)" getImage="Ribbon_GetImage" tag="ViewFeeScheduleCompany|Call_MMenuListsAccountingFeeScheduleCompany|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

<button id="Btn_141330" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Office)" getImage="Ribbon_GetImage" tag="ViewFeeScheduleOffice|Call_MMenuListsAccountingFeeScheduleOffice|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" />

</menu>
<button id="Btn_141400" getEnabled="Ribbon_GetEnabled" label="Fee Schedule (Abeton)" getImage="Ribbon_GetImage" tag="ViewFeeScheduleAbeton|Open_frmFeeScheduleAbeton|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141500" getEnabled="Ribbon_GetEnabled" label="Flash Report Setup" getImage="Ribbon_GetImage" tag="None|Open_frmFlashReportSetup|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141600" getEnabled="Ribbon_GetEnabled" screentip="Product Maintenance" label="Products" getImage="Ribbon_GetImage" tag="None|Open_frmProduct|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141700" getEnabled="Ribbon_GetEnabled" label="Quote Rule" getImage="Ribbon_GetImage" tag="None|Call_MMenuListsAccountingQuoteRule|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141800" getEnabled="Ribbon_GetEnabled" label="Tax Tables" getImage="Ribbon_GetImage" tag="None|Open_frmTaxTable|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_141900" getEnabled="Ribbon_GetEnabled" label="Terms" getImage="Ribbon_GetImage" tag="None|Open_frmTerms|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_142000" label="Action">
<button id="Btn_142100" getEnabled="Ribbon_GetEnabled" label="Generate Corrected Invoice" getImage="Ribbon_GetImage" tag="None|Open_frmGenerateCorrectedInvoice|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_142200" getEnabled="Ribbon_GetEnabled" label="Re-Export Batch" getImage="Ribbon_GetImage" tag="None|Open_frmReExportBatch|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

<button id="Btn_142300" getEnabled="Ribbon_GetEnabled" label="Unfinalize Document" getImage="Ribbon_GetImage" tag="None|Open_frmunfinalizedocument|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="large" />

</group>
<group id="Grp_143000" label="Report/Export">
<button id="Btn_143300" getEnabled="Ribbon_GetEnabled" label="Flash Report" getImage="Ribbon_GetImage" tag="None|Open_frmFlashReportParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143400" getEnabled="Ribbon_GetEnabled" label="Invoice Register" getImage="Ribbon_GetImage" tag="None|Open_FrmInvoiceRegister|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143500" getEnabled="Ribbon_GetEnabled" label="Voucher Register" getImage="Ribbon_GetImage" tag="None|Open_FrmVoucherRegister|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143600" getEnabled="Ribbon_GetEnabled" screentip="Print Fee Schedule Listing" label="Fee Schedule Listing" getImage="Ribbon_GetImage" tag="None|Open_frmFeeSchedRptParam|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>
<tab id="Tab_150000" label="Report">
<group id="Grp_151000" label="Appointment">
<button id="Btn_151100" getEnabled="Ribbon_GetEnabled" label="Appointment Log" getImage="Ribbon_GetImage" tag="None|Open_FrmApptLogParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151200" getEnabled="Ribbon_GetEnabled" screentip="Appointments on Hold Report" label="Appointments on Hold" getImage="Ribbon_GetImage" tag="None|Open_frmApptOnHoldParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151300" getEnabled="Ribbon_GetEnabled" label="Attorney Confirmation" getImage="Ribbon_GetImage" tag="None|Open_frmAttorneyConfirmationParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151400" getEnabled="Ribbon_GetEnabled" screentip="Run Cancelled Cases Report" label="Cancelled Appts" getImage="Ribbon_GetImage" tag="None|Open_frmCancelCase|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151500" getEnabled="Ribbon_GetEnabled" label="Confirmation Result" getImage="Ribbon_GetImage" tag="None|Call_MMenuReportsAppointmentConfirmationResult|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151600" getEnabled="Ribbon_GetEnabled" label="Referrals by Month" getImage="Ribbon_GetImage" tag="None|Open_frmApptbyMonthParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151700" getEnabled="Ribbon_GetEnabled" label="Shows/No Shows by Month" getImage="Ribbon_GetImage" tag="None|Open_FrmApptsbyMonth|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151800" getEnabled="Ribbon_GetEnabled" label="Appointments by Forecast Date" getImage="Ribbon_GetImage" tag="None|Open_frmApptByForecastDate|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_152000" label="Doctor">
<button id="Btn_152100" getEnabled="Ribbon_GetEnabled" label="Cancelation Policies" getImage="Ribbon_GetImage" tag="None|Call_MMenuReportsDoctorRptCancelationPolicies|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152200" getEnabled="Ribbon_GetEnabled" label="Day Sheet" getImage="Ribbon_GetImage" tag="None|Open_frmDaySheetParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152300" getEnabled="Ribbon_GetEnabled" label="Doctor Schedules" getImage="Ribbon_GetImage" tag="None|Call_MMenuReportsDoctorRptDoctorsScheds|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152500" getEnabled="Ribbon_GetEnabled" label="Doctor Schedule Summary" getImage="Ribbon_GetImage" tag="None|Open_FrmDoctorScheduleSummary|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152600" getEnabled="Ribbon_GetEnabled" label="Expiring Documents/Credentials" getImage="Ribbon_GetImage" tag="None|Open_frmexpiringcredentials|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_153000" label="Export">
<button id="Btn_153100" getEnabled="Ribbon_GetEnabled" label="Export Data to Excel" getImage="Ribbon_GetImage" tag="None|Open_frmExportParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_153200" getEnabled="Ribbon_GetEnabled" label="Export Liberty Data To Excel" getImage="Ribbon_GetImage" tag="None|Open_FrmLibertyExportParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_153300" getEnabled="Ribbon_GetEnabled" label="Export ATIC Data" getImage="Ribbon_GetImage" tag="CustomATICExport|Call_MMenuListsExportATICData|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_154000" label="Custom">
<button id="Btn_154100" getEnabled="Ribbon_GetEnabled" label="Canadian Custom Program" getImage="Ribbon_GetImage" tag="None|Open_frmCACustomMenu|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_154200" getEnabled="Ribbon_GetEnabled" label="MEI Custom Program" getImage="Ribbon_GetImage" tag="CustomMEIProgram|Open_frmCustomMEI|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_155000" label="Others">
<button id="Btn_155100" getEnabled="Ribbon_GetEnabled" label="Progressive" getImage="Ribbon_GetImage" tag="RptProgressiveRpts|Call_MMenuReportsProgressiveReports|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_155200" getEnabled="Ribbon_GetEnabled" label="Medical Records" getImage="Ribbon_GetImage" tag="None|Open_frmRecordsReportParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_155300" getEnabled="Ribbon_GetEnabled" label="Special Services" getImage="Ribbon_GetImage" tag="None|Open_frmSpecialServicesParams|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_155800" getEnabled="Ribbon_GetEnabled" screentip="Report Turnaround Time Report" label="Report Turnaround Times" getImage="Ribbon_GetImage" tag="None|Open_frmReportTAT|Mso_ViewsLayoutView" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>

'
	
	IF @startFromScratch = 1
		SELECT @xml = REPLACE(@header, '%startFromScratch%', 'true')
	ELSE
		SELECT @xml = REPLACE(@header, '%startFromScratch%', 'false')

	SET @xml = REPLACE(@xml, '%content%', @content)

	RETURN @xml

END