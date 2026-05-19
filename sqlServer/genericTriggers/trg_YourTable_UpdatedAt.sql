SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Trigger template: set UpdatedAt and optionally UpdatedBy after UPDATE
     
     How to use:
     1. Replace table name:
     dbo.YourTable
     
     2. Replace primary key column:
     Id
     
     3. Make sure the target table has column:
     UpdatedAt DATETIME2 / DATETIME2(7)
     
     4. If you want to store user name, make sure the table has column:
     UpdatedBy NVARCHAR(...)
     
     5. To pass user name from application, use SESSION_CONTEXT:
     
     EXEC sys.sp_set_session_context
     @key = N'UserName',
     @value = N'hubert';
     
     Then run UPDATE on the table.
     
     Notes:
     - SYSUTCDATETIME() stores UTC time.
     - SESSION_CONTEXT is useful when the user name comes from API/application.
     */
    CREATE
    OR ALTER TRIGGER dbo.trg_YourTable_UpdatedAt ON dbo.YourTable
AFTER
UPDATE
    AS BEGIN
SET
    NOCOUNT ON;

/*
 Prevent unnecessary recursive execution.
 
 This trigger updates the same table after UPDATE.
 Without this condition, SQL Server may execute the trigger again
 depending on database trigger settings.
 */
IF TRIGGER_NESTLEVEL() > 1 RETURN;

UPDATE
    t
SET
    t.UpdatedAt = SYSUTCDATETIME(),
    -- Optional:
    -- If you do not want UpdatedBy, remove this line.
    t.UpdatedBy = COALESCE(
        TRY_CAST(SESSION_CONTEXT(N 'UserName') AS NVARCHAR(256)),
        SUSER_SNAME()
    )
FROM
    dbo.YourTable t
    INNER JOIN inserted i ON t.Id = i.Id;

END;

GO
