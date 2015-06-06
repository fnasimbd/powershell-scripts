Powershell Build and Deployment Scripts
---------------------------------------

**pub-nuget-pack.ps1**

Description

Publishes a Visual Studio project as a NuGet package and updates its specified dependents.

Usage

- put the script in the folder the project file of the package you want to publish is in.
- script assumes the project's *.nuspec* file is already at the script folder.
- not having the project to be published and the dependent projects in *Visual Studio* is recommended.

Notes

- currently supports only *msbuild* build engine.
- currently supports only *subversion* version control system.

-------

**update-version.ps1**

Description

Increases the major or minor version (as specified by user) in *AssemblyInfo.cs*.

Notes
- *tricky case:* updating 1.99.0.0 gives 1.100.0.0 (not 2.0.0.0 or anything else.)


