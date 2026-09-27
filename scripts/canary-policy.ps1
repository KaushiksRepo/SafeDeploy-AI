param (
    [int]$ErrorRate = 0,
    [int]$MaxErrorRate = 5
)

Write-Host "Canary Error Rate: $ErrorRate%"
Write-Host "Maximum Allowed Error Rate: $MaxErrorRate%"

if ($ErrorRate -le $MaxErrorRate) {
    Write-Host "CANARY DECISION: PASS"
    exit 0
}

Write-Host "CANARY DECISION: FAIL"
exit 1