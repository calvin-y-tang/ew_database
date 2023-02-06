

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
PRINT N'Altering [dbo].[tblDoctorSpecialty]...';


GO
ALTER TABLE [dbo].[tblDoctorSpecialty]
    ADD [MasterReviewerSpecialtyID] INT NULL;


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
PRINT N'Altering [dbo].[vwApptLogByAppt2]...';


GO

ALTER VIEW vwApptLogByAppt2
AS
    SELECT
        tblCase.CaseNbr,
        '' AS DateAdded,
        tblCase.DateAdded AS CaseDateAdded,
        tblCase.ApptTime,
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS Client,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCompany.IntName AS Company,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS Examinee,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description AS Specialty,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        tblCase.QARep AS QARepcode,
        tblCase.CaseType,
        tblCase.MasterSubCase,
        (
         SELECT TOP 1
            tblCaseAppt.ApptTime
         FROM
            tblCaseAppt
         WHERE
            tblCaseAppt.CaseNbr=tblCase.CaseNbr AND
            tblCaseAppt.CaseApptID<tblCase.CaseApptID
         ORDER BY
            tblCaseAppt.CaseApptID DESC
        ) AS PreviousApptTime,
        tblDoctor.ProvTypeCode,
        tblCase.ExtCaseNbr,
        tblCase.HearingDate,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    LEFT OUTER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
    GROUP BY
        tblCase.ApptDate,
        tblCaseType.ShortDesc,
        tblCase.DoctorName,
        tblClient.FirstName+' '+tblClient.LastName,
        tblCompany.IntName,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, ''),
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.CaseApptID,
        tblCase.ExtCaseNbr
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
<button id="Btn_143400" getEnabled="Ribbon_GetEnabled" label="Flash Report" showImage="false" tag="None|Open_frmFlashReportParams2|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143500" getEnabled="Ribbon_GetEnabled" label="Invoice Register" showImage="false" tag="None|Open_FrmInvoiceRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143600" getEnabled="Ribbon_GetEnabled" label="Voucher Register" showImage="false" tag="None|Open_FrmVoucherRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143700" getEnabled="Ribbon_GetEnabled" screentip="Print Fee Schedule Listing" label="Fee Schedule Listing" showImage="false" tag="None|Open_frmFeeSchedRptParam|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>
<tab id="Tab_150000" getVisible="Ribbon_GetVisible" label="Report">
<group id="Grp_151000" getVisible="Ribbon_GetVisible" label="Appointment">
<button id="Btn_151200" getEnabled="Ribbon_GetEnabled" label="Appointment Log" showImage="false" tag="None|Open_FrmApptLogParams2|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151300" getEnabled="Ribbon_GetEnabled" screentip="Appointments on Hold Report" label="Appointments on Hold" showImage="false" tag="None|Open_frmApptOnHoldParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151500" getEnabled="Ribbon_GetEnabled" screentip="Run Cancelled Cases Report" label="Cancelled Appts" showImage="false" tag="None|Open_frmCancelCase|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_151600" getEnabled="Ribbon_GetEnabled" label="Confirmation Result" showImage="false" tag="None|Call_MMenuReportsAppointmentConfirmationResult|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
<group id="Grp_152000" getVisible="Ribbon_GetVisible" label="Doctor">
<button id="Btn_152200" getEnabled="Ribbon_GetEnabled" label="Day Sheet" showImage="false" tag="None|Open_frmDaySheetParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152300" getEnabled="Ribbon_GetEnabled" label="Doctor Schedules" showImage="false" tag="None|Call_MMenuReportsDoctorRptDoctorsScheds|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_152700" getEnabled="Ribbon_GetEnabled" label="Schedule Summary" showImage="false" tag="None|Open_FrmDoctorScheduleSummary2|None" onAction="Ribbon_ButtonAction" size="normal" />

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
PRINT N'Creating [dbo].[proc_Info_Medaca_MgtRpt_PatchData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_PatchData]
	@startDate Date,
	@endDate Date	
AS

UPDATE T 
	set T.[EHQ-Rcvd] = [dbo].[fnGetParamValue](CD.Param, 'EHQReceived=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[EHQ-Sent] = [dbo].[fnGetParamValue](CD.Param, 'EHQSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARecommend] = [dbo].[fnGetParamValue](CD.Param, 'TMHARecommend=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARequestSent] = [dbo].[fnGetParamValue](CD.Param, 'TMHARequestSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHAService] = [dbo].[fnGetParamValue](CD.Param, 'TMHAService=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GPContactDate] = [dbo].[fnGetParamValue](CD.Param, 'GPContactDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWDate] = [dbo].[fnGetParamValue](CD.Param, 'RTWDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Diagnosis] = (SELECT  STUFF((SELECT  ',' + icd.description from tblcase c with (nolock)
										left join tblICDCode icd with (nolock) on icd.Code in (icdcodea, icdcodeb, icdcodec,icdcoded,ICDCodeE,icdcodeF,icdcodeg,ICDCodeH,ICDCodeI, icdcodej,icdcodek,icdcodel)
										where c.casenbr = t.casenbr
										FOR XML PATH('')), 1, 1, ''))
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWExplained] = [dbo].[fnGetParamValue](CD.Param, 'Comments=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARescheduled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHACancelled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr and ca.apptstatusid in (50,51)) --Cancelled or Late Cancelled
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

	
UPDATE T 
	set T.[TMHARescheduledDate] = (select top 1 ca.dateadded from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr  order by ca.dateadded desc)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Claims Received Date] = [dbo].[fnGetParamValue](CD.Param, 'ClaimReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GP Comm Fax Received] = [dbo].[fnGetParamValue](CD.Param, 'FaxReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'
Select
	Casenbr,
	[Service File Type],
	[Referral Date],
	CM,
	Surname,
	[First Name],
	Client,
	[Client Location],
	[Group Number],
	[Claim Number],
	isnull([Group or Employer],'') as 'Group or Employer',
	[Case Manager 1],
	[Disability Date],
	isnull(convert(varchar,[Claims Received Date],101),'') as [Claims Received Date],
	isnull([EHQ-Rcvd],'') as 'Scales In',
	isnull([EHQ-Sent],'') as 'Scales Out',

	isnull([TMHARecommend],'') as 'TMHA Recommend (Yes/No)',
	isnull([TMHARequestSent],'') as 'Service Request Date',
	isnull([TMHAService],'') as 'TMHA Date',
	case when [TMHARescheduled] > 1 then 'Yes' else 'No' end as 'TMHA Rescheduled',
	Case when [TMHACancelled] > 1 then 'Yes' else 'No' end as 'TMHA Cancelled',
	case when [TMHARescheduled] > 1 then isnull(convert(varchar,TMHARescheduledDate,101),'') else '' end  as 'TMHA Rescheduled Date',
	isnull(convert(varchar,[Final Sent],101),'') as 'Final Sent',
	isnull(Diagnosis,'') as Diagnosis,
	isnull([GP Contact],'') as 'GP Contact',
	isnull([GPContactDate],'') as 'Date GP Contact',
	isnull(Psychiatrist,'') as Psychiatrist,
	isnull(convert(varchar,[GP Comm Fax Received],101),'') as 'GP Comm Fax Received',
	isnull([RTWDate],'') as RTWDate,
	isnull(RTWExplained,'') as RTWExplained,
	convert(varchar,ServiceFileModified,101) as 'Service File Last Modified'
from ##Temp_MedacaCases
order by [Referral Date]

IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases
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
PRINT N'Creating [dbo].[proc_Info_Medaca_MgtRpt_QueryData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@dateFilter INT
AS
SET NOCOUNT ON
IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases

SELECT
	c.casenbr,
	s.description as 'Service File Type',
	convert(varchar, c.dateadded, 101) as 'Referral Date',
	sh.lastname + ', ' + sh.firstname as 'CM',
	e.lastname as Surname,
	e.firstname as 'First Name',
	co.ExtName as 'Client',
	co.city as 'Client Location',
	c.AddlClaimNbrs as 'Group Number',
	c.claimnbr as 'Claim Number',
	emp.Name as 'Group or Employer',
	cl.firstname + ' ' + cl.LastName as 'Case Manager 1',
	isnull(convert(varchar,c.dateofinjury,101),'') as 'Disability Date',
	convert(varchar, null) as 'EHQ-Rcvd',
	convert(varchar, null) as 'EHQ-Sent',
	convert(varchar, null) as 'Claims Received Date',
	convert(varchar, null) as 'TMHARecommend',
	convert(varchar, null) as 'TMHARequestSent',
	convert(varchar, null) as 'TMHAService',
	convert(int, null) as 'TMHARescheduled' ,
	convert(bit, null) as 'TMHACancelled' ,
	convert(datetime, null) as 'TMHARescheduledDate' ,
	c.RptSentDate as 'Final Sent',
	convert(varchar(1000), null) as Diagnosis,
	e.treatingphysician as 'GP Contact',
	convert(varchar, null) as 'GPContactDate',
	c.doctorname as 'Psychiatrist',
	convert(datetime, null) as 'GP Comm Fax Received' ,
	convert(varchar, null) as 'RTWDate',
	convert(varchar(2000), null) as 'RTWExplained',
	c.dateedited as 'ServiceFileModified'
into ##Temp_MedacaCases
from tblcase c with (nolock) 
	inner join tbloffice o with (nolock) on c.officecode = o.officecode
	inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
	inner join tblclient cl with (nolock) on cl.clientcode = c.clientcode
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	inner join tblservices s with (nolock) on s.ServiceCode = c.ServiceCode
	left join tblemployer emp with (nolock) on emp.EmployerID = c.EmployerID
	left join tbluser sh with (nolock) on sh.userid = c.schedulercode
where 	
	CONVERT(DATE, IIF(@dateFilter = 2, c.dateedited, c.DateReceived)) >= @startDate
		and CONVERT(DATE, IIF(@dateFilter = 2, c.dateedited, c.DateReceived)) <= @endDate

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
PRINT N'Creating [dbo].[spRptFlashReport2]...';


GO
CREATE PROCEDURE [dbo].[spRptFlashReport2]
@Month int,
@Year int,
@EWFacilityID int , 
@OfficeCode int ,
@runID varchar(50)
AS 

set nocount on

	DECLARE @Month2 INT
	DECLARE @Year2 INT
	DECLARE @dateMonthYear varchar(10)
	DECLARE @dateMonthYear2 varchar(10)
	DECLARE @sReportLabel varchar(15)
	DECLARE @sReportLabel2 varchar(15)


if @Month = 12 begin
 select @Month2 = 1
 select @Year2 = @Year + 1
end
else
begin
 select @Month2 = @Month + 1
 select @Year2 = @Year
end

set @dateMonthYear = CONVERT(varchar(4), @Year) + '/' + CONVERT(varchar(2), @Month) +'/01'
set @dateMonthYear2 = CONVERT(varchar(4), @Year2) + '/' + CONVERT(varchar(2), @Month2) +'/01'
set @sReportLabel = DATENAME(MONTH, @dateMonthYear) + ' ' + CONVERT(varchar(4), @Year)
set @sReportLabel2 = DATENAME(MONTH, @dateMonthYear2) + ' ' + CONVERT(varchar(4), @Year2)



Create table #lineItems
(DocumentType varchar(2),
 DocumentNbr int not null,
 LineNbr int,
 Description varchar(100),
 ReportCategory varchar(25),
 Revenue money not null,
 Expense money not null,
 ExtendedAmount money not null)

insert into #lineItems
select  tblAcctHeader.DocumentType,
        tblAcctHeader.DocumentNbr,
        tblAcctDetail.LineNbr,
        '',
        ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory,
        case when tblacctheader.documenttype = 'IN'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Revenue,
        case when tblacctheader.documenttype = 'VO'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Expense,
        isnull(tblacctdetail.ExtendedAmount, 0) as ExtendedAmount
from    tblAcctHeader
        inner join tblAcctDetail on tblAcctHeader.HeaderID = tblAcctDetail.HeaderID
        left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
        left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType
                                         and TblAcctDetail.prodcode = tblFRCategory.ProductCode
        left outer JOIN tblEWFlashCategory ON tblFRCategory.EWFlashCategoryID = tblEWFlashCategory.EWFlashCategoryID
where   ( tblAcctHeader.documentstatus = 'Final' )
        and ( tblAcctHeader.EWFacilityID = @EWFacilityID
              or @EWFacilityID = -1
            )
        and month(tblAcctHeader.DocumentDate) = @month
        and year(tblAcctHeader.DocumentDate) = @year 
		and dbo.tblCase.OfficeCode = @OfficeCode  

select ReportCategory, sum(FRUnits)as SumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin,
     'CurrentBilled' AS ReportType, 'Invoiced in ' + @sReportLabel AS ReportLabel, @runID AS runID from 
(
select
  ReportCategory,
  case
    when (select count(*) from #lineItems as counter
   where counter.DocumentType=#lineItems.DocumentType
   and counter.DocumentNbr=#lineItems.DocumentNbr
   and counter.ReportCategory=#lineItems.ReportCategory
   and counter.LineNbr<=#lineItems.LineNbr) = 1 then
      case  
        when DocumentType = 'IN' then
          case when ExtendedAmount < 0 then -1 else 1 end
        else 0
      end
    else 0 
  end as FRUnits,
  Revenue, Expense,
  case
    when DocumentType = 'IN' then ExtendedAmount
    else -ExtendedAmount
  end as Amount
from #lineItems
) as lines
group by ReportCategory


UNION ALL

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments, -1 AS SumRevenue, -1 AS SumExpense, -1 AS SumMargin, 'CurrentScheduled' AS ReportType, 'Forecasted for ' + @sReportLabel AS ReportLabel, @runID AS runID 
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
     ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
					left outer join (select MIN(tp.ProdCode) AS ProdCode, tp.Description as ProdDesc, po.OfficeCode
                                     FROM tblProduct as tp
								     inner join tblProductOffice as po on tp.ProdCode = po.ProdCode
									 GROUP BY tp.Description, po.OfficeCode
                     ) as PTO on tblCase.OfficeCode = PTO.OfficeCode and tblServices.Description = PTO.ProdDesc
					left outer join tblFRCategory as FRC on tblcase.CaseType = FRC.CaseType and PTO.ProdCode = FRC.ProductCode
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON FRC.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
     
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year 
					AND dbo.tblCase.OfficeCode = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

UNION ALL

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments,  -1 AS SumRevenue, -1 AS SumExpense, -1 AS SumMargin, 'FutureScheduled' AS ReportType, 'Forecasted for ' + @sReportLabel2 AS ReportLabel, @runID AS runID 
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
					left outer join (select MIN(tp.ProdCode) AS ProdCode, tp.Description as ProdDesc, po.OfficeCode
                                     FROM tblProduct as tp
								     inner join tblProductOffice as po on tp.ProdCode = po.ProdCode
									 GROUP BY tp.Description, po.OfficeCode
                     ) as PTO on tblCase.OfficeCode = PTO.OfficeCode and tblServices.Description = PTO.ProdDesc
					left outer join dbo.tblFRCategory on tblCase.CaseType = tblFRCategory.CaseType and PTO.ProdCode = tblFRCategory.ProductCode
					AND dbo.tblFRCategory.ProductCode = PTO.prodcode AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month2
                    AND YEAR(dbo.tblcase.ForecastDate) = @year2
					and dbo.tblOffice.OfficeCode  = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

order by ReportType, ReportCategory

drop table #lineItems
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
PRINT N'Creating [dbo].[proc_Info_Medaca_MgtRpt]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt]	
	@startDate Date,
	@endDate Date,
	@useEditDate Bit	
AS
	EXEC [dbo].[proc_Info_Medaca_MgtRpt_QueryData] @startDate, @endDate, @useEditDate
	EXEC [dbo].[proc_Info_Medaca_MgtRpt_PatchData] @startDate, @endDate
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
-- Sprint 103

-- IMEC-13360 -- need to remove security token to ensure it is not going to be used.
DELETE FROM tblUserFunction WHERE FunctionCode = 'DoctorSpecialtyEdit'
GO
DELETE FROM tblGroupFunction WHERE FunctionCode = 'DoctorSpecialtyEdit'
GO

