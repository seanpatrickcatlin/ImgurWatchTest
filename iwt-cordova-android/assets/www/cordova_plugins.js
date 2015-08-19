cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-plugin-apple-watch/www/applewatch.js",
        "id": "cordova-plugin-apple-watch.AppleWatch",
        "clobbers": [
            "applewatch"
        ]
    },
    {
        "file": "plugins/cordova-plugin-splashscreen/www/splashscreen.js",
        "id": "cordova-plugin-splashscreen.SplashScreen",
        "clobbers": [
            "navigator.splashscreen"
        ]
    },
    {
        "file": "plugins/cordova-plugin-statusbar/www/statusbar.js",
        "id": "cordova-plugin-statusbar.statusbar",
        "clobbers": [
            "window.StatusBar"
        ]
    },
    {
        "file": "plugins/cordova-plugin-whitelist/whitelist.js",
        "id": "cordova-plugin-whitelist.whitelist",
        "runs": true
    },
    {
        "file": "plugins/net.trentgardner.cordova.androidwear/www/androidwear.js",
        "id": "net.trentgardner.cordova.androidwear.AndroidWear",
        "clobbers": [
            "AndroidWear"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-apple-watch": "0.9.0",
    "cordova-plugin-splashscreen": "2.1.0",
    "cordova-plugin-statusbar": "1.0.1",
    "cordova-plugin-whitelist": "1.0.0",
    "net.trentgardner.cordova.androidwear": "0.0.3"
}
// BOTTOM OF METADATA
});