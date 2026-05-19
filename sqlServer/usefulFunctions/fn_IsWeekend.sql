SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    /*
     Function: dbo.fn_IsWeekend
     
     Description:
     Checks whether the provided date falls on a weekend.
     The function returns:
     - 1 = Saturday or Sunday
     - 0 = Weekday
     
     Example usage:
     SELECT dbo.fn_IsWeekend('2026-05-16') AS IsWeekend;
     
     SELECT
     OrderDate,
     dbo.fn_IsWeekend(OrderDate) AS IsWeekend
     FROM dbo.Orders;
     */
    ALTER FUNCTION [dbo].[fn_IsWeekend] (@Date DATE) RETURNS BIT AS BEGIN RETURN CASE
        WHEN DATENAME(WEEKDAY, @Date) IN ('Saturday', 'Sunday') THEN 1
        ELSE 0
    END;

END;

GO
