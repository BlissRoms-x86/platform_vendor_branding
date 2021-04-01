#!/bin/bash
set -e

repo="https://f-droid.org/repo/"

addCopy() {
	addition=""
	#~ if unzip bin/$1 lib/* > /dev/null 2>&1 ; then
		#~ echo "Extracting libs for: $2"
		#~ addition="
			#~ LOCAL_PREBUILT_JNI_LIBS := \\
			#~ $(unzip -lv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/arm64-v8a/.*);\t\1 \\;p') \\
			#~ $(unzip -lv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/x86/.*);\t\1 \\;p') \\
			#~ $(unzip -lv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/x86_64/.*);\t\1 \\;p')
					#~ "
	#~ else 
		#~ echo "Skipping lib extraction for: $2"
	#~ fi
    if [ "$2" == com.google.android.gms ] || [ "$2" == com.android.vending ] ;then
        addition="LOCAL_PRIVILEGED_MODULE := true"
    fi
cat >> Android.mk <<EOF
include \$(CLEAR_VARS)
LOCAL_MODULE := $2
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := bin/$1
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_OVERRIDES_PACKAGES := $3
$addition
include \$(BUILD_PREBUILT)

EOF
echo -e "\t$2 \\" >> apps.mk
}

rm -Rf apps.mk lib
cat > Android.mk <<EOF
LOCAL_PATH := \$(my-dir)

EOF
echo -e 'PRODUCT_PACKAGES += \\' > apps.mk

mkdir -p bin

#downloadFromFdroid packageName overrides
downloadFromFdroid() {
	mkdir -p tmp
    [ "$oldRepo" != "$repo" ] && rm -f tmp/index.xml
    oldRepo="$repo"
	if [ ! -f tmp/index.xml ];then
		#TODO: Check security keys
		wget --connect-timeout=10 $repo/index.jar -O tmp/index.jar
		unzip -p tmp/index.jar index.xml > tmp/index.xml
	fi
	marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]' -v ./marketvercode tmp/index.xml || true)"
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname tmp/index.xml || xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[1]' -v ./apkname tmp/index.xml)"
    if [ ! -f bin/$apk ];then
        while ! wget --connect-timeout=10 $repo/$apk -O bin/$apk;do sleep 1;done
    fi
	addCopy $apk $1 "$2"
}

# Terminal Emulator
downloadFromFdroid com.termoneplus
#Navigation
downloadFromFdroid net.osmand.plus
#Calendar
downloadFromFdroid ws.xsoh.etar Calendar
#Pdf viewer
downloadFromFdroid com.artifex.mupdf.viewer.app
# Aurora App Store
downloadFromFdroid com.aurora.store
# F-Droid App Store
downloadFromFdroid org.fdroid.fdroid
#Mail client
downloadFromFdroid com.fsck.k9 "Email"
#Calendar/Contacts sync
downloadFromFdroid com.etesync.syncadapter
# Todo lists
downloadFromFdroid org.tasks
#Fake assistant that research on duckduckgo
downloadFromFdroid co.pxhouse.sas
# Gallery App
downloadFromFdroid com.simplemobiletools.gallery.pro "Photos Gallery Gallery2"
# Aurora Fdroid
downloadFromFdroid com.aurora.adroid
#Phonograph
downloadFromFdroid com.kabouzeid.gramophone "Eleven"
#Alarmio
downloadFromFdroid me.jfenn.alarmio "GoogleClock DeskClock"
#Mozilla Nlp
downloadFromFdroid org.microg.nlp.backend.ichnaea
#Nominatim Nlp
downloadFromFdroid org.microg.nlp.backend.nominatim
# Midori Browser
downloadFromFdroid org.midorinext.android

#Web browser
#~ downloadFromFdroid org.mozilla.fennec_fdroid "Browser2 QuickSearchBox"
#Public transportation
#~ downloadFromFdroid de.grobox.liberario
#Ciphered Instant Messaging
#downloadFromFdroid im.vector.alpha
#Nextcloud client
#~ downloadFromFdroid com.nextcloud.client
# Social Media Apps
#~ downloadFromFdroid org.mariotaku.twidere
#~ downloadFromFdroid com.pitchedapps.frost
#~ downloadFromFdroid com.keylesspalace.tusky

repo=https://microg.org/fdroid/repo/
downloadFromFdroid com.google.android.gms
downloadFromFdroid com.google.android.gsf
downloadFromFdroid com.android.vending
downloadFromFdroid org.microg.gms.droidguard

repo=https://nanolx.org/fdroid/repo/
downloadFromFdroid is.xyz.mpv

echo >> apps.mk

rm -Rf tmp
