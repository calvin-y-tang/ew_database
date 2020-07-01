/*
1. Set the database name and filename
*/

USE [master]
GO
CREATE DATABASE [DrSchAfter] ON 
( FILENAME = N'D:\SQLData\DrSchAfter.mdf' ),
( FILENAME = N'E:\SQLLog\DrSchAfter_log.ldf' )
 FOR ATTACH
GO
