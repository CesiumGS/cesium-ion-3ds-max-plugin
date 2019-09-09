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

**[REPLACEME]** A functional description in one to two sentence.

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

## Contributing

Interested in contributing? See [CONTRIBUTING.md](CONTRIBUTING.md). :heart:
