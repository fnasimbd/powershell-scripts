$assemblyFileName = "AssemblyInfo.cs"

function IncreaseAssemblyVersion
{
    $assemblyFile = Get-Content $assemblyFileName
    $assemblyVerLine = $assemblyFile -match "^\[assembly:\s*AssemblyVersion\("
    $version = [string] $assemblyVerLine -replace '[^\d+\.\*]', ''
    
    $verParts = $version.split('.')
    $major = $verParts[0]    
    $minor = $verParts[1]
    $newVersion = $version
    
    if($args[0] -eq "maj")
    {
        $newMajor = [Int]::Parse($major) + 1
        $newVersion = "$newMajor.$minor.*"
    }
    elseIf($args[0] -eq "min")
    {
        $newMinor = [Int]::Parse($minor) + 1
        $newVersion = "$major.$newMinor.*"
    }
    else
    {
        exit
    }
    
    $newAssemblyVerLine = $assemblyVerLine -replace "\(.*\)", "(`"$newVersion`")"

    $newAssemblyFile = $assemblyFile -replace "^\[assembly:\s*AssemblyVersion\(`".*`"\)\]", $newAssemblyVerLine
    
    Rename-Item $assemblyFileName "$assemblyFileName.bak"
    
    try
    {
        New-Item -name $assemblyFileName -itemtype "file" -force | Out-Null
        $newAssemblyFile | Out-File -filepath $assemblyFileName
    }
    finally
    {
        Remove-Item "$assemblyFileName.bak"
    }    
}

$choice = read-host "(maj)or/(min)or?"

IncreaseAssemblyVersion $choice

read-host
