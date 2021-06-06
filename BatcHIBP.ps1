<#
.SYNOPSIS
    Look for compromised passwords via "Have I Been Pwned?"
.DESCRIPTION
    "Have I Been Pwned?" is a website that allows Internet users to check whether their personal data has been compromised by data breaches. This script allows you to search for multiple passwords using the "Have I Been Pwned?" API.
.PARAMETER PasswordsFile
    Full path to the file containing the password list, one per line.
.NOTES
    Author:  Tiziano Marra
    Date:    2021-02-20
    Version: 1.0
#>

[CmdletBinding()]
param (
    [Parameter(
            Mandatory=$true,
            HelpMessage='Full path to the file containing the password list, one per line'
        )
    ][String]$PasswordsFile
)

Function GetHash {
    [CmdletBinding()]
    param ( 
        [Parameter(
                Mandatory=$true
            )
        ][string]$Password,
        [Parameter(
                Mandatory=$true
            )
        ][System.Security.Cryptography.SHA1]$SHA1CryptoServiceProvider
    )

    $Encoding = [System.Text.Encoding]::UTF8
    $Bytes = $Encoding.GetBytes($Password)
    $BytesHash = $SHA1CryptoServiceProvider.ComputeHash($Bytes)

    return [System.BitConverter]::ToString($BytesHash).Replace('-', '')
}

Function ProgressBarUpdate {
    [CmdletBinding()]
    param ( 
        [Parameter(
                Mandatory=$true
            )
        ][uint64]$Current,
        [Parameter(
                Mandatory=$true
            )
        ][uint64]$Count
    )

    $Progress = ($Current / $Count) * 100
    $ProgressFloor= [Math]::Floor($Progress)

    $script:ProgressPreference = 'Continue'
    Write-Progress -Activity 'Search in Progress' -Status "Progress -> $i of $PasswordCount - $Progress %" -PercentComplete $ProgressFloor
    $script:ProgressPreference = 'SilentlyContinue'
}

Function SendRequest {
    param ( 
        [Parameter(
                Mandatory=$true
            )
        ][string]$Hash
    )

    $Headers = @{
        'Add-Padding' = 'true'
    }

    $TruncatedHash = $Hash.Substring(0, 5)

    try {
        $Request = Invoke-WebRequest -Uri https://api.pwnedpasswords.com/range/$TruncatedHash -Method Get -Headers $Headers

        if ($Request.StatusCode -eq 200) {
            $SuffixList = $Request.Content.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)

            foreach ($Suffix in $SuffixList) {
                $Split = $Suffix.Split(':')
                $SuffixHash = $Split[0]
                $SuffixCount = $Split[1]

                if ($SuffixCount -eq 0) {
                    continue
                }

                if ($Hash -eq "$TruncatedHash$SuffixHash") {
                    return $Request.StatusCode, [uint64]$SuffixCount
                }
            }

            return $Request.StatusCode, 0
        }
        else {
            return $Request.StatusCode
        }
    }
    catch {
        return -1
    }
}

$PasswordCount = [Linq.Enumerable]::Count([System.IO.File]::ReadLines($PasswordsFile))
$Len = ([string]$PasswordCount).Length
$Sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider

$i = 0

$Id = "ID".PadLeft($Len, ' ')
$Count = "COUNT".PadLeft(10, ' ')
$Dash = "".PadLeft($Len + 24, '-')

Write-Host `n`n`n`n`n
Write-Host $Dash
Write-Host "$Id | $Count | Password"
Write-Host $Dash

foreach ($Password in [System.IO.File]::ReadLines($PasswordsFile)) {
    ProgressBarUpdate -Current $i -Count $PasswordCount
    $i++

    $Hash = GetHash -Password $Password -SHA1CryptoServiceProvider $Sha1
    $StatusCode, $SuffixCount = SendRequest -Hash $Hash

    if ($StatusCode -eq 200 -And $SuffixCount -gt 0) {
        $Id = ([string]$i).PadLeft($Len, ' ')
        $Count = ([string]$SuffixCount).PadLeft(10, ' ')

        Write-Host "$Id | $Count | $Password"
    }
    elseif ($StatusCode -eq -1) {
        $Id = ([string]$i).PadLeft($Len, ' ')

        Write-Host -ForegroundColor Red "$Id | CONN ERROR | $Password"
    }
    elseif ($StatusCode -ne 200) {
        $Id = ([string]$i).PadLeft($Len, ' ')

        Write-Host -ForegroundColor Yellow "$Id | ERROR: $StatusCode | $Password"
    }
}

Write-Host $Dash
