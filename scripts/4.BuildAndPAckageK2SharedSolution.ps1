[CmdletBinding()]
Param(
    [parameter(Mandatory=$true)]               
    [ValidateNotNullOrEmpty()]   
	[string]$K2ServerWithAllEnvSettings,

	[int]$K2ServerPortWithAllEnvSettings=5555,

    [parameter(Mandatory=$true)]               
    [ValidateNotNullOrEmpty()]    
    [String] $SourceCodePathToDiscoverK2ProjFiles,
   
    [parameter(Mandatory=$true)]               
    [ValidateNotNullOrEmpty()]    
    [String] $DeploymentPath,
)


$CURRENTDIR=pwd
trap {write-host "error"+ $error[0].ToString() + $error[0].InvocationInfo.PositionMessage  -Foregroundcolor Red; cd "$CURRENTDIR"; read-host 'There has been an error'; break}

Write-Verbose "*** 4.BuildAndPackage - Starts"
Get-ChildItem -Path $SourceCodePathToDiscoverK2ProjFiles -Recurse -Include *.k2proj | ForEach-Object {
	$K2ProjName=$_.BaseName
	
	Write-Debug "* About to create Output directory $DeploymentPath\$K2ProjName"
	new-item $DeploymentPath\$K2ProjName -force -type Directory | out-null

	Write-Debug "* About to build $_ to $DeploymentPath\$K2ProjName"
	Write-Debug "New-K2Package $Global_FrameworkPath $K2ServerWithAllEnvSettings $K2ServerPortWithAllEnvSettings $_ $DeploymentPath\$K2ProjName"

	New-K2Package $Global_FrameworkPath $K2ServerWithAllEnvSettings $K2ServerPortWithAllEnvSettings $_ $DeploymentPath\$K2ProjName

}
Write-Verbose "*** 4.BuildAndPackage - Ends"


$message= "======Finished Building K2 packages for SmO and WF======"
If($DoNotStop){Write-Verbose $message} else {Read-Host $message}
