# Development

Follow these steps to run the addon directly from source so that your changes will be reflected in Blender.

1. **[REPLACEME]** COMPLETE INSTRUCTIONS
1. Discuss how to get the repository running on any operating system (including Unix, Linux and Windows). The steps should outline from cloning the repository to having the application running in a development state.


# Running on windows

**Visual Studio Code**
Open the project in VS Code.

To deploy code directly from VS Code to 3ds Max follow this tutorial:
https://walterlow.com/setting-up-visual-studio-code-as-an-editor-for-3ds-maxscript/

Use this build task to run the project:
```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
       {
          "label": "Execute Script in 3ds Max",
          "type": "shell",
          "command": "C:\\PATH_TO\\MXSPyCOM.exe",
          "args": [
             "-s",
             "${file}"
          ],
          "presentation": {
             "echo": false,
             "reveal": "never",
             "focus": false,
             "panel": "dedicated"
          },
          "problemMatcher": [],
       }
    ]
}
```

**Running the plugin**
Open *Pluginpackage/PreStartupScripts/cesiumPlugin.ms*.
Run it with *crtl + shift + b*.
Open *Pluginpackage/PreStartupScripts/mainWidget.ms* and run it. This creates the Exporter popup window.
Next open *Pluginpackage/PreStartupScripts/addMenus.ms* and run it. This will add the menu item in 3ds Max under *File->Export*.
Running these files in a different order will create an error in 3ds Max.

**Updating popups**
To update the popup simply rerun the .ms file which creates it (for example *mainWidget.ms*).

**Delete old menus**
When you close and reopen 3ds Max it can happen that the previously created export menu item will get lost. In that case it will still appear in there but with the text *Missing: exportButton'mxs docs* and without any functionality. To delete it open *Customize->Customize User Interface*. Open the *Menus* tab and delete it in the panel on the right under *File->File_Export* by selecting it and pressing *entf* on your key board. Afterwards repeat the steps to run the plugin.


## Debugging
Code can be debugged using the
```python
print "something"
```
command or by placing a 
```python
break()
```
in the code. The later one opens the 3ds Max debugger.


1. **[REPLACEME]** COMPLETE INSTRUCTIONS - _optional but can be helpful_
1. **[REPLACEME]** Helpful hints in the debugging process are best placed here. Sometimes development environments can be complicated with lots of moving parts as well as externalities that can make debugging difficult. However, if you built the add-on it is more than likely that you have figured out ways to make your workflow simple. Share that for the next developer.

## Releases

**Create the release package**

1. Pull down the latest master branch: `git pull origin master`
1. **[REPLACEME]** COMPLETE INSTRUCTIONS
1. **[REPLACEME]** What is the standard practice for creating a release package? Is this done using Travis, a local process, or build script? These steps should mirror running in a clean production environment as close as possible.

**Testing**

1. **[REPLACEME]** COMPLETE INSTRUCTIONS
1. **[REPLACEME]** Run through common use cases and evaluate the add-on works as expected. Try breaking things, standard integration tests. CI tests are fantastic but depending on the scale of the project may not be required.

**Release**

Once all tests have pass, we can actually publish the release.

1. Create and push a tag, e.g.,

-   `git tag -a 1.1 -m '1.1 release'`
-   `git push origin 1.1` (do not use `git push --tags`)

1. Publish the release zip file to GitHub

-   [Create new release](https://github.com/ORG/REPO/releases/new). **[REPLACEME]**
-   Select the tag you use pushed
-   Enter `Cesium ion Integration Name [REPLACEME] 1.x` for the title
-   In the description, include the date, list of highlights and permalink to CHANGES.md, which is in the format https://github.com/AnalyticalGraphicsInc/cesium-ion-blender-addon/blob/1.xx/CHANGES.md, where 1.xx is the version number.
-   Attach the `io-cesium-ion-vx.x.x.zip` you generated during the build process.
-   Publish the release

1. Tell the outreach team about the new release to have it included in the monthly release announcements/blog post and on social media.
1. Update cesium.com with a link to the latest release zip.
