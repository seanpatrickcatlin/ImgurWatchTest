# Imgur Watch Test
An unofficial Imgur application for viewing random images on a website or mobile app with optional Apple Watch support.

![](www/imgurWatchTestLogo.png?raw=true)

## Why?
I have been wanting to work with wearables for awhile now and I figured it was time to try something new in my spare time.

#### What?
1. Main interface created with HTML/javascript.
2. Mobile application packaged with cordova-ios
3. Custom WatchKit extension
4. Apple watch communication capabilities via cordova-plugin-apple-watch

#### App Behavior
* Application displays a random image from imgur, nsfw images are not shown.
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
