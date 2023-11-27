# This function will recursively search for all directories with the specified name and remove them
function Remove-RecursiveAll {
    param(
        [Parameter(Mandatory=$true)]
        [string]$directoryName
    )

    Get-ChildItem -Path . -Recurse -Directory -Filter $directoryName | ForEach-Object { Remove-Item -Recurse -Force $_.FullName }
}

# This function will remove a single specified directory recursively from the current path
function Remove-Recursive {
    param(
        [Parameter(Mandatory=$true)]
        [string]$directoryPath
    )

    if (Test-Path $directoryPath) {
        Remove-Item -Recurse -Force $directoryPath
    } else {
        Write-Host "$directoryPath does not exist."
    }
}

function Kill-ProcessByName {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )

    Get-Process -Name $ProcessName | Stop-Process -Force
}

function Volta-PinNodeVersionRecursive {
    param(
        [Parameter(Mandatory=$true)]
        [string]$nodeVersionArg
    )

    if (-not $nodeVersionArg) {
        Write-Error "Please provide a node version."
        return
    }

    $rootPath = "."

    Get-ChildItem -Path $rootPath -Recurse -File -Filter "package.json" | Where-Object {
        $_.FullName -notmatch "\\node_modules\\"
    } | ForEach-Object {
        $dir = $_.DirectoryName
        Push-Location -Path $dir
        Write-Host "Running volta in $dir"
        volta pin node@$nodeVersionArg
        Pop-Location
    }
}

function Ssh-CopyId {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IPAddressOrFQDN
    )
    
    type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh $IPAddressOrFQDN "cat >> .ssh/authorized_keys"
}

# Alias definitions
Set-Alias -Name rmrfall -Value Remove-RecursiveAll
Set-Alias -Name rmrf -Value Remove-Recursive
Set-Alias -Name pkill -Value Kill-ProcessByName
Set-Alias -Name vprn -Value Volta-PinNodeVersionRecursive
Set-Alias -Name ssh-copy-id -Value Ssh-CopyId


function grt { cd (git rev-parse --show-toplevel) }

function gs { git status }
function gp { git push }
function gpf { git push --force }
function gpft { git push --follow-tags }
function gpl { git pull --rebase }
function gcl { git clone }
function gst { git stash }
function grm { git rm }
function gmv { git mv }

function main { git checkout main }

function gco { git checkout $args }
function gcob { git checkout -b $args }

function gb { git branch $args }
function gbd { git branch -d $args }

function grb { git rebase $args }
function grbom { git rebase origin/master }
function grbc { git rebase --continue }

function gl { git log $args }
function glo { git log --oneline --graph }

function grh { git reset HEAD }
function grh1 { git reset HEAD~1 }

function ga { git add $args }
function gA { git add -A }

function gc { git commit $args }
function gcm { git commit -m $args }
function gca { git commit -a $args }
function gcam { git add -A; git commit -m $args }

function gfrb { git fetch origin; git rebase origin/master }

function gxn { git clean -dn }
function gx { git clean -df }

function gsha { git rev-parse HEAD | clip }

function ghci { gh run list -L 1 }
