Powershell Build and Deployment Scripts
---------------------------------------

**pub-nuget-pack.ps1**

Usage

- put the script in the folder the project file of the package you want to publish is in.
- script assumes the project's *.nuspec* file is already at the script folder.
- not having the project to be published and the dependent projects in *Visual Studio* is recommended.

Sample dir structure

ProjectFolder<br/>
|--- ... <br/>
|--- ... <br/>
|--- ... <br/>
|--- Project.csproj <br/>
|--- Projct.nuspec <br/>
|--- pub-nuget-pack.ps1 <br/>


Notes

- currently supports only *msbuild* build engine.
- currently supports only *subversion* version control system.
