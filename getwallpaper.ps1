# Simpler Windows version

$WallpaperUrl = "https://example.com/wallpaper.jpg"
$SavePath = "$env:APPDATA\wallpaper-rotator\wallpaper.jpg"

# Ensure the folder exists
$SaveFolder = Split-Path -Parent $SavePath
if (!(Test-Path $SaveFolder)) {
    New-Item -ItemType Directory -Path $SaveFolder -Force | Out-Null
}

# Download the wallpaper
Write-Output "Fetching wallpaper from $WallpaperUrl..."
Invoke-WebRequest -Uri $WallpaperUrl -OutFile $SavePath

# Apply the wallpaper
Write-Output "Applying wallpaper..."
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@ -Language CSharp
[Wallpaper]::SystemParametersInfo(20, 0, $SavePath, 3)

Write-Output "Wallpaper updated successfully!"
