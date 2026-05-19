SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Procedure: dbo.usp_TableRowCounts
     
     Description:
     Returns the number of rows for all tables in the current database.
     The procedure displays schema name, table name, and total row count,
     sorted from the largest table to the smallest.
     
     Example usage:
     EXEC dbo.usp_TableRowCounts;
     */
    ALTER PROCEDURE [dbo].[usp_TableRowCounts] AS BEGIN
SET
    NOCOUNT ON;

SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS Row_Count
FROM
    sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE
    p.index_id IN (0, 1)
GROUP BY
    s.name,
    t.name
ORDER BY
    Row_Count DESC;

END;

GO
