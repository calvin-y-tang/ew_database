CREATE TABLE [dbo].[tblExaminee] (
    [ChartNbr]                     INT          IDENTITY (1, 1) NOT NULL,
    [OldChartNbr]                  VARCHAR (15) NULL,
    [LastName]                     VARCHAR (50) NULL,
    [FirstName]                    VARCHAR (50) NULL,
    [MiddleInitial]                VARCHAR (5)  NULL,
    [Addr1]                        VARCHAR (50) NULL,
    [Addr2]                        VARCHAR (50) NULL,
    [City]                         VARCHAR (50) NULL,
    [State]                        VARCHAR (2)  NULL,
    [Zip]                          VARCHAR (10) NULL,
    [Phone1]                       VARCHAR (15) NULL,
    [Phone2]                       VARCHAR (15) NULL,
    [SSN]                          VARCHAR (15) NULL,
    [Sex]                          VARCHAR (10) NULL,
    [DOB]                          DATETIME     NULL,
    [DateAdded]                    DATETIME     NULL,
    [DateEdited]                   DATETIME     NULL,
    [UserIDAdded]                  VARCHAR (15) NULL,
    [UserIDEdited]                 VARCHAR (15) NULL,
    [Note]                         TEXT         NULL,
    [County]                       VARCHAR (50) NULL,
    [Prefix]                       VARCHAR (10) NULL,
    [USDVarchar1]                  VARCHAR (50) NULL,
    [USDVarchar2]                  VARCHAR (50) NULL,
    [USDDate1]                     DATETIME     NULL,
    [USDDate2]                     DATETIME     NULL,
    [USDText1]                     TEXT         NULL,
    [USDText2]                     TEXT         NULL,
    [USDInt1]                      INT          NULL,
    [USDInt2]                      INT          NULL,
    [USDMoney1]                    MONEY        NULL,
    [USDMoney2]                    MONEY        NULL,
    [Fax]                          VARCHAR (15) NULL,
    [Email]                        VARCHAR (50) NULL,
    [Insured]                      VARCHAR (50) NULL,
    [Employer]                     VARCHAR (70) NULL,
    [TreatingPhysician]            VARCHAR (70) NULL,
    [InsuredAddr1]                 VARCHAR (70) NULL,
    [InsuredCity]                  VARCHAR (70) NULL,
    [InsuredState]                 VARCHAR (5)  NULL,
    [InsuredZip]                   VARCHAR (10) NULL,
    [InsuredSex]                   VARCHAR (10) NULL,
    [InsuredRelationship]          VARCHAR (20) NULL,
    [InsuredPhone]                 VARCHAR (15) NULL,
    [InsuredPhoneExt]              VARCHAR (10) NULL,
    [InsuredFax]                   VARCHAR (15) NULL,
    [InsuredEmail]                 VARCHAR (70) NULL,
    [ExamineeStatus]               VARCHAR (30) NULL,
    [TreatingPhysicianAddr1]       VARCHAR (70) NULL,
    [TreatingPhysicianCity]        VARCHAR (70) NULL,
    [TreatingPhysicianState]       VARCHAR (5)  NULL,
    [TreatingPhysicianZip]         VARCHAR (10) NULL,
    [TreatingPhysicianPhone]       VARCHAR (15) NULL,
    [TreatingPhysicianPhoneExt]    VARCHAR (10) NULL,
    [TreatingPhysicianFax]         VARCHAR (15) NULL,
    [TreatingPhysicianEmail]       VARCHAR (70) NULL,
    [EmployerAddr1]                VARCHAR (70) NULL,
    [EmployerCity]                 VARCHAR (70) NULL,
    [EmployerState]                VARCHAR (5)  NULL,
    [EmployerZip]                  VARCHAR (10) NULL,
    [EmployerPhone]                VARCHAR (15) NULL,
    [EmployerPhoneExt]             VARCHAR (10) NULL,
    [EmployerFax]                  VARCHAR (15) NULL,
    [EmployerEmail]                VARCHAR (70) NULL,
    [Country]                      VARCHAR (50) NULL,
    [PolicyNumber]                 VARCHAR (70) NULL,
    [EmployerContactFirstName]     VARCHAR (50) NULL,
    [EmployerContactLastName]      VARCHAR (50) NULL,
    [TreatingPhysicianLicenseNbr]  VARCHAR (50) NULL,
    [TreatingPhysicianTaxID]       VARCHAR (50) NULL,
    [TreatingPhysicianCredentials] VARCHAR (50) NULL,
    [TreatingPhysicianDiagnosis]   VARCHAR (70) NULL,
	[MobilePhone]				   VARCHAR (15) NULL,
    [TreatingPhysicianNPINbr]      VARCHAR (20) NULL, 
	[WorkPhone]					   VARCHAR (15) NULL,
    CONSTRAINT [PK_tblExaminee] PRIMARY KEY CLUSTERED ([ChartNbr] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_SSN]
    ON [dbo].[tblExaminee]([SSN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB]
    ON [dbo].[tblExaminee]([LastName] ASC, [FirstName] ASC, [MiddleInitial] ASC, [ChartNbr] ASC, [City] ASC, [State] ASC, [Phone1] ASC, [DOB] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_ChartNbr]
    ON [dbo].[tblExaminee]([ChartNbr] ASC)
    INCLUDE([LastName], [FirstName], [Sex]);

