<a name="top" href="http://iosblocks.com"><img align="right" style="margin: -45px;" src="https://github.com/andrewwiik/iOS-Blocks/blob/master/iOS-Blocks.png?raw=true"></a>[![Build Status](https://travis-ci.org/ioscreatix/iOS-Blocks.svg?branch=master)](https://travis-ci.org/ioscreatix/iOS-Blocks)

What is iOS Blocks?
======

iOS Blocks is a widget-like system for iOS. It was originally designed by Jay Machalani for a project called "Pushing iOS", a more detailed explanation of the project can be found <a href="http://jaymachalani.com/blog/2014/5/29/pushing-ios">here</a>. iOS Blocks was originally developed largely by Matt Clarke with a few others, after about a year and a half the project got tiring so it was open-sourced in the hopes that a future developer would finish the project. In 2016 a tweak development team called Creatix picked up the project and is working on bringing it to completition. iOS Blocks is currently aiming to support iOS 7 - 9.3.3 on all iPhones, iPads, and iPod Touches.

### Where can I install IOS Blocks ###

You can add https://packix.ioscreatix.com/ in Cydia to get the latest version.

### What is required to compile iOS Blocks? ###

iOS Blocks can be compiled using either Theos or iOSOpenDev.

#### Theos (Recommended) ####

To compile iOS Blocks using theos the iOS 9.2 SDK along with the newest version of Theos is required. If you do not have Theos installed you can find instructions for installing Theos <a href="https://github.com/theos/theos/wiki/Installation">here</a>. Also make sure you have the environment variables for theos exported properly. If you do not have the environment variables for Theos not exported properly you can do so by running the following command:

``` export THEOS=PATH_TO_YOUR_THEOS_INSTALLATION ```

All of the private headers that iOS Blocks utilizes have been baked into the project so grabbing external headers should not be needed. To compile the core of iOS Blocks along with its Preferences you should be in the root directory of this project then run the following commands:

``` 
cd curago
make package
```

After iOS Blocks is compiled you should be able to find a debian package (.deb) in a folder labeled **debs** in the same directory that you ran the commands to compile iOS Blocks.

#### iOSOpenDev (OS X users only) ####

In order to compile iOS Blocks using iOSOpenDev you need to follow the instructions outlined <a href="https://github.com/wzqcongcong/iOSOpenDev">here</a> to intstall iOSOpenDev. Please make sure you either download the XCode version 7.2.1 or manually install the 9.2 SDK as Apple started stripping private symbols from SDKs starting with iOS 9.3.

After iOSOpenDev and the proper SDK is installed just open the **curago.xcodeproj** file and press build. After iOS Blocks is finished building you should find  a folder labeled **Packages** in the root directory of the project, inside the directory you will find a debian file (.deb) for iOS Blocks along with a .zip that will contain the contents of the debian package for easier examination.


### Bugs ###

Too many to list right now...
