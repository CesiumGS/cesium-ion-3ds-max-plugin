## ↓ **REMOVE BELOW BEFORE RELEASE** ↓


-   [ ] Fix installation instructions link

**Documentation**

-   Under the `Release` section of the _DeveloperGuide_
    -   [ ] Change the release url
    -   [ ] _IF_ the integration provides a custom marketplace provide relevant information

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

**Misc.**

-   [ ] Remove this checklist from the README
-   [ ] Is installation information available on the website or somewhere else?
-   [ ] Is a blog post in progress?
-   [ ] Has the addon been released to [cesium.com](https://github.com/AnalyticalGraphicsInc/cesium.com)?
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

To install the plug-in download the .zip file from release or **[insert link]**.\
Unpack the content to \
%ALLUSERSPROFILE%\Autodesk\ApplicationPlugins\ (e.g. C:\ProgramData\Autodesk\ApplicationPlugins\)\
or\
%APPDATA%\Autodesk\ApplicationPlugins\ (e.g. C:\Users\\\<username>\AppData\Roaming\Autodesk\ApplicationPlugins\).

[**If Uploaded to the Autodesk App Store**]

[Or install it via the Autodesk App Store]()

## Tutorial

Now run 3ds Max. To export your model to Cesium ion go to **File > Export > Export to Cesium ion**.\
Since this is the first time you are using the add-on, you need to allow it to access your Cesium ion account. Click the login button to open your browser and request permissions. You may be asked for your name and password. If you are already logged in, a permissions window similar to the one below will appear immediately.

![Authentication](Documentation/authentification.PNG)

Click Allow, close your browser window, and return to 3ds Max.\
Now press the menu item **File > Export > Export to Cesium ion** again.\
The following panel will appear.

![Upload Dialog](Documentation/upload.PNG)

- **Name** (Required) A name for the ion asset you are uploading.
- **Description** An optional description.
- **Attribution** Any attribution you would like to appear when this asset is loaded into client visualization engines.
- **Model Type** (Required) A hint to ion about the type of model you are uploading. For most Blender models, simply select 3D Model. If you are loading a mesh that originated from a 3D scan, LIDAR, or photogrammetry processes, select 3D Capture instead.
- **Use WebP images** If enabled, will produce a tileset with WebP images, which are typically 25–34% smaller than equivalent JPEG images, leading to faster streaming and reduced data usage. 3D Tiles produced with this option requires a client that supports the glTF EXT_texture_webp extension, such as CesiumJS 1.54 or newer, and a browser that supports WebP, such as Chrome or Firefox 65 and newer.
- **Export only selected** If enabled, only previously selected items will be uploaded.

For this tutorial, enter any name you want and select **3D Model** as the **Model Type**.

Next click **Upload to Cesium ion**

At this point a progress bar will appear and the model will be uploaded to Cesium ion.
After the upload has finished. 3ds Max will then launch a web browser so you can view the asset in the ion dashboard. If not all textures are displayed correctly on the dashboard, you can try to bake them before exporting.\
[Workflow: Texture Baking by Autodesk](https://knowledge.autodesk.com/support/3ds-max/learn-explore/caas/CloudHelp/cloudhelp/2020/ENU/3DSMax-Rendering/files/GUID-37414F9F-5E33-4B1C-A77F-547D0B6F511A-htm.html).


## Contributing

Interested in contributing? See [CONTRIBUTING.md](CONTRIBUTING.md). :heart:
