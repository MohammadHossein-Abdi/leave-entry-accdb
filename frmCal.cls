Option Compare Database
Option Explicit

Dim intFirst As Integer, intLast As Integer, intLastDay As Integer
Dim intMonth As Integer, intYear As Integer, intDay As Integer
Dim varDate As Variant
Dim varDate1 As Variant
Dim varDate2 As Variant

Private Sub cmbMonth_AfterUpdate()

    SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    
End Sub



Private Sub cmbYear_AfterUpdate()

    SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    
End Sub




Public Sub cmdCancel_Click()
    DoCmd.Close acForm, Me.Name
    STRDATE = ""
End Sub

Private Sub CmdGoToday_Click()
    Form_Load
End Sub

Private Sub cmdNext_Click()

If Me!cmbMonth = 12 Then
    If Me!cmbYear = 99 Then
        Me!cmbMonth.Value = 1
        Me!cmbYear = 81
    Else
        Me!cmbYear.Value = Me!cmbYear.Value + 1
        Me!cmbMonth.Value = 1
    End If
Else
    Me!cmbMonth.Value = Me!cmbMonth.Value + 1
End If

    SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    
End Sub

Private Sub cmdPrevious_Click()

If Me!cmbMonth = 1 Then
    If Me!cmbYear = 81 Then
        Me!cmbMonth = 12
        Me!cmbYear = 99
    Else
        Me!cmbYear.Value = Me!cmbYear.Value - 1
        Me!cmbMonth.Value = 12
    End If
Else
    Me!cmbMonth.Value = Me!cmbMonth.Value - 1
End If

    SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    
End Sub

Public Sub cmdSAVE_Click()
    Me.Visible = False
End Sub


Private Sub cmdClose_Click()
DoCmd.Close acForm, Form.Name
End Sub

Private Sub cmdMonth_Click()
If Me.optCalendar.Visible = False Then

Me.optCalendar.Visible = True
Me.cmdToday.Visible = True
Me.cmdClose.Visible = True

Me.optMah.Visible = False
Else
Me.optCalendar.Visible = False
Me.optMah.Visible = True
'Me.cmdToday.Visible = False
'Me.cmdClose.Visible = False

End If
End Sub

Private Sub cmdPeriod_Click()
On Error GoTo err
    varDate1 = Left(ctlCalendar, 6) & "01"
    varDate2 = Left(ctlCalendar, 6) & MahDays(Me.cmbYear, Mah(Me.ctlCalendar))
    DoCmd.Close acForm, Form.Name
    Screen.ActiveForm.txtStart = varDate1
    Screen.ActiveForm.txtEnd = varDate2
Exit Sub
err:
MsgBox "ÎØÇíí ÑÎ ÏÇÏå ÇÓÊ ¡ ÔãÇ ÈÇíÏ ÏÑ ÝÑã ÎæÏ ÊÇÑíÎ ÔÑæÚ æ ÇíÇä ÏÇÔÊå ÈÇÔíÏ"

End Sub

Private Sub cmdToday_Click()
DoCmd.Close acForm, Form.Name
STRDATE = Shamsi()
End Sub

Private Sub Command341_Click()
On Error Resume Next
    
    If Me.optMah.Value = 12 Then
        Me.optMah.Value = 1
        SetDays
        varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
        Me.ctlCalendar = varDate
           Me.cmdMonth.Caption = MahName(Format(Me.optMah, "00"))
    Else
    
        Me.optMah.Value = optMah.Value + 1
        SetDays
        varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
        Me.ctlCalendar = varDate
           Me.cmdMonth.Caption = MahName(Format(Me.optMah, "00"))
    End If
End Sub

Private Sub Command346_Click()
On Error Resume Next

Me.cmbYear.Value = Me.cmbYear + 1
   SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
End Sub

Private Sub Command348_Click()
On Error Resume Next

Me.cmbYear.Value = Me.cmbYear - 1
   SetDays
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
End Sub

Private Sub Command73_Click()
'strDate = To_Hejri(Now, 2)
'DoCmd.Close , "frmCalendar"
STRDATE = To_Hejri(Now, 2)
DoCmd.Close
End Sub

Private Sub Command352_Click()
On Error Resume Next

    If Me.optMah.Value = 1 Then
        Me.optMah.Value = 12
        SetDays
        varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
        Me.ctlCalendar = varDate
        Me.cmdMonth.Caption = MahName(Format(Me.optMah, "00"))
    Else
    
        Me.optMah.Value = optMah.Value - 1
        SetDays
        varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
        Me.ctlCalendar = varDate
           Me.cmdMonth.Caption = MahName(Format(Me.optMah, "00"))
    End If
End Sub

Private Sub Command360_Click()
Me.optMah.Visible = True
Me.optCalendar.Visible = False
End Sub

Private Sub Command430_Click()
STRDATE = Shamsi()
DoCmd.Close
End Sub

Private Sub Command440_Click()
DoCmd.Close acForm, Form.Name
'STRDATE = ""
End Sub

Private Sub Command457_Click()
CreateObject("Shell.Application").Open "http://aaro.ir/"
End Sub

Private Sub Command482_Click()
'On Error GoTo err
    varDate1 = Left(ctlCalendar, 6) & "01"
    varDate2 = Left(ctlCalendar, 6) & MahDays(Me.cmbYear, Mah(Me.ctlCalendar))
    DoCmd.Close acForm, Form.Name
    Screen.ActiveForm.txtStart = Null
    Screen.ActiveForm.txtStart = varDate1
    Screen.ActiveForm.txtEnd = varDate2
'Exit Sub
'err:
'MsgBox "ÎØÇíí ÑÎ ÏÇÏå ÇÓÊ ¡ ÔãÇ ÈÇíÏ ÏÑ ÝÑã ÎæÏ ÊÇÑíÎ ÔÑæÚ æ ÇíÇä ÏÇÔÊå ÈÇÔíÏ"

End Sub

Private Sub Form_Current()
    If Me.tgl36.Visible = True Then
    Me.cmdToday.Top = 4300
      Me.cmdClose.Top = 4300
  
    DoCmd.MoveSize , , , 5350
    Else
        Me.cmdToday.Top = 3800
              Me.cmdClose.Top = 3800
  
        DoCmd.MoveSize , , , 4850
    End If
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
Select Case KeyCode
    Case vbKeyEscape
        DoCmd.Close acForm, Me.Name
    End Select
End Sub





Private Sub optCalendar_AfterUpdate()
    varDate = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    'Form.Caption = "ÇãÑæÒ " & Format(Me.ctlCalendar, "00/00/00")
End Sub

Private Sub Form_Load()

    
    Me.optMah.Value = Mah(Shamsi)
    Me.cmbYear = sal(Shamsi())
    SetDays
    Me.ctlCalendar = Shamsi()
    Me.cmdToday.Caption = Slash(Shamsi())
    Me.optMah.Value = Mah(Shamsi())
    Me.cmdMonth.Caption = MahName(Mah(Shamsi()))
    Me.cmbYear.BackColor = Me.cmdMonth.BackColor
    Me.optMah.Visible = False
    Me.ShortcutMenu = False
    Form.Caption = Matni(Shamsi(), 1)
    Me.optCalendar.SetFocus

    
End Sub
Private Sub SetDays()
Dim inti As Integer, intj As Integer, strNum As String, ctl As Control

'    Me.cmbMonth.SetFocus
    

    For inti = 1 To 42
        strNum = Format(inti, "00")
        Set ctl = Me("tgl" & strNum)
        ctl.Caption = ""
        ctl.OptionValue = 0
        ctl.ForeColor = 0
        ctl.Visible = False
    Next inti

    intMonth = Me!optMah.Value
    intYear = Me!cmbYear
    intFirst = Firstday(Me!cmbYear, Me.optMah.Value) + 1 'Çæáíä ÑæÄ ãÇå
    intLastDay = MahDays(Me!cmbYear, Me!optMah.Value) 'ÊÚÏÇÏ ÑæÒåÇí ãÇå
    intLast = intFirst + intLastDay - 1 ' ÂÎÑíä ÑæÒ ãÇå


    intj = 1
    For inti = intFirst To intLast
        strNum = Format(inti, "00")

        Set ctl = Me("tgl" & strNum)
        ctl.Caption = intj
        ctl.OptionValue = intj
        ctl.ForeColor = 0
        
        If (intFirst + intj - 1) Mod 7 = 0 Then
            ctl.ForeColor = vbWhite
            ctl.BackColor = 655485
        End If
        ctl.Visible = True
        intj = intj + 1
    Next inti
    
    Set ctl = Nothing
    

    If intLast <> 42 Then
        intj = 1
        For inti = intLast + 1 To 42
            strNum = Format(inti, "00")

            Me("tgl" & strNum).Caption = intj
            intj = intj + 1
        Next inti
    End If
    

    If intFirst <> 1 Then
        If Me.optMah = 1 Then
            intMonth = 12
            intYear = Me!cmbYear - 1
        Else
            intMonth = Me.optMah - 1
            intYear = Me!cmbYear
        End If
        intj = MahDays(intYear, intMonth)
        For inti = intFirst - 1 To 1 Step -1
            strNum = Format(inti, "00")

            Me("tgl" & strNum).Caption = intj
            intj = intj - 1
        Next inti
    End If
On Error Resume Next
    Me.optCalendar.SetFocus
    If Me.tgl36.Visible = True Then
    Me.cmdToday.Top = 4300
    DoCmd.MoveSize , , , 5350
        Me.cmdClose.Top = 4300
 
    Else
        Me.cmdToday.Top = 3800
                Me.cmdClose.Top = 3800

        DoCmd.MoveSize , , , 4850
    End If
    
'    Form.Caption = Me.cmbYear & "/" & Format(Me.cmbMonth, "00") & "/" & Format(optCalendar.Value, "00")

End Sub

Private Sub optCalendar_Click()
STRDATE = Me.cmbYear & Format(Me.optMah.Value, "00") & Format(optCalendar.Value, "00")
DoCmd.Close
End Sub

Private Sub optMah_AfterUpdate()

Me.optCalendar.Visible = True
    SetDays
    varDate = Me.cmbYear & Format(Me.optMah, "00") & Format(optCalendar.Value, "00")
    Me.ctlCalendar = varDate
    Me.cmdMonth.Caption = MahName(Format(Me.optMah, "00"))
Me.optMah.Visible = False
Me.cmdToday.Visible = True
Me.cmdClose.Visible = True

End Sub
    



