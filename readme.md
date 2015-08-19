# Imgur Watch Test
An unofficial Imgur application for viewing random images on a website or mobile app with optional smart watch support.

![](www/imgurWatchTestLogo.png?raw=true)

Live demo of web app without smart watch support available at [cowdino.com/iwt](http://cowdino.com/iwt)

## Project Status
* Android wear: In progress
* Web app: Working
* iOS app: Working
* Apple Watch app: Working
* Android app: Working
* Automate adding watchkit extension and app to iOS app: It's complicated...
* Automate adding android wear to Android app: Not started

## Why?
I have been wanting to work with wearables since Android Wear was announced and I figured it was time to try something new in my spare time.

#### What?
1. Main interface created with HTML/javascript, can be ran as a mobile web site or cordova packaged application.
2. iOS Support
 * Mobile application packaged with cordova-ios
 * Custom WatchKit extension
 * Apple watch communication capabilities via [cordova-plugin-apple-watch](https://github.com/leecrossley/cordova-plugin-apple-watch)
3. Android Support
 * Mobile application packaged with cordova-android
 * Custom Android Wear companion app
 * Android wear communication capabilities via [cordova-androidwear]("https://github.com/tgardner/cordova-androidwear")

## Current Issues
1. iOS Automation
  While I am perfectly capable of manually adding a watchkit extension/app to an existing xcodeproject I am struggling to find a way to automate adding a watchkit extension and application to the generated Cordova application.  I prefer to keep my Cordova projects clean, never checking in an XCode project and allowing Cordova to generate one for me based off of my config.xml file.  I then use custom Cordova plugins and or custom Cordova hooks to extend the base Cordova xcode project.  My goal is that from a properly configured system with a fresh copy of the Cordova projects source tree the xcode project can be dynamically generated based on the various methods Cordova exposes during the "cordova platform add" and "cordova prepare" commands.
2. iOS App Groups
  Communication between an iOS application and a watchkit extension via MMWormhole uses app groups.  This would generally not be a problem, but my personal Apple ID is not enrolled in an Apple developer program (my ).

   I do not have a personal paid Apple developer account.  My paid development account is tied to my employer and I will not use that account for a personal project.  I will be needing to get my own paid account to continue development on this.


#### Web and Mobile App Behavior
* Application displays a random image from imgur, animated and nsfw images are not shown.
* Application has a "Next" button to request a new random image.
* Application has a "Share" button to share the image link via email.
* ~~Application displays a "Send To Watch" button if an Apple Watch is available.~~
 * So we can send basic messages from watch to phone and phone to watch, but we cannot actually launch the phone app from the watch or launch the watch app from the phone (for Apple Watch at least).

#### Watch App Behavior
* Application has a page that shows a random image along with the following buttons
 1. < - to see the previous image
 2. > - to see the next image
 3. Sart/Stop - Pressing start with begin displaying 2 random images a second and change the button to a stop button.  Pressing stop will terminate displaying images automatically.

#### Requirements
* Application should be able to run from local filesystem via a desktop web browser (specifically chrome started with the --disable-web-security flag).
* Application should be able to run from an actual web service via any javascript enabled web browser.
* Application should be able to run when packaged as a cordova-ios application.
* ~~Application should be able to detect an Apple Watch, this exposes a "Send To Watch" button.~~
 * Application should pass some form of data to the watch.
 * Watch app should pass some form of data to the phone app.
* Application should be able to run when packaged as a cordova-android application.
* Application should have a companion Apple Watch and Android Wear application.

#### Cordova? Javascript? jQuery? Isn't that overkill?
Yes, writing this as a simple Objective-C / Java application would be more efficient.  I spend most of my time working with javascript and Cordova though and the first project I would add smart watch functionality to is a javascript app that relies heavily on jQuery and is packaged with Cordova to produce iOS, Android, and WP8 application packages.  So while this is just a simple personal project, I figured it would be best if I recreate my full end result environment as much as possible.


## Building
#### Requirements
* [nodejs](https://nodejs.org/)
 * v0.12.7 was used while developing this project, other versions should work but have not been tested.
 * If you don't have it installed you can get it from [nodejs.org](https://nodejs.org/)
 * If you do have it installed but want to update I recommend using the [node version manager](https://www.npmjs.com/package/n) to update to the latest with the command

   ```sudo npm install n -g```
* [npm](https://www.npmjs.com/) (comes with nodejs)
 * v2.13.3 was used for development, other versions should work but have not been tested.
 * npm can be updated by running the command

   ```sudo npm install npm -g```
* [Apache Cordova](https://cordova.apache.org/)
 * v5.0.0 was used for development, other versions should work but have not been tested.
 * This is installed through npm by running the command

   ```sudo npm install cordova -g```.
 * During development there was a newer version, v5.1.1 released, but since my end goal will be on a Cordova 5.0.0 application I am using v5.0.0.  To ensure you are using this verison you can install Cordova via the command

   ```sudo npm install cordova@5.0.0 -g```
* XCode
 * Installed from the App Store

#### iOS Build
Run the commands
 * ```cordova platform add ios@3.8.0```
 * ```cordova prepare ios```

**Note**: cordova-ios v3.8.0 was used for development, other versions should work, but have note been tested.

At this point a new directory named "platforms" has been created with a sub directory "ios".  The ios directory has an XCode project that you can work directly with to create builds.

If you do want to work with the IDE itself you can continue to use the Cordova command line interface to build the application.
 * ```cordova build ios```
  * This will build the application.
 * ```cordova emulate ios```
  * This will open the application in an iOS simulator.
 * ```cordova run ios```
  * This will run the application on an actual device.

#### Android Build
Run the commands
 * ```cordova platform add android@4.0.0```
 * ```cordova prepare android```

**Note**: cordova-android v4.0.0 was used for development, other versions should work, but have note been tested.

At this point a new directory named "platforms" has been created with a sub directory "android".  The android directory is suitable to be imported as an existing Android project into Android Studio 1.3.1 so that you can work directly with an IDE to create builds.

If you do want to work with the IDE itself you can continue to use the Cordova command line interface to build the application.
 * ```cordova build android```
  *  This will build the application.
 * ```cordova emulate android```
  * This will open the application in an Android simulator.
 * ```cordova run android```
  * This will run the application on an actual device.
