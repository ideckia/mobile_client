## Ideckia: Privacy policy

Welcome to the Ideckia app for Android!

This is an open source Android app developed by Josu Igoa. The source code is available on GitHub under the GPLv2 license; the app is also available on Google Play and F-Droid.

This application does not save any information about the user or the preferences selected.

### Explanation of permissions requested in the app

The list of permissions required by the app can be found in the `AndroidManifest.xml` file:

https://github.com/ideckia/mobile_client/blob/develop/android/app/src/main/AndroidManifest.xml#L3-L5

<br/>

| Permission | Why it is required |
| :---: | --- |
| `android.permission.INTERNET` | This is required to communicate with the computer this app will control. May sound scary to have permission to the internet, but it only is used to get the panel information from the server and send back what item was clicked, no user data involved. |

 <hr style="border:1px solid gray">

If you find any security vulnerability that has been inadvertently caused by me, or have any question regarding how the app protectes your privacy, please post a discussion on GitHub, and I will surely try to fix it/help you.
