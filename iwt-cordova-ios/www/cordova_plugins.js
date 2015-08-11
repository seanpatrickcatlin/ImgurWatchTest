cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-plugin-statusbar/www/statusbar.js",
        "id": "cordova-plugin-statusbar.statusbar",
        "clobbers": [
            "window.StatusBar"
        ]
    },
    {
        "file": "plugins/cordova-plugin-apple-watch/www/applewatch.js",
        "id": "cordova-plugin-apple-watch.AppleWatch",
        "clobbers": [
            "applewatch"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.0.0",
    "cordova-plugin-statusbar": "1.0.1",
    "cordova-plugin-apple-watch": "0.9.0"
}
// BOTTOM OF METADATA
});