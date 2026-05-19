-- ============================================================
-- Description:
-- Extracts all numeric characters from the input string
-- and returns them as a single concatenated value.
--
-- Example:
-- SELECT dbo.fn_ExtractNumbers('ABC123-XYZ45')
-- Result: 12345
-- ============================================================
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    ALTER FUNCTION [dbo].[fn_ExtractNumbers] (@Text NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS BEGIN DECLARE @Result NVARCHAR(MAX) = N'';

DECLARE @i INT = 1;

WHILE @i <= LEN(@Text) BEGIN IF SUBSTRING(@Text, @i, 1) LIKE '[0-9]'
SET
    @Result + = SUBSTRING(@Text, @i, 1);

SET
    @i + = 1;

END;

RETURN @Result;

END;
