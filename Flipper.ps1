
# URL du webhook Discord
$WebhookURL = "https://discord.com/api/webhooks/1324719273389723679/RCoV9w6F3td5QuvQkHpXQ5eC_ocPf-VZZ-6pgTpI7mrMdeZ2PrybMyO8onYP9GVILnm5"
$Message = '{"content": "Test message from PowerShell!"}'
Invoke-RestMethod -Uri $WebhookURL -Method Post -Body $Message -ContentType "application/json"
