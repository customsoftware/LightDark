# LightDark
This is an app I built as a testbed for getting an app to automatically switch to a "dark" mode in low-light situations.

The way the code works is it listens for system notifications indicating the brightness of the device's display. That value, along with a stored threshhold value are the key components to this approach.

There are two protocols, one for handling Navigation bars, Tab bars, View controllers and text fields. The other handles the status bar. I've included a sample app to show how the changes are captured and utilized. There are lots of ways to modify this. There's no cocoa pod for this as yet. So far, just clone the repo and add the class and protocols/enums, etc. to your app.
