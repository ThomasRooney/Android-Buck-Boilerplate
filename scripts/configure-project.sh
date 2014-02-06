#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"


# Quick and hacky generator to get started on new projects fast

function pause(){
   read -p "$*"
}

if [ $# -lt 2 ] ; then
	echo "usage ./configure-project <package> <appname>"
	echo "  for example:"
	echo "    ./configure-project \"com.buck.example\" \"buckexample\" "
	echo "  This command resets all files/directories to a new state with the given parameters"
	exit
fi

# Warning
echo "** This command will overwrite most of your project files **"
echo "** NEVER RUN THIS FILE WHEN IT IS IN A DIRECTORY OTHER THAN THE SCRIPTS DIRECTORY **"
pause 'Press [Enter] key to continue...'

package=$1
appname=$2

dirpackage=${package//[\.]//}

pause "package: ${package}"
pause "appname: ${appname}"
pause "dirpackage: ${dirpackage}"
#replace "." with "/"
#com/buck/example

(
	cd $DIR/../apps
	mv example ${appname}
	cd ${appname}
	rm -f AndroidManifest.xml
	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" >> AndroidManifest.xml
	echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"" >> AndroidManifest.xml
	echo "    package=\"${package}\"" >> AndroidManifest.xml
	echo "    android:versionCode=\"1\"" >> AndroidManifest.xml
	echo "    android:versionName=\"1.0\" >" >> AndroidManifest.xml
	echo "    <application" >> AndroidManifest.xml
	echo "        android:allowBackup=\"true\"" >> AndroidManifest.xml
	echo "        android:label=\"@string/app_name\"" >> AndroidManifest.xml
	echo "        android:theme=\"@style/AppTheme\" >" >> AndroidManifest.xml
	echo "        <activity" >> AndroidManifest.xml
	echo "            android:name=\"${package}.MainActivity\"" >> AndroidManifest.xml
	echo "            android:configChanges=\"orientation|keyboardHidden|screenSize\"" >> AndroidManifest.xml
	echo "            android:label=\"@string/app_name\" >" >> AndroidManifest.xml
	echo "            <intent-filter>" >> AndroidManifest.xml
	echo "                <action android:name=\"android.intent.action.MAIN\" />" >> AndroidManifest.xml
	echo "                <category android:name=\"android.intent.category.LAUNCHER\" />" >> AndroidManifest.xml
	echo "            </intent-filter>" >> AndroidManifest.xml
	echo "        </activity>" >> AndroidManifest.xml
	echo "    </application>" >> AndroidManifest.xml
	echo "</manifest>" >> AndroidManifest.xml

	rm -f debug.keystore.properties
	echo "key.alias=${appname}" > debug.keystore.properties
	echo "key.store.password=${appname}password" > debug.keystore.properties
	echo "key.alias.password=${appname}password" > debug.keystore.properties

	rm -f debug.keystore
	rm -f BUCK

	echo "android_binary(" >> BUCK
	echo "  name = 'app'," >> BUCK
	echo "  manifest = 'AndroidManifest.xml'," >> BUCK
	echo "  target = 'Google Inc.:Google APIs:16'," >> BUCK
	echo "  keystore = ':debug_keystore'," >> BUCK
	echo "  deps = [" >> BUCK
	echo "    '//java/${dirpackage}:activity'," >> BUCK
	echo "    '//res/${dirpackage}:res'," >> BUCK
	echo "  ]," >> BUCK
	echo ")" >> BUCK
	echo "" >> BUCK
	echo "keystore(" >> BUCK
	echo "  name = 'debug_keystore'," >> BUCK
	echo "  store = 'debug.keystore'," >> BUCK
	echo "  properties = 'debug.keystore.properties'," >> BUCK
	echo ")" >> BUCK
	echo "" >> BUCK
	echo "project_config(" >> BUCK
	echo "  src_target = ':app'," >> BUCK
	echo ")" >> BUCK

	cd $DIR/../java

	mkdir -p ${dirpackage}
	mv com/buck/example/* ${dirpackage}
	rmdir com/buck/example
	rmdir com/buck/
	rmdir com
	cd ${dirpackage}
	rm -f BUCK
	echo "android_library(" >> BUCK
	echo "  name = 'activity'," >> BUCK
	echo "  srcs = glob(['*.java'])," >> BUCK
	echo "  deps = ['//res/${dirpackage}:res']," >> BUCK
	echo "  visibility = [ 'PUBLIC' ]," >> BUCK
	echo ")" >> BUCK
	echo "" >> BUCK
	echo "project_config(" >> BUCK
	echo "  src_target = ':activity'," >> BUCK
	echo ")" >> BUCK
	
	cat MainActivity.java | tail -n +2 | > MainActivity.java

	echo $'package ${package};' >tmp
	cat MainActivity.java >>tmp
	rm MainActivity.java
	mv tmp MainActivity.java

	cd $DIR/../res
	mkdir -p ${dirpackage}
	mv com/buck/example/res ${dirpackage}
	rm -f com/buck/example/BUCK
	rmdir com/buck/example
	rmdir com/buck/
	rmdir com
	cd ${dirpackage}

	echo "android_resource(" >> BUCK
	echo "  name = 'res'," >> BUCK
	echo "  res = 'res'," >> BUCK
	echo "  package = '${package}'," >> BUCK
	echo "  visibility = [" >> BUCK
	echo "    'PUBLIC'" >> BUCK
	echo "  ]," >> BUCK
	echo ")" >> BUCK
	echo "" >> BUCK
	echo "project_config(" >> BUCK
	echo "  src_target = ':res'," >> BUCK
	echo ")" >> BUCK

	cd $DIR
	rm -f build.sh install.sh regen_keys.sh archive.sh

	echo " #!/usr/bin/env bash" >> build.sh
	echo " " >> build.sh
	echo " DIR=\"\$( cd \"\$( dirname \"\$0\" )\" && pwd )\"" >> build.sh
	echo " " >> build.sh
	echo " (" >> build.sh
	echo " 	cd \$DIR/../" >> build.sh
	echo " 	buck build apps/${appname}:app" >> build.sh
	echo " )" >> build.sh
	chmod +x build.sh

	echo " #!/usr/bin/env bash" >> install.sh
	echo " " >> install.sh
	echo " DIR=\"\$( cd \"\$( dirname \"\$0\" )\" && pwd )\"" >> install.sh
	echo " " >> install.sh
	echo " (" >> install.sh
	echo " 	cd \$DIR/../" >> install.sh
	echo " 	buck install apps/${appname}:app" >> install.sh
	echo " )" >> install.sh
	chmod +x install.sh


	echo " #!/usr/bin/env bash" >> regen_keys.sh
	echo " DIR=\"\$( cd \"\$( dirname \"\$0\" )\" && pwd )\"" >> regen_keys.sh
	echo " " >> regen_keys.sh
	echo " if [ -f \$DIR/../apps/${appname}/debug.keystore ] ; then" >> regen_keys.sh
	echo "   rm \$DIR/../apps/${appname}/debug.keystore" >> regen_keys.sh
	echo " fi" >> regen_keys.sh
	echo " " >> regen_keys.sh
	echo " keytool -genkey -noprompt \\" >> regen_keys.sh
	echo "  -keystore \$DIR/../apps/${appname}/debug.keystore \\" >> regen_keys.sh
	echo "  -alias      ${appname} \\" >> regen_keys.sh
	echo "  -dname \"\" \\" >> regen_keys.sh
	echo "  -storepass ${appname}password \\" >> regen_keys.sh
	echo "  -keypass ${appname}password \\" >> regen_keys.sh
	echo "  -keyalg RSA -keysize 2048 -validity 10000" >> regen_keys.sh
	chmod +x regen_keys.sh

	echo " #!/usr/bin/env bash" >> archive.sh
	echo " DIR=\"\$( cd \"\$( dirname \"\$0\" )\" && pwd )\"" >> archive.sh
	echo "(cd \$DIR/.. ; git archive --format tar.gz HEAD > android-${appname}-src.tar.gz)" >> archive.sh
	chmod +x archive.sh

	rm -f $DIR/../.buckconfig
	echo "[alias]" >> $DIR/../.buckconfig
    echo "   app = //apps/${appname}:app" >> $DIR/../.buckconfig


	$DIR/regen_keys.sh
)
