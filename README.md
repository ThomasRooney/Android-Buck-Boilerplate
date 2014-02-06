# Android Buck Boilerplate

Buck is Facebook's tool to build android applications. It provides a simple yet powerful configuration system to build android application via the terminal. 

This is the boilerplate I use when developing Android applications. Scripts to download and configure the android sdk/ndk, are included, allowing simple delivery of android applications without the hassle of ensuring the correct libraries are installed.

The android application included here as an example is absoloutely minimal, containing one layout, and one main class to execute it with. However this style of designing Android applications extends well for large and complex applications developed by multiple people. Libraries can be simplistically included, visibility of modules is explicitly defined, and code can be re-used for multiple different applications in a very simple way.

This has been tested and configured for both Mac and Linux.

Buck is especially good at handling applications which highly rely on native components, which I've personally found to be a major source of pain when working with IDEs like Eclipse and the Android Studio.

# Getting started

If you already have buck and the android sdk, and your `ANDROID_SDK` environment variable set, skip to "Building the application".

To get started, you need `ant`, which is required to build `buck`. Once that's done, run the following sequence of commands to download the three dependencies.

If you're not using the `ndk`, you don't have to run the `./scripts/get-android-ndk.sh` shell script.

	./scripts/get-buck.sh
	./scripts/get-android-sdk.sh
	./scripts/get-android-ndk.sh

Then, running this command configures the sdk for android-16 and android-8. Have a look at this file to change it for your target
Please note, this accepts all the android sdk licences, so it's rather recommended to have a look at what you're agreeing to. Also, it is recommended that this script is run twice, as for some reason not all the dependencies are always downloaded on single run.

	./scripts/configure-sdk.sh 

There must be a local.properties file in the root directory that has absoloute paths to the dependencies, so running this script generates that for you.

	./scripts/configure-local.sh


At this point, `buck` and the android sdk/ndk are fully set up for your system.

Running this next command produces keys used to sign the .apk, so it can be installed on a device.

	./scripts/regen-keys.sh

# Building the application

Finally, at this point you should be able to build the Android application with `buck build app` in the root directory of this project. 
This command is also wrapped with the following script

	./scripts/build.sh

Once the build has completed successfully, the apk is deposited as:

	./buck-out/gen/apps/example/app.apk

# Testing the application

Create and start an emulator with

	./scripts/create_emulator.sh
	./scripts/start_emulator.sh

The emulator is persistant, so you should don't need to create it again. Just start it for each use.

The application can then be installed on the emulator (or device, should there be one attached that can be found with `adb devices` and no emulator running ) via the command

	/scripts/install.sh

# Using this as boilerplate

If you're planning to actually use this as boilerplate, rather than just testing, you might want to have a look at this script

	$ ./scripts/configure-project.sh 
	usage ./configure-project.sh <package> <appname>
	  for example:
	    ./configure-project.sh "com.buck.example" "buckexample" 
	  This command resets all files/directories to a new state with the given parameters

What this will do is put the project into an initial, working (hopefully) state for a given package and application. It will rewrite configuration files and scripts as needed.

A common workflow, to begin a new Android application, could be something along the lines of:

	echo "This uses git archive to get a snapshot of this project"
	./scripts/archive.sh
	mkdir -p ~/Code/MY_ANDROID_PROJECT
	mv android-example-src.tar.gz ~/Code/MY_ANDROID_PROJECT
	cd ~/Code/MY_ANDROID_PROJECT
	tar -xf android-example-src.tar.gz
	rm android-example-src.tar.gz
	./scripts/configure-project.sh com.hello.world helloworld
	./scripts/build.sh




