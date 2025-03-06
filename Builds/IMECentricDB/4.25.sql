

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
PRINT N'Creating [dbo].[vwAcctRegister]...';


GO
CREATE VIEW vwAcctRegister
AS
    SELECT  tblCase.CaseNbr ,
            tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            CASE WHEN tblDoctor.Credentials IS NOT NULL
                 THEN tblDoctor.FirstName + ' ' + tblDoctor.LastName + ', '
                      + tblDoctor.Credentials
                 ELSE tblDoctor.[Prefix] + ' ' + tblDoctor.FirstName + ' '
                      + tblDoctor.LastName
            END AS DoctorName ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblAcctHeader.ClientCode AS InvClientCode ,
            tblAcctHeader.CompanyCode AS InvCompanyCode ,
            InvCl.LastName + ', ' + InvCl.FirstName AS InvClientName ,
            InvCom.IntName AS InvCompanyName ,
            tblCase.Priority ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS adjusteremail ,
            tblClient.Fax AS adjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.BatchNbr ,
            tblCase.ServiceCode ,
            tblAcctHeader.OfficeCode ,
            tblDoctor.DoctorCode ,
            tblAcctHeader.ApptDate ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr ,
            tblAcctDetail.extendedamount ,
            tblproduct.INglacct ,
            tblproduct.VOglacct ,
            tblAcctDetail.longdesc,
			IIF(ISNULL(TaxCode1,'')<>'', TaxCode1 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode2,'')<>'', TaxCode2 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode3,'')<>'', TaxCode3 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode4,'')<>'', TaxCode4 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode5,'')<>'', TaxCode5 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode6,'')<>'', TaxCode6 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode7,'')<>'', TaxCode7 + CHAR(13) + CHAR(10) , '') +
			IIF(ISNULL(TaxCode8,'')<>'', TaxCode8 + CHAR(13) + CHAR(10) , '') AS taxcode,
			IIF(ISNULL(TaxAmount1,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount1) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount2,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount2) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount3,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount3) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount4,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount4) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount5,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount5) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount6,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount6) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount7,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount7) + CHAR(13) + CHAR(10), '') +
			IIF(ISNULL(TaxAmount8,'')<>'', '$' + CONVERT(VARCHAR, TaxAmount8) + CHAR(13) + CHAR(10), '') AS taxamount
    FROM    tblAcctHeader
			INNER JOIN tblAcctDetail ON tblAcctDetail.HeaderID = tblAcctHeader.HeaderID
            INNER JOIN tblProduct ON tblAcctDetail.prodcode = tblProduct.prodcode
            INNER JOIN tblCase ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblClient AS InvCl ON tblAcctHeader.ClientCode = InvCl.ClientCode
            LEFT OUTER JOIN tblCompany AS InvCom ON tblAcctHeader.CompanyCode = InvCom.CompanyCode
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
PRINT N'Creating [dbo].[vwApptLog2]...';


GO

CREATE VIEW vwApptLog2
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.DateAdded ,
			tblCase.DateAdded AS CaseDateAdded,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
	        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes AS DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            vwCaseAppt.Specialties AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<vwCaseAppt.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            '' AS ProvTypeCode , 
			tblCase.ExtCaseNbr 
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9
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
PRINT N'Creating [dbo].[vwApptLogByAppt2]...';


GO

CREATE VIEW vwApptLogByAppt2
AS
    SELECT
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS Client,
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
        '' AS DateAdded,
        tblCase.DateAdded AS CaseDateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description AS Specialty,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        GETDATE() AS today,
        tblCase.QARep AS QARepcode,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
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
        tblDoctor.Phone AS DoctorPhone,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS DoctorSortName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
        tblCase.ExtCaseNbr
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
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
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
<button id="Btn_143300" getEnabled="Ribbon_GetEnabled" label="Flash Report" showImage="false" tag="None|Open_frmFlashReportParams|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143400" getEnabled="Ribbon_GetEnabled" label="Invoice Register" showImage="false" tag="None|Open_FrmInvoiceRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143500" getEnabled="Ribbon_GetEnabled" label="Voucher Register" showImage="false" tag="None|Open_FrmVoucherRegister|None" onAction="Ribbon_ButtonAction" size="normal" />

<button id="Btn_143600" getEnabled="Ribbon_GetEnabled" screentip="Print Fee Schedule Listing" label="Fee Schedule Listing" showImage="false" tag="None|Open_frmFeeSchedRptParam|None" onAction="Ribbon_ButtonAction" size="normal" />

</group>
</tab>
<tab id="Tab_150000" getVisible="Ribbon_GetVisible" label="Report">
<group id="Grp_151000" getVisible="Ribbon_GetVisible" label="Appointment">
<button id="Btn_151100" getEnabled="Ribbon_GetEnabled" label="Appointment Log" showImage="false" tag="None|Open_FrmApptLogParams2|None" onAction="Ribbon_ButtonAction" size="normal" />

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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_InitData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_InitData]
AS

--
-- Hartford Data Initialization
--

SET NOCOUNT ON 

-- Drop and create temp tables
IF OBJECT_ID('tempdb..##tmp_HartfordOfficeMap') IS NOT NULL DROP TABLE ##tmp_HartfordOfficeMap
IF OBJECT_ID('tempdb..##tmp_HartfordSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSpecialtyMap
IF OBJECT_ID('tempdb..##tmp_HartfordSubSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSubSpecialtyMap

-- Create Office Mapping Table
CREATE TABLE ##tmp_HartfordOfficeMap (
	Id INT NOT NULL Primary Key Identity (1,1),
	CurrentOfficeName VarChar(64),
	NewOfficeName VarChar(64),
	IsLawOffice bit 
)

-- Create Specialty Mapping Table
CREATE TABLE ##tmp_HartfordSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Create Sub-Specialty Mapping Table
create table ##tmp_HartfordSubSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Insert data into Office Mapping
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Auto Managed Care (AMC)','Auto Managed Care',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Central WC','Central WC Claim Center',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Centralized Claims WC','Centralized WC Services',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Claim Plus WC','ClaimPlus WC Claim Center',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern Auto Center (ABI)','Eastern Auto Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern Auto Lit Plus Office','Eastern Auto Lit Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern AutoLit','Eastern Auto Lit Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern GL','Eastern GL Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern GL Litigation Plus','Eastern GL Litigation',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern Liability Major Case','Liability Major Case',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Eastern WC','Eastern WC Claim Center',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Major Case WC','WC Major Case',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('WC Field Operations East','Eastern WC Claim Center',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Western AutoLit','Western Auto Lit Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Western GL','Western GL Office',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Western GL Litigation Plus','Western GL Litigation',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Western WC','Western WC Claim Center',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('ClaimWC Claim Center','Can’t tell which office this is',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-Group-RE DCS','GroupRE DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD West THAA','LTD West THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD West DCS','LTD West DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD East THAA','LTD East THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD East DCS','LTD East DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD-West DCS','LTD West DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD-East THAA','LTD East THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-CAR DCS','CAR DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-CAR THAA','CAR THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-SIU DCS','SIU DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD-East DCS','LTD East DCS',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-LTD-West THAA','LTD West THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('GB-SIU THAA','SIU THAA',0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Linda S Baumann Law Offices - NJ East Windsor','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - FL Maitland (CAR)','GB East', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Specialized Unit (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - MD Hunt Valley (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - FL Lake Mary (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX Houston (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX San Antonio (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Diana Lee Khachaturian','PL-Central', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('John A. Hauser Law Offices - CA Brea','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Sacramento (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Rancho Cordova (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - CA Sacramento','GB West	', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - OR Lake Oswego','PL-Western	', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - OR Lake Oswego (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - WA Seattle','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (PL - Western)','PL - Western', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - IL Aurora (CWCCC)','CWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Hartford (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Remote (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Windsor (PL - Northeast)','PL - Northeast', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Stewart H. Friedman - NY Garden City','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - ID Boise','The Hartford - ID Boise', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - TX San Antonio','Hartford Underwriters Insurance Company - TX San Antonio', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - KY Lexington','Hartford Underwriters Insurance Company - KY Lexington', 0)

-- Insert Data into Specialty Mapping
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Urology', 'Urology	')


-- Insert Data into Sub-Specialty Mapping
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Urology', 'Urology	')

print 'Temp tables created'

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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
AS

--
-- Hartford Data patching 
--

set nocount on 

Print 'Fixing up Company Names'

-- fix up the Company Names 
UPDATE hi SET hi.IntName = isnull(hm.NewOfficeName, hi.IntName), hi.LitOrAppeal = IIF(hm.IsLawOffice = 1, 'Litigation', 'NA')
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordOfficeMap as hm on hi.IntName = hm.CurrentOfficeName

Print 'Fixing up Specialties and Sub-Specialties'
-- fix up the specialities
UPDATE hi SET hi.Specialty = isnull(sm.NewSpecialtyName, hi.Specialty)
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordSpecialtyMap as sm on hi.Specialty = sm.CurrentSpecialtyName

-- fix up the sub-specialities
UPDATE hi SET hi.SubSpecialty = isnull(ssm.NewSpecialtyName, hi.SubSpecialty)
	from ##tmp_HartfordInvoices as hi
 	left outer join ##tmp_HartfordSubSpecialtyMap as ssm on hi.SubSpecialty = ssm.CurrentSpecialtyName
	
Print 'Fixing up Service Types'
UPDATE hi SET hi.ServiceType = CASE 
								WHEN hi.ServiceTypeID = 1 THEN 'IME'
								WHEN hi.ServiceTypeID = 2 THEN 'Addendum - MRR'
								WHEN hi.ServiceTypeID = 3 THEN 'Addendum - MRR'
								WHEN hi.ServiceTypeID = 4 THEN 'MRR'
								WHEN hi.ServiceTypeID = 5 THEN 'MRR'
								WHEN hi.ServiceTypeID = 6 THEN 'MRR'
								WHEN hi.ServiceTypeID = 7 THEN 'Other'
								WHEN hi.ServiceTypeID = 8 THEN 'Addendum - IME'
								WHEN hi.ServiceTypeID = 9 THEN 'Other'
								WHEN hi.ServiceTypeID = 10 THEN 'IME'
								ELSE 'Other'
							  END
FROM ##tmp_HartfordInvoices as hi

Print 'Check for FCE services via Sub-Speciality'
UPDATE hi SET hi.ServiceType = CASE
								WHEN hi.SubSpecialty like '%FCE%' THEN 'FCE'
								ELSE hi.ServiceType
							   END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Line of Business'
UPDATE hi SET hi.LOB = CASE hi.LOB
						WHEN '1' THEN 'Liability'
						WHEN '2' THEN 'Auto'
						WHEN '3' THEN 'Work Comp'
						WHEN '4' THEN 'Group Benefits'
						WHEN '5' THEN 'Auto'
						ELSE 'Work Comp'
                       END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Coverage Types'
UPDATE hi SET hi.CoverageType = CASE 
									WHEN hi.CoverageType = 'Workers Comp' THEN 'Work Comp'
									WHEN hi.CoverageType like 'First Party Auto' THEN 'AMC'
									WHEN hi.CoverageType like 'Third Party Auto' THEN 'Auto Lit'
									WHEN hi.CoverageType = 'Liability' THEN 'Liability'
									WHEN hi.CoverageType = 'Disability' THEN 'LTD'									
									WHEN hi.CoverageType = 'Other' AND hi.ServiceTypeID = 3 THEN 'ABI'
									ELSE 'Other'
								END
from ##tmp_HartfordInvoices as hi

Print 'Fixing up Network and Juris TAT'
UPDATE hi SET hi.InOutNetwork = CASE 
									WHEN hi.InOutNetwork = '1' THEN 'Out'
									WHEN hi.InOutNetwork = '2' THEN 'In'
									ELSE 'N/A'
								END,
		      hi.JurisTAT = CASE 
								WHEN hi.ServiceVariance > 0 THEN 'No'
								ELSE 'Yes'				
		                    END			  
FROM ##tmp_HartfordInvoices as hi

Print 'Set Service Variance to NULL (per the spec)'
UPDATE hi SET ServiceVariance = NULL 
  FROM ##tmp_HartfordInvoices as hi
  
Print 'Getting Exception Data'
UPDATE hi SET hi.PrimaryException = CASE 
									WHEN (SRD.DisplayOrder = 1 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
									ELSE ''
								 END,
			  hi.SecondaryException = CASE
									WHEN (SRD.DisplayOrder = 2 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
								    ELSE ''
								 END,
			  Comments = ISNULL(Comments, '') + ISNULL(SE.Descrip + ' ', '')

FROM ##tmp_HartfordInvoices as hi
	LEFT OUTER JOIN tblSLARule as SR on hi.SLARuleID = SR.SLARuleID
	LEFT OUTER JOIN tblSLARuleDetail as SRD on SR.SLARuleID = SRD.SLARuleID
	LEFT OUTER JOIN tblCaseSLARuleDetail as CSRD ON (hi.CaseNbr = CSRD.CaseNbr AND SRD.SLARuleDetailID = CSRD.SLARuleDetailID)
	LEFT OUTER JOIN tblSLAException as SE ON CSRD.SLAExceptionID = SE.SLAExceptionID
	

Print 'Update Primary and Secondary Exceptions'
UPDATE hi SET PrimaryDriver = CASE 
									WHEN hi.PrimaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.PrimaryException = 'CL' THEN 'Provider'
									WHEN hi.PrimaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.PrimaryException = 'NS' THEN 'Claimant'
									WHEN hi.PrimaryException = 'SA' THEN 'Provider'
									WHEN hi.PrimaryException = 'SR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'AR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'C' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'NA' THEN 'NA'
                                 END,
				SecondaryDriver = CASE 
									WHEN hi.SecondaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.SecondaryException = 'CL' THEN 'Provider'
									WHEN hi.SecondaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.SecondaryException = 'NS' THEN 'Claimant'
									WHEN hi.SecondaryException = 'SA' THEN 'Provider'
									WHEN hi.SecondaryException = 'SR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'AR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'C' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'NA' THEN 'NA'
                                 END
FROM ##tmp_HartfordInvoices as hi

-- get medrec page counts
--print 'Get Medical Page Counts'
--UPDATE hi SET MedRecPages = IIF(ISNULL(tblCD.Pages, '') = '', 'N/A', CONVERT(VARCHAR(12), tblCD.Pages))
--   FROM ##tmp_HartfordInvoices as hi
--		INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY CD.CaseNbr ORDER BY CD.SeqNo DESC) as ROWNUM,
--					CD.CaseNbr,
--					CD.Pages
--					FROM tblCaseDocuments as CD
--					WHERE CD.Description like '%MedIndex%') as tblCD ON tblCD.CaseNbr = hi.CaseNbr
--		WHERE tblCD.ROWNUM = 1


-- update the main table with the most recent quote information
print 'Get Most recent FeeQuote for Case'
UPDATE hi SET hi.InitialQuoteAmount = CASE (ISNULL(hi.InvApptStatus, hi.ApptStatus))
									WHEN 'Late Canceled'	THEN tbl.LateCancelAmt
									WHEN 'Canceled'			THEN tbl.NoShowAmt
									WHEN 'No Show'			THEN tbl.NoShowAmt
									ELSE
										CASE
											WHEN tbl.ApprovedAmt IS NOT NULL THEN tbl.ApprovedAmt
											ELSE ISNULL(tbl.FeeAmtTo, tbl.FeeAmtFrom)
										END
									END	          
  FROM ##tmp_HartfordInvoices as hi
	INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY AQ.CaseNbr, AQ.DoctorCode ORDER BY AQ.AcctQuoteID DESC) as ROWNUM,
					AQ.CaseNbr,
					AQ.DoctorCode,
					CONVERT(VARCHAR(12), AQ.LateCancelAmt)	AS LateCancelAmt,
					CONVERT(VARCHAR(12), AQ.NoShowAmt)		AS NoShowAmt,		
					CONVERT(VARCHAR(12), AQ.FeeAmtFrom)		AS FeeAmtFrom,
					CONVERT(VARCHAR(12), AQ.FeeAmtTo)		AS FeeAmtTo,
					CONVERT(VARCHAR(12), AQ.ApprovedAmt)	AS ApprovedAmt					
	              FROM tblAcctQuote as AQ 				      
			      WHERE AQ.QuoteType = 'IN') as tbl ON tbl.CaseNbr = hi.CaseNbr AND tbl.DoctorCode = hi.DoctorCode
				  WHERE tbl.ROWNUM = 1

-- 
-- Determine the meds received date
--

--get date first scheduled
Update T
set t.FirstScheduled = (select top 1 ca.dateadded from tblcaseappt ca where ca.casenbr = t.casenbr order by ca.caseapptid) 
from ##tmp_HartfordInvoices as T

--get date last scheduled
Update T
set t.LastScheduled = (select top 1 ca.dateadded from tblcaseappt ca where ca.casenbr = t.casenbr order by ca.caseapptid desc) 
from ##tmp_HartfordInvoices as T

--Determine date of last MedIndexFinal Med Rec File
update T
set t.LastMedIndexFinalDate = (select top 1 cd.dateadded 
								 from tblcasedocuments cd with (NOLOCK) 
								where cd.casenbr = t.casenbr  
								  and cd.description like '%MedIndex%' 
								order by cd.dateadded desc),
t.MedIndexpages = (select top 1 cd.pages 
				     from tblcasedocuments cd with (NOLOCK) 
					where cd.casenbr = t.casenbr   
					  and cd.description like '%MedIndex%' 
					 order by cd.dateadded desc)
from ##tmp_HartfordInvoices as T

--Determine the last Medical Record file Added to the case that is not called Referral File and is not added by EWIS (DPS)
update T
set t.LastMedsReceived = (select top 1 cd.dateadded 
                            from tblcasedocuments cd with (NOLOCK) 
						   where cd.casenbr = t.casenbr 
						     and cd.CaseDocTypeID in (7,8,9,10,11) 
							 and cd.useridadded <> 'EWIS' 
							 and cd.[description] <> 'Referral File' 
						   order by cd.dateadded desc),
t.pages = (select sum(cd.pages) 
             from tblcasedocuments cd with (NOLOCK) 
            where cd.casenbr = t.casenbr 
			  and cd.CaseDocTypeID in (7,8,9,10,11) 
			  and cd.useridadded <> 'EWIS' 
			  and cd.[description] <> 'Referral File'  
            group by cd.casenbr)
from ##tmp_HartfordInvoices as T

--Determine the last shared medical record file added to the case that is not called Referral File and is not added by EWIS (DPS)
update T
set t.LastSharedMedsReceived = (select top 1 cd.dateadded 
                                  from tblcasedocuments cd with (NOLOCK) 
                                 where cd.mastercasenbr = t.Mastercasenbr 
								   and cd.shareddoc = 1 
								   and cd.CaseDocTypeID in (7,8,9,10,11) 
								   and cd.useridadded <> 'EWIS' 
								   and cd.[description] <> 'Referral File'  
							  order by cd.dateadded Desc),
t.sharedpages =  (select sum(cd.pages) 
					from tblcasedocuments cd with (NOLOCK) 
				   where cd.mastercasenbr = t.Mastercasenbr 
				     and cd.shareddoc = 1 
					 and cd.CaseDocTypeID in (7,8,9,10,11) 
					 and cd.useridadded <> 'EWIS' 
					 and cd.[description] <> 'Referral File'  
			    group by cd.mastercasenbr)
from ##tmp_HartfordInvoices as T

--If No medical records exist on the case but shared medical records exist, use the date of the last shared medical records
Update T
set t.LastMedsReceived = case when t.Lastmedsreceived is null and t.LastSharedMedsReceived is not null then t.LastSharedMedsReceived else t.LastMedsReceived end
from ##tmp_HartfordInvoices as T

--If no medical record files exist but there is a MedIndexFinalDate, use that date for LastMedsReceived
Update T
set t.LastMedsReceived = case when t.Lastmedsreceived is null and t.LastMedIndexFinalDate is not null then t.LastMedIndexFinalDate else t.lastMedsreceived end
from ##tmp_HartfordInvoices as T

--If the LastMedsReceived date is before the current case was added, then make the LastMedsReceived = case date added.  This is caused mostly by shared med rec files from other cases.
Update T
set t.LastMedsReceived = case when t.Lastmedsreceived  < t.caseadded then t.caseadded else t.Lastmedsreceived end
from ##tmp_HartfordInvoices as T

-- patch date scheduled 
Update t
  set t.DateScheduled = case 
							when t.ServiceType = 'MRR' then t.LastMedsReceived 
							else ISNULL(t.DateScheduled, t.FirstScheduled) 
						end
from ##tmp_HartfordInvoices as t

-- patch data rescheduled to null if only 1 appt
update t
	set t.DateRescheduled = IIF(t.LastScheduled = t.FirstScheduled, NULL, t.DateRescheduled)
from ##tmp_HartfordInvoices as t

-- patch referral status
update t
	set t.ReferralStatus =  case
								when ServiceTypeID = 2 then 'Addendum Completed'
								when ServiceTypeID = 3 then 'Addendum Completed'
								when ServiceTypeID = 8 then 'Addendum Completed'
								when ServiceTypeID = 4 then 'MRR Completed'
								when ServiceTypeID = 5 then 'MRR Completed'
								when ServiceTypeID = 6 then 'MRR Completed'
								else t.ReferralStatus
							end
from ##tmp_HartfordInvoices as t

-- return file result set
select * 
	from ##tmp_HartfordInvoices

set nocount off
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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
	'ExamWorks' as Vendor,
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(14), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	CASE 
		WHEN FZ.StateCode = 'NY' THEN IIF(FZ.Name = 'New York (Downstate)', 'NY-downstate', 'NY-upstate')
		ELSE ISNULL(AH.ServiceState, C.Jurisdiction) 
	END as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",	
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ca.datereceived as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(8)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments,
	c.DoctorReason,
	ISNULL(ca.ApptTime, c.ApptTime) as "DateRescheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "SchedulingComplete",
	ISNULL(C.TATAwaitingScheduling, 0) / 8 as "RescheduledSchedulingTAT",
	C.TATReport as "ReportDelvred",
	isnull([PeerReview],0) as DiagViewFee,
	isnull([AddReview], 0) as ExcessRecFee,
    isnull([Diag], 0) as DiagTestingFee,	
    -- note: if you add/remove categories from the "other" list below, make sure you update the other service description list in patch data
    (isnull([Interpret],0) + isnull([Trans],0) + isnull([BillReview],0) + isnull([Legal],0) + isnull([Processing],0) + isnull([Nurse],0)
	+ isnull(ft.[Phone],0) + isnull([MSA],0) + isnull([Clinical],0) + isnull([Tech],0) + isnull([Medicare],0) + isnull([OPO],0) 
	+ isnull([Rehab],0)	+ isnull([AdminFee],0) + isnull([FacFee],0) + isnull([Other],0)) as Other,
	0 AS [SurveillanceReviewFee],
	isnull([Mileage], 0) as [ClaimantMileagePrepay],
	0 as RushFee,
	ft.[No Show],
	ft.Other as OtherFee,
	CONVERT(VARCHAR(12), 'N/A') as MedRecPages, 
	CONVERT(VARCHAR(32), 
	case APS.ApptStatusID
		 when 101 then 'No Show'
	     when 102 then 'Unable to Examine'
		 when 51  then 'Late Cancel'
		 when 100 then 		 
			case EWS.EWServiceTypeID
			     when 1 then 
					case S.ShortDesc
						when 'FCE' then 'FCE'
					    else 'IME took place'
				 end
				 when 8 then 'Addendum Complete'
			     when 3 then 'MRR Complete'
			end	
		 else ''
	end) as ReferralStatus,
	AHAS.Name as InvApptStatus,
	CONVERT(MONEY, NULL) as InitialQuoteAmount,
	CASE 
		WHEN (AH.DrOpType = 'DR') THEN AH.DrOpCode		
		ELSE NULL
	END as DoctorCode,
	c.MasterCaseNbr,
	c.DateReceived as CaseAdded,
	CAST(NULL as datetime) as FirstScheduled,
	CAST(NULL as datetime) as LastScheduled,
	CAST(NULL as datetime) as tmpFirstMedsReceived,
	CAST(NULL as datetime) as FirstMedsReceived,
	CAST(NULL as datetime) as FirstSharedMedsReceived,
	CAST(NULL as datetime) as tmpLastMedsReceived,
	CAST(NULL as datetime) as LastMedsReceived,
	CAST(NULL as datetime) as LastSharedMedsReceived,
	CAST(NULL as datetime) as LastMedIndexFinalDate,
	CAST(NULL as int) as MedIndexPages,
	CAST(NULL as int) as Pages,
	CAST(NULL as int) as SharedPages

INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as AHCA on AH.CaseApptID = AHCA.CaseApptID
	left outer join tblEWFeeZone as FZ on C.EWFeeZoneID = FZ.EWFeeZoneID
	left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID	
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
LEFT OUTER JOIN
(
  select Pvt.*
  from (
    select
      AD.HeaderID,
      isnull(case when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID in (51,102) then 'Late Canceled'
                  when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID = 101 then 'No Show'
                  else EWFC.Mapping5 end, 'Other') as FeeColumn,
      AD.ExtendedAmount	
    from tblCase as C
    inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
    inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
    inner join tblProduct as P on P.ProdCode = AD.ProdCode
    inner join tblCaseType as CT on C.CaseType = CT.Code
    inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
    inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
    left outer join tblApptStatus as A on A.ApptStatusID = AH.ApptStatusID
  ) as tmp
  pivot
  (
    sum(ExtendedAmount) --aggregrate function that give the value for the columns from FeeColumn
    for FeeColumn in (  --list out the values in FeeColumn that need to be a column
      [FeeAmount],
      [No Show],
      [Late Canceled],
      [Interpret],
      [Trans],
	  [Mileage],
      [Diag],
      [BillReview],
      [PeerReview],
      [Addendum],
      [Legal],
      [Processing],
      [Nurse],
      [Phone],
      [MSA],
      [Clinical],
      [Tech],
      [Medicare],
      [OPO],
      [Rehab],
      [AddReview],
      [AdminFee],
      [FacFee],
      [Other])
  ) as Pvt
) as FT on FT.HeaderID = AH.HeaderID

WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

print 'Data retrieved'
set nocount off
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
-- Sprint 102

-- IMEC-13314 - update/modify business rule for Gallagher Basset Employer names
    -- delete duplicate business rule
     DELETE FROM tblBusinessRule WHERE BusinessRuleID = 108
     GO
     -- upate existing business rules
     UPDATE tblBusinessRule 
        SET Param4Desc = 'EmployerNameMsg'
      WHERE BusinessRuleID = 104
     GO
     UPDATE tblBusinessRuleCondition
        SET Param4 = CASE 
                         WHEN Param3 = '525' THEN 'Sodexo'
                         WHEN Param3 = '39223' THEN 'Elite Staffing LLC'
                         ELSE Param3
                    END
      WHERE BusinessRuleID = 104
      GO
     -- add new business rules
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     VALUES (104, 'PC', 25, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, '002456', NULL, '55453,59557', 'First Transit or First Student', NULL, 0, NULL)
     GO


