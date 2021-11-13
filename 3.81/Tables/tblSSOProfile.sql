CREATE TABLE [dbo].[tblSSOProfile]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [EntityType] CHAR(2) NOT NULL, 
    [EntityID] INT NOT NULL, 
    [SSOEntityID] VARCHAR(255) NULL, 
	[SSOType] INT NULL,
    [AuthType] INT NULL, 
    [IdentityProviderName] VARCHAR(128) NULL, 
    [SAMLURL] VARCHAR(255) NULL, 
    [UserIDAdded] VARCHAR(20) NOT NULL, 
    [DateAdded] DATETIME NOT NULL, 
    [UserIDEdited] VARCHAR(20) NOT NULL, 
    [DateEdited] DATETIME NOT NULL, 
    [MatchType] INT NOT NULL, 
    [Active] BIT NOT NULL, 
    [AllowAutoProvision] BIT NOT NULL, 
    [AutoProvisionCompanyCode] INT NULL, 
    [AutoProvisionEmail] VARCHAR(2048) NULL, 
    [WebCompanyID] INT NULL, 
    [DefaultEWTimeZoneID] INT NULL    
)

GO
