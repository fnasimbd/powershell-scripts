#
# Purpose: To package a Visual Studio project as a NuGet package and to update 
# the projects dependent upon it.
#
# Requirements:
# (1) MSBuild
# (2) NuGet
# (2) SlikSvn
# (3) PowerShell
#
# Assumptions:
# (1) All of the dependent projects have the package installed.
# 

#####################################
##########    CONSTANTS    ##########
#####################################

#requirements
$requirements = @( "msbuild", "nuget", "svn" )

# package repo constants
$user = "user_name_of_nuget_repo_host"
$pass = "password_of_nuget_repo_host"

# package constants
$package = "PackageToPublish.csproj"
$packageRepo = "nuget_repo_path"

# dependent constants
$dependents = @(
	@{name='DependentApp1.csproj';path='dependent_app1_project_path'},
	@{name='DependentApp2.csproj';path='dependent_app2_project_path'}
)

#####################################
##########    FUNCTIONS    ##########
#####################################

function CheckApplication
{
    $cmd = $args[0] + " ?"
	$msg = Invoke-Expression $cmd
	
	if([string]::IsNullOrEmpty($msg))
	{
		write-host $args[0] "is either not installed or not added to PATH environment variable."
		return $false
	}
	
	return $true
}

# commits changes to svn
function CommitChanges
{
	$status = svn status
    
    if([string]::IsNullOrEmpty($status))
    {
        return
    }
	
	echo $status
	
	$commit = read-host "Commit changes made to" $args[0] "(y/n)?"
	
	if($commit -eq 'y')
	{
		$commitMessage = read-host "Enter commit message"
        $commitMessage = "`" $commitMessage`""
		svn commit -m $commitMessage
	}
}

# publishes nuget package
function PublishPackage
{
	$pub = read-host "Publish package" $package "(y/n)?"
	
	if($pub -ne 'y')
	{
		exit
	}
	
	msbuild $args[0] /target:Rebuild /property:Configuration=Release /verbosity:minimal
	nuget pack $args[0] -Prop Configuration=Release
	net use $args[1] /user:$user $pass
	move *.nupkg $args[1]
}

# updates dependent project
function UpdatePackage
{
	nuget update packages.config
	msbuild $args[0] /target:Clean /verbosity:minimal
	msbuild $args[0] /target:Rebuild /property:Configuration=Release /verbosity:minimal
}

#####################################
##########    EXECUTION    ##########
#####################################

#check requirements
foreach($requirement in $requirements)
{
    $ret = CheckApplication $requirement
    
	if($ret -eq $false)
	{
		$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		exit
	}
}

# publish package
PublishPackage $package $packageRepo

# commit changes to the package
CommitChanges $package

# update dependent projects
foreach($dependent in $dependents)
{
	cd $dependent.path
	UpdatePackage $dependent.name
	
	# commit changes to the dependent project
	CommitChanges $dependent.name
}

$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
