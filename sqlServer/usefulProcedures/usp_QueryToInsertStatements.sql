SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Procedure: dbo.usp_QueryToInsertStatements
     
     Description:
     Generates INSERT statements from the result of a provided SELECT query.
     The procedure executes the SELECT query, stores the result in a temporary table,
     and returns ready-to-use INSERT statements for the specified target table.
     
     Example usage:
     EXEC dbo.usp_QueryToInsertStatements
     @SelectQuery = N'
     SELECT
     Id,
     CommandName,
     CommandText,
     Description
     FROM dbo.SqlCommands
     WHERE Category = ''Backup''
     ',
     @TargetTable = N'dbo.SqlCommands';
     
     EXEC dbo.usp_QueryToInsertStatements
     @SelectQuery = N'
     SELECT TOP 10 *
     FROM dbo.Users
     ',
     @TargetTable = N'dbo.Users';
     */
    ALTER PROCEDURE [dbo].[usp_QueryToInsertStatements] (
        @SelectQuery NVARCHAR(MAX),
        @TargetTable NVARCHAR(300)
    ) AS BEGIN
SET
    NOCOUNT ON;

DECLARE @Sql NVARCHAR(MAX);

DECLARE @ColumnList NVARCHAR(MAX);

DECLARE @ValuesExpression NVARCHAR(MAX);

IF OBJECT_ID('tempdb..##QueryToInsertResult') IS NOT NULL DROP TABLE ##QueryToInsertResult;
SET
    @Sql = N '
        SELECT *
        INTO ##QueryToInsertResult
        FROM
        (
            ' + @SelectQuery + N'
        ) AS src;
    ';

EXEC sp_executesql @Sql;

SELECT
    @ColumnList = STRING_AGG(QUOTENAME(name), ', ') WITHIN GROUP (
        ORDER BY
            column_id
    )
FROM
    tempdb.sys.columns
WHERE
    object_id = OBJECT_ID('tempdb..##QueryToInsertResult');

SELECT
    @ValuesExpression = STRING_AGG (
        CAST(
            N 'CASE
                    WHEN ' + QUOTENAME(name) + N ' IS NULL THEN ''NULL''
                    ELSE ''''''''
                         + REPLACE(CONVERT(NVARCHAR(MAX), ' + QUOTENAME(name) + N'), ' ''''''', '''''''''''')
                         + ''''''''
                  END' AS NVARCHAR(MAX)
        ),
        N' + ' ', '' + '
    ) WITHIN GROUP (
        ORDER BY
            column_id
    )
FROM
    tempdb.sys.columns
WHERE
    object_id = OBJECT_ID('tempdb..##QueryToInsertResult');

SET
    @Sql = N'
        SELECT
            ' 'INSERT INTO ' + @TargetTable + N' (' + @ColumnList + N') VALUES (' '
            + ' + @ValuesExpression + N'
            + ' ');'' AS InsertStatement
        FROM ##QueryToInsertResult;
    ';

EXEC sp_executesql @Sql;

DROP TABLE ##QueryToInsertResult;
END;

GO
