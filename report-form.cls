Option Compare Database

Private Sub txtIdentificationID_AfterUpdate()
    Dim rs As DAO.Recordset
    Dim strSQL As String

    strSQL = "SELECT EmployeeFirstName & ' ' & EmployeeLastName AS FullName " & _
             "FROM EmployeeUnionQuery " & _
             "WHERE IdentificationID = '" & Me.txtIdentificationID & "'"

    Set rs = CurrentDb.OpenRecordset(strSQL)
    If Not rs.EOF Then
        Me.txtEmployeeID = rs!fullName
    Else
        Me.txtEmployeeID = ""
        MsgBox "Employee not found for this Identification ID.", vbExclamation, "Error"
    End If
    rs.Close
    Set rs = Nothing
End Sub

Private Sub optReportType_AfterUpdate()
    Select Case Me.optReportType
        Case 1 ' Single Leave Report (Detailed)
            ' Disable Leave Status and clear its value
            Me.cmbLeaveStatus.Value = Null
            Me.cmbLeaveStatus.Enabled = False

            ' Enable date controls
            Me.txtFromDate.Enabled = True
            Me.txtUntilDate.Enabled = True
            Me.btnSelectFromDate.Enabled = True
            Me.btnSelectUntilDate.Enabled = True

        Case 2 ' Summary Leave Report (Aggregate)
            ' Enable Leave Status
            Me.cmbLeaveStatus.Enabled = True

            ' Disable and clear date fields
            Me.txtFromDate = Null
            Me.txtUntilDate = Null
            Me.txtFromDate.Enabled = False
            Me.txtUntilDate.Enabled = False
            Me.btnSelectFromDate.Enabled = False
            Me.btnSelectUntilDate.Enabled = False
    End Select
End Sub

' FromDate from frmCal
Private Sub btnSelectFromDate_Click()
    DoCmd.OpenForm "frmCal", , , , , acDialog
    If IsNumeric(STRDATE) Then
        Me.txtFromDate = CLng(STRDATE)
    Else
        MsgBox "Invalid Date Selected", vbExclamation
    End If
End Sub

' UntilDate from frmCal
Private Sub btnSelectUntilDate_Click()
    DoCmd.OpenForm "frmCal", , , , , acDialog
    If IsNumeric(STRDATE) Then
        Me.txtUntilDate = CLng(STRDATE)
    Else
        MsgBox "Invalid Date Selected", vbExclamation
    End If
End Sub

Private Sub btnGenerateReport_Click()
    Dim reportName As String
    Dim strFilter As String
    Dim strSummary As String
    Dim sql As String
    Dim rs As DAO.Recordset
    Dim fullName As String, empID As String
    Dim idCode As String, fromDate As String, untilDate As String
    
    ' Validation: IdentificationID is required
    If IsNull(Me.txtIdentificationID) Or Me.txtIdentificationID = "" Then
        MsgBox "Please enter the Identification ID.", vbExclamation
        Exit Sub
    End If

    ' Get full name and employee ID from EmployeeUnionQuery
    sql = "SELECT EmployeeID, EmployeeFirstName & ' ' & EmployeeLastName AS FullName " & _
          "FROM EmployeeUnionQuery WHERE IdentificationID = '" & Me.txtIdentificationID & "'"

    Set rs = CurrentDb.OpenRecordset(sql)
    If rs.EOF Then
        MsgBox "Employee not found for this Identification ID.", vbCritical
        Exit Sub
    End If
    
    empID = rs!EmployeeID
    fullName = rs!fullName
    idCode = Me.txtIdentificationID
    rs.Close: Set rs = Nothing

    ' Set filter based on report type
    If Me.optReportType = 1 Then  'Single Leave Report (Detailed)
        reportName = "rptLeaveDetails"
        strFilter = "EmployeeID = " & empID
        
        ' Optional Leave Name filter
        If Not IsNull(Me.cmbLeaveType) Then
            strFilter = strFilter & " AND LeaveName = '" & Me.cmbLeaveType & "'"
        End If

        ' Optional date filters
        If Not IsNull(Me.txtFromDate) Then
            strFilter = strFilter & " AND StartDate >= " & CLng(Me.txtFromDate)
            fromDate = CLng(Me.txtFromDate)
        End If

        If Not IsNull(Me.txtUntilDate) Then
            strFilter = strFilter & " AND StartDate <= " & CLng(Me.txtUntilDate)
            untilDate = CLng(Me.txtUntilDate)
        End If
        
    ElseIf Me.optReportType = 2 Then ' Summary Leave Report (Aggregate)
        reportName = "rptLeaveSummary"
        strFilter = "EmployeeID = " & empID
        
        ' Optional Leave Name filter
        If Not IsNull(Me.cmbLeaveType) Then
            strFilter = strFilter & " AND LeaveName = '" & Me.cmbLeaveType & "'"
        End If
        
        ' Optional Leave Status filter
        If Not IsNull(Me.cmbLeaveStatus) Then
            strFilter = strFilter & " AND LeaveStatus = '" & Me.cmbLeaveStatus & "'"
        End If
    End If

    ' Pass summary as OpenArgs
    DoCmd.OpenReport reportName, acViewPreview, , strFilter, , strSummary
End Sub

Private Sub btnClear_Click()
    On Error Resume Next
    Me.txtIdentificationID = Null
    Me.txtEmployeeID = Null
    Me.cmbLeaveType = Null
    Me.cmbLeaveStatus = Null
    Me.txtFromDate = Null
    Me.txtUntilDate = Null
    On Error GoTo 0
End Sub

Private Sub btnSelectFromDate1_Click()
    DoCmd.OpenForm "frmCal", , , , , acDialog
    If IsNumeric(STRDATE) Then
        Me.txtFromDate1 = CLng(STRDATE)
    Else
        MsgBox "Invalid Date Selected", vbExclamation
    End If
End Sub

Private Sub btnSelectUntilDate1_Click()
    DoCmd.OpenForm "frmCal", , , , , acDialog
    If IsNumeric(STRDATE) Then
        Me.txtUntilDate1 = CLng(STRDATE)
    Else
        MsgBox "Invalid Date Selected", vbExclamation
    End If
End Sub

Private Sub btnMonthlyBackup_Click()
    Dim fromDate As Long, untilDate As Long
    Dim filePath As String
    Dim qdf As DAO.QueryDef
    Dim tempQuery1 As String, tempQuery2 As String
    Dim sql1 As String, sql2 As String

    If IsNull(Me.txtFromDate1) Or IsNull(Me.txtUntilDate1) Then
        MsgBox "Please select both From and Until dates for backup.", vbExclamation
        Exit Sub
    End If

    fromDate = CLng(Me.txtFromDate1)
    untilDate = CLng(Me.txtUntilDate1)

    filePath = CurrentProject.Path & "\MonthlyLeaveBackup_" & Format(Now, "yyyymmdd_hhnnss") & ".xlsx"

    tempQuery1 = "qryTemp_LeaveRecords"
    tempQuery2 = "qryTemp_qrySingleLeave"

    ' Remove any existing temporary queries
    On Error Resume Next
    CurrentDb.QueryDefs.Delete tempQuery1
    CurrentDb.QueryDefs.Delete tempQuery2
    On Error GoTo 0

    ' Create temporary query for LeaveRecords
    sql1 = "SELECT * FROM LeaveRecords WHERE StartDate BETWEEN " & fromDate & " AND " & untilDate
    Set qdf = CurrentDb.CreateQueryDef(tempQuery1, sql1)
    Set qdf = Nothing

    ' Create temporary query for qrySingleLeave
    sql2 = "SELECT * FROM qrySingleLeave WHERE StartDate BETWEEN " & fromDate & " AND " & untilDate
    Set qdf = CurrentDb.CreateQueryDef(tempQuery2, sql2)
    Set qdf = Nothing

    ' Export both queries to Excel
    DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, tempQuery1, filePath, True, "LeaveRecords"
    DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, tempQuery2, filePath, True, "qrySingleLeave"

    ' Delete temporary queries
    CurrentDb.QueryDefs.Delete tempQuery1
    CurrentDb.QueryDefs.Delete tempQuery2

    MsgBox "Backup complete. File saved to:" & vbCrLf & filePath, vbInformation, "Backup Successful"
End Sub

Private Sub btnResetLeaveRecords_Click()
    Dim filePath As String
    Dim confirm As VbMsgBoxResult
    Dim db As DAO.Database
    Dim sqlDelete As String
    Dim sqlReset As String
    Dim i As Integer
    Dim obj As AccessObject
        
    ' Step 0: Show clear instruction to user
    MsgBox "Important: Before continuing, be informed that ALL of the following will close:" & vbCrLf & _
           "- Any forms that are bound to the LeaveRecords table (e.g. Form1)" & vbCrLf & _
           "- Any open queries involving LeaveRecords (e.g. qrySingleLeave, qryAggregateLeave)" & vbCrLf & _
           "- The LeaveRecords table itself" & vbCrLf & vbCrLf & _
           "This is required for the reset operation to complete successfully.", _
           vbExclamation, "Alert"
    
    ' Step 0: Close all open forms
    For i = Forms.Count - 1 To 0 Step -1
        DoCmd.Close acForm, Forms(i).Name, acSaveNo
    Next i

    ' Step 0.1: Close open datasheet queries/tables
    For Each obj In CurrentData.AllTables
        If obj.IsLoaded Then DoCmd.Close acTable, obj.Name, acSaveNo
    Next obj

    For Each obj In CurrentData.AllQueries
        If obj.IsLoaded Then DoCmd.Close acQuery, obj.Name, acSaveNo
    Next obj

    ' Step 1: Show confirmation message
    confirm = MsgBox("This action will:" & vbCrLf & _
                     "- Backup all leave records to Excel" & vbCrLf & _
                     "- DELETE all records from the LeaveRecords table" & vbCrLf & _
                     "- Reset the RecordID AutoNumber to start from 1" & vbCrLf & vbCrLf & _
                     "Do you want to proceed?", vbYesNo + vbCritical, "Year-End Reset")

    If confirm = vbNo Then Exit Sub

    ' Step 2: Set backup file path
    filePath = CurrentProject.Path & "\YearEndLeaveReset_" & Format(Now, "yyyymmdd_hhnnss") & ".xlsx"

    ' Step 3: Export LeaveRecords and queries to Excel
    DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, "LeaveRecords", filePath, True, "LeaveRecords"
    DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, "qrySingleLeave", filePath, True, "qrySingleLeave"
    DoCmd.TransferSpreadsheet acExport, acSpreadsheetTypeExcel12Xml, "qryAggregateLeave", filePath, True, "qryAggregateLeave"

    ' Step 4: Delete all records
    Set db = CurrentDb()
    sqlDelete = "DELETE FROM LeaveRecords;"
    db.Execute sqlDelete, dbFailOnError
    
    ' Step 5: Reset AutoNumber (without checking if table is empty)
    sqlReset = "ALTER TABLE LeaveRecords ALTER COLUMN RecordID COUNTER (1,1);"
    db.Execute sqlReset, dbFailOnError

    ' Step 6: Notify user
    MsgBox "Backup and reset complete." & vbCrLf & _
           "File saved to:" & vbCrLf & filePath, vbInformation, "Operation Successful"
End Sub

Private Sub btnClear1_Click()
    On Error Resume Next
    Me.txtIdentificationID = Null
    Me.txtEmployeeID = Null
    Me.cmbLeaveType = Null
    Me.cmbLeaveStatus = Null
    Me.txtFromDate = Null
    Me.txtUntilDate = Null
    Me.txtFromDate1 = Null
    Me.txtUntilDate1 = Null
    On Error GoTo 0
End Sub


