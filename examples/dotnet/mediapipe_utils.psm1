#requires -version 5.0

[CmdletBinding()]
param (
    [Parameter(Position=0)][string] $BuildType = $Env:BUILD_TYPE
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
# trap { throw $Error[0] }

<#
.Synopsis
    Log debug messages if active
#>
function _Mediapipe_DebugMsg([string] $msg) {
    if ($Env:MEDIAPIPE_DEBUG -eq "1") {
        Write-Verbose "DEBUG: $msg"
    }
}
Export-ModuleMember -Function _Mediapipe_DebugMsg

<#
.Synopsis
    Normalize path
#>
function _Mediapipe_NormalizePath([Parameter(Mandatory, Position=0)] $Path) {
    [string[]] $aParts = $Path -split {$_ -eq "/" -or $_ -eq "\"}
    $end = 0

    foreach ($sPart in $aParts) {
        if (($sPart -eq '.') -or ([string]::IsNullOrEmpty($sPart))) {
            continue
        }

        if ($sPart -eq '..') {
            $end = [Math]::Max(0, $end - 1)
            continue
        }

        $aParts[$end] = $sPart
        $end += 1
    }

    if ($end -eq 0) {
        ""
        return
    }

    $sPath = $aParts[0]
    for ($i = 1; $i -lt $end; $i += 1) {
        $sPath = Join-Path $sPath $aParts[$i]
    }

    $sPath
}
Export-ModuleMember -Function _Mediapipe_NormalizePath

<#
.Synopsis
    Find files
#>
function _Mediapipe_FindFiles(
    [Parameter(Mandatory, Position=0)] $Path,
    [Parameter(Position=1)] [string] $Directory = $PSScriptRoot,
    [Parameter(Position=2)] [hashtable] $Params = @{},
    [Parameter(Position=3)] [switch] $ReturnPath
) {
    if ($Path -is [string]) {
        $Path = $Path -split {$_ -eq "/" -or $_ -eq "\"}
    }

    $iDirPrefixLen = $Directory.Length + 1
    $iLastPart = $Path.Length - 1
    $iCursor = 0
    $iNextFound = 0
    [boolean] $bFound = $false
    [string] $sPath = ""
    [string[]] $aMatches = [string[]]::new(0)

    for ($i = 0; $i -le $iLastPart; $i += 1) {
        $sPart = $Path[$i]

        $Parameters = @{}

        $Parameters.GetEnumerator() | ForEach-Object {
            if ($_.Key -ne "Recurse") {
                $Params[$_.Key] = $_.Value
            }
        }

        if (($i -ne $iLastPart) -and ($Parameters.ContainsKey("File"))) {
            $Parameters.Remove("File")
        }

        $Parameters["Path"] = $Directory
        $Parameters["Filter"] = $sPart
        $Parameters["ErrorAction"] = "SilentlyContinue"

        $bFound = $false
        if (
            (
                (!$Parameters.ContainsKey("File")) -or
                ($Parameters.ContainsKey("Directory")) -or
                $i -ne $iLastPart
            ) -and
            !($sPart.Contains("?")) -and
            !($sPart.Contains("*"))
        ) {
            $sPath = Join-Path $Directory $sPart
            _Mediapipe_DebugMsg "Looking for $sPath"
            $bFound = Test-Path -Path $sPath
            if (!$bFound) {
                break
            }
            $Directory = $sPath
            continue
        }

        _Mediapipe_DebugMsg "Listing $(Join-Path $Directory $sPart)"

        $aFileList = Get-ChildItem @Parameters
        if ($null -eq $aFileList) {
            break
        }

        if (-not ($aFileList -is [array])) {
            $aFileList = ,$aFileList
        }

        if ($i -eq $iLastPart) {
            $aMatches = [string[]]::new($aFileList.Length)
            for ($j = 0; $j -lt $aFileList.Length; $j += 1) {
                $sPath = Join-Path $Directory $aFileList[$j].Name
                if (!$ReturnPath) {
                    $sPath = $sPath.Substring($iDirPrefixLen)
                }

                _Mediapipe_DebugMsg "Found $sPath"
                $aMatches[$j] = $sPath
            }
            break
        }

        $aNextParts = $Path[($i + 1)..$iLastPart]

        for ($j = 0; $j -lt $aFileList.Length; $j += 1) {
            $sPath = Join-Path $Directory $aFileList[$j].Name
            $aNextFileList = _Mediapipe_FindFiles -Path $aNextParts -Directory $sPath -Params $Params -ReturnPath:$ReturnPath
            $iNextFound = $aNextFileList.Length

            if ($iNextFound -eq 0) {
                continue
            }

            $aMatches += [string[]]::new($iNextFound)
            for ($k = 0; $k -lt $iNextFound; $k += 1) {
                $sPath = $aNextFileList[$k]
                if (!$ReturnPath) {
                    $sPath = Join-Path $aFileList[$j].Name $sPath
                    $sPath = Join-Path $Directory $sPath
                    $sPath = $sPath.Substring($iDirPrefixLen)
                }

                _Mediapipe_DebugMsg "Found $sPath"
                $aMatches[$iCursor + $k] = $sPath
            }
            $iCursor += $iNextFound
        }

        break
    }

    if ($bFound) {
        if (!$ReturnPath) {
            $sPath = $sPath.Substring($iDirPrefixLen)
        }

        _Mediapipe_DebugMsg "Found $sPath"
        $aMatches = ,$sPath
    }

    ,$aMatches
}
Export-ModuleMember -Function _Mediapipe_FindFiles

<#
.Synopsis
    Find a file and returns its full path
#>
function _Mediapipe_FindFile(
    [Parameter(Mandatory, Position=0)] [string] $Path,
    [Parameter(Position=1)] [string] $Filter = "",
    [Parameter(Position=2)] [string] $Directory = $PSScriptRoot,
    [Parameter(Position=3)] [string[]] $SearchPaths = (,"."),
    [Parameter(Position=4)] [hashtable] $Params = @{}
) {
    $sDirectory = $Directory

    while ($true) {
        foreach ($sSearchPath in $SearchPaths) {
            if ([string]::IsNullOrEmpty($sSearchPath)) {
                continue
            }
            $sPath = if ([string]::IsNullOrEmpty($Filter)) { "" } else { $Filter }
            $sPath = if ([string]::IsNullOrEmpty($sPath)) { $sSearchPath } else { Join-Path $sPath $sSearchPath }
            $sPath = if ([string]::IsNullOrEmpty($sPath)) { $Path } else { Join-Path $sPath $Path }
            $sPath = _Mediapipe_NormalizePath $sPath

            $aFileList = _Mediapipe_FindFiles -Path $sPath -Directory $sDirectory -Params $Params -ReturnPath
            if ($aFileList.Length -ne 0) {
                $aFileList[0]
                return
            }
        }

        $sDirectory = Split-Path -Path $sDirectory
        if ($sDirectory.Length -eq 0) {
            break
        }
    }

    ""
}
Export-ModuleMember -Function _Mediapipe_FindFile

<#
.Synopsis
    Find a mediapipe dll
#>
function _Mediapipe_FindDLL(
    [Parameter(Mandatory, Position=0)] $Path,
    [Parameter(Position=1)] [string] $Filter = "",
    [Parameter(Position=2)] [string] $Directory = $PSScriptRoot,
    [Parameter(Position=3)] [string] $BuildType = $Env:BUILD_TYPE
) {
    $BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }
    $PostSuffix = if ($BuildType -eq "Debug") { "d" } else { "" }

    $aSearchPaths = @(
        "."
        "autoit-mediapipe-com"
        "autoit-mediapipe-com\build_x64\bin\$BuildType"
        "autoit-opencv-com"
        "autoit-opencv-com\build_x64\bin\$BuildType"
        "opencv\build\x64\vc*\bin"
        "opencv-4.7.0-*\build\x64\vc*\bin"
        "opencv-4.7.0-*\opencv\build\x64\vc*\bin"
    )

    _Mediapipe_FindFile -Path "$Path$PostSuffix.dll" -Filter $Filter -Directory $Directory -SearchPaths $aSearchPaths
}
Export-ModuleMember -Function _Mediapipe_FindDLL

<#
.Synopsis
    Find resource directory
#>
function _Mediapipe_FindResourceDir(
    [Parameter(Position=0)] [string] $Directory = $PSScriptRoot,
    [Parameter(Position=1)] [string] $BuildType = $Env:BUILD_TYPE
) {
    $BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }
    $CompileMode = if ($BuildType -eq "Debug") { "dbg" } else { "opt" }
    $BazelBin = "build_x64\mediapipe-src\bazel-out\x64_windows-$CompileMode\bin"

    $aSearchPaths = @(
        "."
        "autoit-mediapipe-com"
        $BazelBin
        "autoit-mediapipe-com\$BazelBin"
    )

    $sFile = "mediapipe\modules\face_detection\face_detection_short_range_cpu.binarypb"

    $sGraphFile = _Mediapipe_FindFile $sFile -Directory $Directory -SearchPaths $aSearchPaths

    if ([string]::IsNullOrEmpty($sGraphFile)) {
        ""
        return
    }

    $sGraphFile.Substring(0, $sGraphFile.Length - $sFile.Length - 1)
}
Export-ModuleMember -Function _Mediapipe_FindResourceDir

Add-Type -Path ( _Mediapipe_FindDLL -Path "dotnet\interop.mediapipe-*" -BuildType $BuildType )
