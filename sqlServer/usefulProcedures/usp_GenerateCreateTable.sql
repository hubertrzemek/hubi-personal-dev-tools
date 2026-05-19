SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Procedure: dbo.usp_GenerateCreateTable
     
     Description:
     Generates a basic CREATE TABLE script for an existing table.
     The procedure reads column metadata from the current database and returns
     a CREATE TABLE statement with column names, data types, NULL settings,
     and IDENTITY information.
     
     Example usage:
     EXEC dbo.usp_GenerateCreateTable
     @SchemaName = N'dbo',
     @TableName = N'Customers';
     
     EXEC dbo.usp_GenerateCreateTable
     @SchemaName = N'WMS',
     @TableName = N'Stock';
     */
    ALTER PROCEDURE [dbo].[usp_GenerateCreateTable] (
        @SchemaName SYSNAME,
        @TableName SYSNAME
    ) AS BEGIN
SET
    NOCOUNT ON;

DECLARE @ObjectId INT;

DECLARE @Sql NVARCHAR(MAX) = '';

DECLARE @Columns NVARCHAR(MAX) = '';

SET
    @ObjectId = OBJECT_ID (
        QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName)
    );

IF @ObjectId IS NULL BEGIN THROW 50001,
'Table not found.',
1;

END;

SELECT
    @Columns = @Columns + '    ' + QUOTENAME(c.name) + ' ' + CASE
        WHEN t.name IN ('varchar', 'char', 'nvarchar', 'nchar') THEN t.name + '(' + CASE
            WHEN c.max_length = -1 THEN 'MAX'
            WHEN t.name IN ('nvarchar', 'nchar') THEN CAST(c.max_length / 2 AS VARCHAR)
            ELSE CAST(c.max_length AS VARCHAR)
        END + ')'
        WHEN t.name IN ('decimal', 'numeric') THEN t.name + '(' + CAST(c.precision AS VARCHAR) + ',' + CAST(c.scale AS VARCHAR) + ')'
        ELSE t.name
    END + CASE
        WHEN c.is_nullable = 1 THEN ' NULL'
        ELSE ' NOT NULL'
    END + CASE
        WHEN c.is_identity = 1 THEN ' IDENTITY(1,1)'
        ELSE ''
    END + ',' + CHAR(13)
FROM
    sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE
    c.object_id = @ObjectId
ORDER BY
    c.column_id;

SET
    @Columns = LEFT(@Columns, LEN(@Columns) - 2);

SET
    @Sql = 'CREATE TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + CHAR(13) + '(' + CHAR(13) + @Columns + CHAR(13) + ');';

SELECT
    @Sql AS CreateTableScript;

END;

GO
