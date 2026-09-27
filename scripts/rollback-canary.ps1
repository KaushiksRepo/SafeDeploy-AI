Write-Host "Rolling back canary deployment..."

kubectl rollout undo deployment/safedeploy-canary

kubectl rollout status deployment/safedeploy-canary

Write-Host "CANARY ROLLBACK COMPLETE"