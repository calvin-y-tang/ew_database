CREATE TABLE [dbo].[EWClientDB] (
    [EWClientID]  INT          NOT NULL,
    [DBID]        INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_EWClientDB] PRIMARY KEY CLUSTERED ([EWClientID] ASC, [DBID] ASC)
);

