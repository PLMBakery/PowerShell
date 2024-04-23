while ($true) {
    $counter = 10

    while ($counter -gt 0) {
        Write-Host "Countdown: $counter seconds"
        $counter--
        Start-Sleep -Seconds 1
    }

    Write-Host "Countdown finished!"

    $WAIT = 5
    while ($WAIT -gt 0) {
        Write-Host "Waiting: $WAIT seconds"
        $WAIT--
        Start-Sleep -Seconds 1
    }
}
