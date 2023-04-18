# ideckia

Mobile client for [ideckia](http://ideckia.github.io). Download the latest version from the [releases page](https://github.com/ideckia/mobile_client/releases/latest)

This app only shows the server state and executes actions in the server when clicked elements. Really nothing happens in this app, basically is a remote control.

## Gestures

Some gestures support was added:

* Horizontal swipe, from left to right: Goes to the previous directory
* Vertical swipe, from bottom to top: Goes to the main directory

## Log view

Touch the screen with three fingers to show the log. In this view there are to buttons in the top-right corner:

* Go to insert the IP manually (![](https://cdn3.iconfinder.com/data/icons/google-material-design-icons/48/ic_dehaze_48px-48.png) button).
* Reload the app (![](https://cdn3.iconfinder.com/data/icons/google-material-design-icons/48/ic_autorenew_48px-48.png) button).

## SimpleRichText

[SimpleRichText](https://pub.dev/packages/simple_rich_text) is used to render the item text. You can send thing like the following to the item.

* `*_/bold, underlined and italicized*_/`
* `*{color:red}bold*`
* `_{color:green}underlined_`
* `/{color:brown}italicized/)`
* `different ~{fontSize:10}font~ size`
