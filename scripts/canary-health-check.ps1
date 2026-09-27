$canaryUrl = "http://safedeploy-canary-service/health"

try {
    $response = Invoke-WebRequest -UseBasicParsing $canaryUrl -TimeoutSec 5

    if ($response.StatusCode -eq 200 -and $response.Content -match '"status"\s*:\s*"healthy"') {
        Write-Host "CANARY HEALTH CHECK: PASS"
        exit 0
    }

    Write-Host "CANARY HEALTH CHECK: FAIL"
    exit 1
}
catch {
    Write-Host "CANARY HEALTH CHECK: FAIL"
    Write-Host $_.Exception.Message
    exit 1
}