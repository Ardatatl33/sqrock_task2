[void](Get-Random -SetSeed 42)
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

$rows = for ($i = 1; $i -le 300; $i++) {
    $studyHours = [math]::Round((Get-Random -Minimum 0 -Maximum 81) / 10, 1)
    $attendance = Get-Random -Minimum 40 -Maximum 101
    $previousScore = Get-Random -Minimum 30 -Maximum 101
    $assignmentScore = Get-Random -Minimum 20 -Maximum 101
    $noise = Get-Random -Minimum -8 -Maximum 9

    $finalMarks = [math]::Round(
        (0.20 * $attendance) +
        (0.30 * $previousScore) +
        (0.35 * $assignmentScore) +
        (1.5 * $studyHours) +
        $noise
    )
    $finalMarks = [math]::Max(0, [math]::Min(100, $finalMarks))

    $studyForCsv = if ($i % 41 -eq 0) { $null } else { $studyHours }
    $attendanceForCsv = if ($i % 31 -eq 0) { $null } else { $attendance }
    $previousForCsv = if ($i % 37 -eq 0) { $null } else { $previousScore }
    $assignmentForCsv = if ($i % 29 -eq 0) { $null } else { $assignmentScore }

    [pscustomobject]@{
        'Study Hours'       = $studyForCsv
        'Attendance'        = $attendanceForCsv
        'Previous Score'    = $previousForCsv
        'Assignments Score' = $assignmentForCsv
        'Final Marks'       = $finalMarks
    }
}

$rows | Export-Csv -Path '.\data\student_performance.csv' -NoTypeInformation -Encoding UTF8
Write-Host "300 sentetik kayıt oluşturuldu: data\student_performance.csv"
