<#
Script: Create-SqlFile.ps1

Description:
Creates a new SQL file with a timestamp in the filename.
The script automatically adds a basic SQL comment template
containing the creation date and provided topic name.

The file is created in the current PowerShell working directory.
You can check the current directory by running:
Get-Location

To run this script from any location:
1. Save the script in a permanent directory, for example:
   C:\Scripts\Create-SqlFile.ps1

2. Add this directory to the Windows PATH environment variable:
   C:\Scripts

3. Restart PowerShell.

4. Run the script from any location:
   Create-SqlFile.ps1 -p1 "AddNewIndexes"

To create a shorter command, for example:
newSql "AddNewIndexes"

add this function to your PowerShell profile:

function newSql {
    param (
        [string]$name
    )

    & "C:\Scripts\Create-SqlFile.ps1" -p1 $name
}

To open your PowerShell profile:
notepad $PROFILE

If the profile file does not exist, create it first:
New-Item -ItemType File -Path $PROFILE -Force

After saving the profile, restart PowerShell or reload the profile:
. $PROFILE

Parameters:
-p1    Name of the ticket, task, or topic.

Example usage:
.\Create-SqlFile.ps1 -p1 "AddNewIndexes"

Example usage with alias:
newSql "AddNewIndexes"

Example output file:
AddNewIndexes__26_05_19_12_30.sql
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$p1
)

# Current date used in the file name
$data = Get-Date -Format "yy_MM_dd_HH_mm"

# Generated file name
$nazwaPliku = "${p1}__$data.sql"

# Content written into the file
$zawartosc = @"
-- File creation date: $(Get-Date)
-- Ticket / topic: $p1

"@

# Create file with content in the current PowerShell working directory
$zawartosc | Set-Content -Path $nazwaPliku -Encoding UTF8

Write-Output "Created file: $nazwaPliku"
