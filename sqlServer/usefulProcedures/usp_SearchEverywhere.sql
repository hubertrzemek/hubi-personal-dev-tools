SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Procedure: dbo.usp_SearchEverywhere
     
     Description:
     Searches for a specified text value across all text-based columns
     in all tables within the current database.
     The procedure returns matching schema names, table names,
     column names, and found values.
     
     Example usage:
     EXEC dbo.usp_SearchEverywhere
     @SearchValue = 'Invoice123';
     
     EXEC dbo.usp_SearchEverywhere
     @SearchValue = 'Hubert';
     */
    ALTER PROCEDURE [dbo].[usp_SearchEverywhere] (@SearchValue NVARCHAR(4000)) AS BEGIN
SET
    NOCOUNT ON;

CREATE TABLE #Results
(
    SchemaName SYSNAME,
    TableName SYSNAME,
    ColumnName SYSNAME,
    FoundValue NVARCHAR(4000)
);

DECLARE @Sql NVARCHAR(MAX) = N'';

SELECT
    @Sql + = N '
    INSERT INTO #Results
    SELECT TOP 20
        N''' + s.name + N'' ',
        N''' + t.name + N'' ',
        N''' + c.name + N'' ',
        LEFT(CAST(' + QUOTENAME(c.name) + N ' AS NVARCHAR(4000)), 4000)
    FROM ' + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name) + N'
    WHERE CAST(' + QUOTENAME(c.name) + N ' AS NVARCHAR(MAX)) LIKE N''%' + REPLACE(@SearchValue, '''', '''''') + N'%' ';'
FROM
    sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE
    ty.name IN (
        'varchar',
        'nvarchar',
        'char',
        'nchar',
        'text',
        'ntext'
    );

EXEC sp_executesql @Sql;

SELECT
    *
FROM
    #Results
ORDER BY
    SchemaName,
    TableName,
    ColumnName;

END;

GO
