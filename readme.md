# Imgur Watch Test
An unofficial Imgur application for viewing random images on a website or mobile app with optional Apple Watch support.

![](www/imgurWatchTestLogo.png?raw=true)

Live demo of app without watch support available at [cowdino.com/iwt](http://cowdino.com/iwt)

## Why?
I have been wanting to work with wearables for awhile now and I figured it was time to try something new in my spare time.

#### What?
1. Main interface created with HTML/javascript.
2. Mobile application packaged with cordova-ios
3. Custom WatchKit extension
4. Apple watch communication capabilities via cordova-plugin-apple-watch

#### App Behavior
* Application displays a random image from imgur, animated and nsfw images are not shown.
* Application has a "Next" button to request a new random image.
* Application has a "Share" button to share the image link via email.
* Application displays a "Send To Watch" button if an Apple Watch is available.

#### Watch App Behavior
* Unknown for the most part, I do not own an Apple Watch, I have never used an Apple Watch, and I have never created a WatchKit extension before.
* Watch UI shows a random image with 2 buttons (Share, Next)

#### Requirements
* Application should be able to run from local filesystem via a desktop web browser.
* Application should be able to run from an actual web service via any javascript enabled web browser.
* Application should be able to run when packaged as a cordova-ios application.
* Application should be able to detect an Apple Watch, this exposes a "Send To Watch" button.

#### Cordova? Javascript? jQuery? Isn't that overkill?
Yes, writing this as a simple Objective-C application would be more efficient.  I spend most of my time working with javascript and Cordova though and the first project I would add Apple Watch functionality to is a javascript app that relies heavily on jQuery and is packaged with Cordova to produce iOS, Android, and WP8 application packages.  So since this is just a simple personal project, I figured I would recreate my full end result environment as much as possible.

## Future Plans?
* Add support for cordova-android and Android Wear (possibly using cordova-androidwear)


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
 * During development there was a newer version, v5.1.1 released, but since my end goal will be on a Cordova 5.0.0 application I am using v5.0.0.  To ensure you are using this verison you can install cordova via the command

   ```sudo npm install cordova@5.0.0 -g```
* XCode
 * Installed from the App Store

#### Build
Run the commands
 * ```cordova platform add ios@3.8.0```
 * ```cordova prepare ios```

**Note**: cordova-ios v3.8.0 was used for development, other versions should work, but have note been tested.

At this point a new directory named "platforms" has been created with a sub directory "ios".  The ios directory has an XCode project that you can work directly with to create builds.

If you do want to work with the IDE itself you can continue to use the cordova command line interface to build the application.
 * ```cordova build ios```
  * This will build the application.
 * ```cordova emulate ios```
  * This will open the application in an iOS simulator.
 * ```cordova run ios```
  * This will run the application on an actual device.
