param(
    [int]$WorkersNumber,
    [string]$OrgName,
    [string]$AccessToken,
    [string]$Labels,
    [string]$DockerImage
)

New-Variable -Name 'CONTAINER_COMMON_NAME' -Value "GH-runner-$OrgName" -Option ReadOnly -Scope Script

function Invoke-Main {
    Start-Containers
}

function Start-Containers {
    for($i=0; $i -lt $WorkersNumber; $i++){
        $ContainerName = "$CONTAINER_COMMON_NAME-$i"
        $id = docker run `
            --detach `
            --env GITHUB_OBJECT="$OrgName" `
            --env ACCESS_TOKEN="$AccessToken" `
            --env LABELS="$($Labels.Replace(' ',''))" `
            --name "$ContainerName" `
            $DockerImage
        Write-Host "$ContainerName started (container id: $id)"
    }
}

Invoke-Main