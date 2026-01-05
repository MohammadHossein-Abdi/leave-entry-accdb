SELECT E.EmployeeType AS [نوع عضویت], E.FolderID AS [شماره پرونده], E.EmployeeFirstName AS نام, E.EmployeeLastName AS [نام خانوادگی], E.EmployeeID, E.IdentificationID AS [کد ملی], LT.LeaveName AS [عنوان مرخصی], LT.LeaveUnit AS [واحد مرخصی], LT.AnnualLimit AS [سقف مجاز], Nz(SUM(IIF(LT.LeaveUnit='روز', LR.DaysUsed, LR.HoursUsed)), 0) AS LeaveUsed, IIF(
        Nz(SUM(IIF(LT.LeaveUnit='روز', LR.DaysUsed, LR.HoursUsed)), 0) >= LT.AnnualLimit,
        'اتمام سقف مجاز',
        IIF(
            Nz(SUM(IIF(LT.LeaveUnit='روز', LR.DaysUsed, LR.HoursUsed)), 0) >= (0.8 * LT.AnnualLimit),
            'نزدیک به سقف مجاز',
            'عادی'
        )
    ) AS LeaveStatus
FROM (EmployeeUnionQuery AS E INNER JOIN LeaveRecords AS LR ON E.EmployeeID = LR.EmployeeID) INNER JOIN LeaveTypes AS LT ON LR.LeaveTypeID = LT.LeaveTypeID
GROUP BY E.EmployeeType, E.FolderID, E.EmployeeID, E.IdentificationID, E.EmployeeFirstName, E.EmployeeLastName, LT.LeaveName, LT.LeaveUnit, LT.AnnualLimit;
