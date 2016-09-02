<a name="top" href="http://b4b4r07.com/dotfiles"><img align="right" style="margin: -45px;" src="https://github.com/andrewwiik/iOS-Blocks/blob/master/iOS-Blocks.png?raw=true"></a>

### What is iOS Blocks? ###

iOS Blocks is a widget-like system for iOS. It was originally designed by Jay Machalani for a project called "Pushing iOS", a more detailed explanation of the project can be found <a href="http://jaymachalani.com/blog/2014/5/29/pushing-ios">here</a>. iOS Blocks was originally developed largely by Matt Clarke with a few others, after about a year and a half the project got tiring so it was open-sourced in the hopes that a future developer would finish the project. In 2016 a tweak development team called Creatix picked up the project and is working on bringing it to completition. iOS Blocks is currently aiming to support iOS 7 - 9.3.3 on all iPhones, iPads, and iPod Touches.

### What is needed to compile iOS Blocks? ###

iOS Blocks can be compiled using either iOSOpenDev or just Theos.

#### Theos (Recommended) ####

To compile iOS Blocks using theos the iOS 9.2 SDK along with the newest version of theos is required. Also make sure you have the enviorment variable for theos exported properly. If you do not have the enviorment variable for theos not exported properly you can do so by running the following command:

``` export THEOS=PATH_TO_YOUR_THEOS_INSTALLATION ```

All of the private headers that iOS Blocks utilizes have been baked into the project so grabbing external headers should not be needed. To compile the core of iOS Blocks along with its Preferences you should be in the root directory of this project then run the following commands:

``` 
cd curago

make package

```

After iOS Blocks is compiled you should be able to find a debian package (.deb) in a folder titled "debs" in the same directory that you ran the commands to build iOS Blocks.

### Bugs ###

Editing mode is borked for all devices. It's an issue within the code for determining where icons should go AFAIK.# iOS-Blocks
