# Development

Follow these steps to run the addon directly from source so that your changes will be reflected in Blender.

1. **[REPLACEME]** COMPLETE INSTRUCTIONS
1. Discuss how to get the repository running on any operating system (including Unix, Linux and Windows). The steps should outline from cloning the repository to having the application running in a development state.

## Debugging

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
