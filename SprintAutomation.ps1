# ==============================
# Script: Sprint Automation.ps1
# Autor: Seu Nome
# Data: 2025-05-03
# Descrição: Automação para criação de sprints no Azure DevOps.
# Este script permite configurar e criar múltiplas sprints automaticamente,
# além de armazenar a última sprint e sua data para futuras execuções.
# ==============================

# Definir caminhos dos arquivos externos
$configFile = "config.json"  # Contém configurações gerais
$sprintFile = "sprintData.json"  # Armazena a última sprint criada e sua data
$patFile = "pat.txt"  # Contém o token PAT para autenticação no Azure DevOps
# Verificar se os arquivos existem e inicializar variáveis

# Verificar se os arquivos necessários existem
if (-not (Test-Path $configFile)) {
    Write-Host "Erro: Arquivo $configFile não encontrado!" -ForegroundColor Red
    exit
}
if (-not (Test-Path $sprintFile)) {
    Write-Host "Erro: Arquivo $sprintFile não encontrado! Criando padrão..."
    $defaultSprintData = @{ lastSprint = 20; lastSprintDate = "2025-05-12" } | ConvertTo-Json
    Set-Content -Path $sprintFile -Value $defaultSprintData
}
if (-not (Test-Path $patFile)) {
    Write-Host "Erro: Arquivo $patFile não encontrado!" -ForegroundColor Red
    exit
}

# Carregar configurações do JSON
$config = Get-Content $configFile | ConvertFrom-Json
$org = $config.org
$prj = $config.prj
$totalSprints = $config.totalSprints
$sprintDuration = $config.sprintDuration

# Ler o token do PAT e definir variável de ambiente
$AZURE_DEVOPS_EXT_PAT = Get-Content $patFile
$env:AZURE_DEVOPS_EXT_PAT = $AZURE_DEVOPS_EXT_PAT

# Ler número da última sprint e última data do arquivo externo
$sprintData = Get-Content $sprintFile | ConvertFrom-Json
$lastSprint = [int]$sprintData.lastSprint
$startDate = [datetime]::ParseExact($sprintData.lastSprintDate, "yyyy-MM-dd", $null)
$endDate = $startDate.AddDays($sprintDuration)  # Sempre termina na sexta-feira

# Configurar Azure DevOps CLI
az devops configure --defaults organization=$org
az devops configure --defaults project=$prj

# Criar múltiplas sprints dinamicamente
for ($i = $lastSprint; $i -lt ($lastSprint + $totalSprints); $i++) {
    $name = "Sprint $i"
    $path = "\$prj\Iteration\2025"

    Write-Host "`n🔹 Criando $name de $startDate a $endDate..."

    az boards iteration project create --name $name `
        --start-date $startDate.ToString("yyyy-MM-dd") `
        --finish-date $endDate.ToString("yyyy-MM-dd") `
        --path $path `
        --output table
    
    # Atualizar datas para a próxima sprint (segunda-feira seguinte)
    $startDate = $startDate.AddDays(7)  
    $endDate = $startDate.AddDays($sprintDuration)  
}

# Atualizar arquivo externo com nova última sprint e data
$lastSprint = $lastSprint + $totalSprints
$sprintDataUpdate = @{ lastSprint = $lastSprint; lastSprintDate = $startDate.ToString("yyyy-MM-dd") } | ConvertTo-Json
Set-Content -Path $sprintFile -Value $sprintDataUpdate

Write-Host "`n✅ Processo concluído! Última sprint agora é Sprint $lastSprint iniciando em $startDate."