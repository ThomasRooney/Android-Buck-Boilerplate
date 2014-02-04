# Android Buck Boilerplate

Buck is Facebook's tool to build android applications. It provides a simple yet powerful configuration system to build android application via the terminal. 

This is the boilerplate I use when developing Android applications. Scripts to download and configure the android sdk/ndk, are included, allowing simple delivery of android applications without the hassle of ensuring the correct libraries are installed.

The android application included here as an example is absoloutely minimal, containing one layout, and one main class to execute it with. However this style of designing Android applications extends well for large and complex applications developed by multiple people. Libraries can be simplistically included, visibility of modules is explicitly defined, and code can be re-used for multiple different applications in a very simple way.

This has been tested and configured for both Mac and Linux.

Buck is especially good at handling applications which highly rely on native components, which I've personally found to be a major source of pain when working with IDEs like Eclipse and the Android Studio.

To get started, you need `ant`, which is required to build `buck`. Once that's done, run this sequence of commands to download the three dependencies

	./scripts/get-buck.sh
	./scripts/get-android-sdk.sh
	./scripts/get-android-ndk.sh

Then, running this command configures for android-16 and android-8. Have a look at this file to change it for your target
Please note, this accepts all the android sdk licences, so it's rather recommended to have a look at what you're agreeing to.
	./scripts/configure-sdk.sh 

The local.properties file in the root directory must also be updated with absoloute paths, so running this script generates that
	./scripts/configure-local.sh

At this point, `buck`, the `ndk` and `sdk` are fully set up for your system.

Running this next command produces keys used to sign the .apk, so it can be installed on a device.
	./scripts/regen-keys.sh

Finally, at this point you should be able to build the Android application with `buck build app` in the root directory of this project. 
This command is also wrapped with
	./scripts/build.sh