param(
    [string]$OrgName
)
New-Variable -Name 'CONTAINER_COMMON_NAME' -Value "GH-runner-$OrgName" -Option ReadOnly -Scope Script

function Invoke-Main {
    Stop-Containers
}

function Stop-Containers {
    $ContainersToRemove = $(Get-ContainerName)
    if ($ContainersToRemove.count -le 0){
        Write-Host "No runners to remove"
        return
    }
    foreach ($cName in $ContainersToRemove){
        try {
            docker stop $cName
            $NameToDisplay = docker rm -f -v $cName
            Write-Host "$NameToDisplay removed"
        }
        catch {
            continue
        }
    }
}

function Get-ContainerName {
    return (
        docker ps -a --format json `
            | ConvertFrom-Json `
            | ForEach-Object {
                $_.Names
            } `
            | Where-Object {
                $_ -like "$CONTAINER_COMMON_NAME*"
            }
    )
}

Invoke-Main