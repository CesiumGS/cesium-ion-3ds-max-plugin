## ↓ **REMOVE BELOW BEFORE RELEASE** ↓

Use this checklist to setup your GitHub repository before it's inital release.

#### Notes

-   All documentation should be placed in the `Documentation` folder with another folder in Camel Case to denote the subject and a `README.md` with the relevant content. All media such as images and diagrams should be placed in the new folder. Anything contained in a subject folder should strictly relate to documentation.
-   The file structure should go as follows:

```
Documentation
    DeveloperGuide      # Documentation Subject
        README.md       # Relevant notes that will display when folder is focused.
        <asset>.png/jpg # All media related content be placed in the documentation folder
CHANGELOG.md            # Release notes that mirror the releases page of GitHub
CODE_OF_CONDUCT.md      # Cesium's standard Code of Conduct (DO NOT CHANGE)
LICENSE                 # Cesium's standard LICENSE for integrations (DO NOT CHANGE)
ThirdPary.json          # Reference of the projects immediate third party libraries
README.md               # Projects landing page. Should be readable, and work as an index
```

#### Pre-Release Checklist

**README**

-   [ ] Add a functional description that is no longer than two sentences to outline features.
-   [ ] Take screenshots of the application running reflecting the raw appplication state, uploading to ion, and asset available in ion. Feel free to take some creative liberties here.
-   [ ] Place screenshots in screenshot section.
-   [ ] Fix installation instructions link

**Documentation**

-   Under the `Release` section of the _DeveloperGuide_
    -   [ ] Change the release url
    -   [ ] _IF_ the integration provides a custom marketplace provide relevant information
    -   [ ] Fill in the **Create the release package** section
    -   [ ] Fill in the **Testing** section
    -   [ ] Fill in the **Release** section
-   In the _DeveloperGuide_
    -   [ ] **Either** remove the development section **or** provide development tips
    -   [ ] Fill in the **Development** section

**Changes**

-   [ ] Follow the release process outlined in the documentation and create a release
-   [ ] Create a list of features available in this release. _Should have the following format:_

```
### 1.0.0 - 0000-00-00

-   **[REPLACEME]** Contains a list of: features, bugs, changes.
-   **[REPLACEME]** First version usually contains a link to a blog post.
-   **[REPLACEME]** These note should reflect the notes on the releases page.
```

-   [ ] Add feature list to `CHANGES.md`

**Third Party**

-   [ ] Add all third part libraries in the following format to `ThirdPary.json`
-   [ ] Check all licenses are respected in repository per library

```
{
    "name": "[Name of Library]",
    "url": "[Url to Library]",
    "license": "[License of Library]"
}
```

**Misc.**

-   [ ] Search for "[REPLACEME]" to make sure all content has been updated
-   [ ] If there are files that should not be tracked ensure they are added to the `.gitignore` and removed from tracking
-   [ ] Remove this checklist from the README
-   [ ] Is installation information available on the website or somewhere else?
-   [ ] Is a blog post in progress?
-   [ ] Has the the addon been released to [cesium.com](https://github.com/AnalyticalGraphicsInc/cesium.com)?
-   [ ] Check that the license has the proper year (i.e. the current year)

## ↑ **REMOVE ABOVE BEFORE RELEASE** ↑

<p align="center">
  <img src="https://github.com/AnalyticalGraphicsInc/cesium/wiki/logos/Cesium_Logo_Color.jpg" width="50%" />
</p>

The Cesium ion 3ds Max add-on enables you to effortlessly publish and stream 3D models on the web.

Leveraging Cesium ion and the power of 3D Tiles, even multi-gigabyte models can be streamed to any device without having to download the entire tileset up front. By visualizing 3D Tiles with CesiumJS, you can fuse your models with other datasets, add geospatial context to place it at a real world location, or overlay additional details and analysis.

Learn more at [cesium.com](https://cesium.com)

<p align="center">
    <img src="" width="50%" />
    
    [REPLACEME] Screeenshots - One to three screenshots go great here. Demonstrating the usage of the application and the result in ion.
</p>
<p align="center">
    [REPLACEME] A description of the pictures
</p>

## Installation

**[REPLACEME]** Read the [installation guide](https://BROKEN_LINK/) to get started.

**PUT THIS IN THE INSTALLATION GUIDE**

Requirements: .NET Core 3.0 or latest .NET Framework (previous versions might work but are unsupported)\
To install the plug-in download the .zip file from release or **[insert link]**.\
Unpack the content to \
%ALLUSERSPROFILE%\Autodesk\ApplicationPlugins\ (e.g. C:\ProgramData\Autodesk\ApplicationPlugins\)\
or\
%APPDATA%\Autodesk\ApplicationPlugins\ (e.g. C:\Users\<username>\AppData\Roaming\Autodesk\ApplicationPlugins\).

[**If Uploaded to the Autodesk App Store**]

[Or install it via the Autodesk App Store]()

## Tutorial

Now run 3ds Max. To export your model to Cesium ion go to **File > Export > Export to Cesium ion**.\
Since this is the first time you are using the add-on, you need to allow it to access your Cesium ion account. Click the login button to open your browser and request permissions. You may be asked for your name and password. If you are already logged in, a permissions window similar to the one below will appear immediately.\
**[Insert image here]**\
Click Allow, close your browser window, and return to 3ds Max.\
Now press the menu item **File > Export > Export to Cesium ion** again.\
The following panel will apper.\
**[Insert image here]**
- **Name** (Required) A name for the ion asset you are uploading.
- **Description** An optional description.
- **Attribution** Any attribution you would like to appear when this asset is loaded into client visualization engines.
- **Model Type** (Required) A hint to ion about the type of model you are uploading. For most Blender models, simply select 3D Model. If you are loading a mesh that originated from a 3D scan, LIDAR, or photogrammetry processes, select 3D Capture instead.
- **Use WebP images** If enabled, will produce a tileset with WebP images, which are typically 25–34% smaller than equivalent JPEG images, leading to faster streaming and reduced data usage. 3D Tiles produced with this option requires a client that supports the glTF EXT_texture_webp extension, such as CesiumJS 1.54 or newer, and a browser that supports WebP, such as Chrome or Firefox 65 and newer.
- **Export only selected** If enabled, only previously selected items will be uploaded.

For this tutorial, enter any name you want and select **3D Model** as the **Model Type**.

Next click **Upload to Cesium ion**

At this point a progress bar will appear and the model will be uploaded to Cesium ion. 


## Contributing

Interested in contributing? See [CONTRIBUTING.md](CONTRIBUTING.md). :heart:
