#!/bin/bash
set -e

repo="https://f-droid.org/repo/"
reponano="https://nanolx.org/fdroid/repo/"
repomicrog="https://microg.org/fdroid/repo/"
repobromite="https://fdroid.bromite.org/fdroid/repo/"

addCopy() {
cat >> Android.mk <<EOF
include \$(CLEAR_VARS)
LOCAL_MODULE := $2
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := bin/$1
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_OVERRIDES_PACKAGES := $3
include \$(BUILD_PREBUILT)

EOF
echo -e "\t$2 \\" >> apps.mk
}

rm -Rf bin apps.mk
cat > Android.mk <<EOF
LOCAL_PATH := \$(my-dir)

EOF
echo -e 'PRODUCT_PACKAGES += \\' > apps.mk

mkdir -p bin
#downloadFromFdroid packageName overrides
downloadFromFdroid() {
	mkdir -p tmp
	if [ ! -f tmp/index.xml ];then
		#TODO: Check security keys
		wget --connect-timeout=10 $repo/index.jar -O tmp/index.jar
		unzip -p tmp/index.jar index.xml > tmp/index.xml
	fi
	marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]' -v ./marketvercode tmp/index.xml || true)"
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname tmp/index.xml || xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[1]' -v ./apkname tmp/index.xml)"
	while ! wget --connect-timeout=10 $repo/$apk -O bin/$apk;do sleep 1;done
	addCopy $apk $1 "$2"
}

#downloadFromNanodroid packageName overrides
downloadFromNanodroid() {
        if [ ! -f tmp/index.xml ];then
                #TODO: Check security keys
                wget --connect-timeout=10 $reponano/index.jar -O tmp/index.jar
                unzip -p tmp/index.jar index.xml > tmp/index.xml
        fi
        marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]' -v ./marketvercode tmp/index.xml || true)"
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname tmp/index.xml || xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[1]' -v ./apkname tmp/index.xml)"
        while ! wget --connect-timeout=10 $reponano/$apk -O bin/$apk;do sleep 1;done
        addCopy $apk $1 "$2"
}

#downloadFromNanodroid packageName overrides
downloadFrommicrog() {
        if [ ! -f tmp/index.xml ];then
                #TODO: Check security keys
                wget --connect-timeout=10 $repomicrog/index.jar -O tmp/index.jar
                unzip -p tmp/index.jar index.xml > tmp/index.xml
        fi
	marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]' -v ./marketvercode tmp/index.xml || true)"
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname tmp/index.xml || xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[1]' -v ./apkname tmp/index.xml)"
        while ! wget --connect-timeout=10 $repomicrog/$apk -O bin/$apk;do sleep 1;done
        addCopy $apk $1 "$2"
}
#downloadFromFdroid packageName overrides
downloadFromBromite() {
	mkdir -p tmp
	if [ ! -f tmp/index.xml ];then
		#TODO: Check security keys
		wget --connect-timeout=10 $repobromite/index.jar -O tmp/index.jar
		unzip -p tmp/index.jar index.xml > tmp/index.xml
	fi
	marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]' -v ./marketvercode tmp/index.xml || true)"
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname tmp/index.xml || xmlstarlet sel -t -m '//application[id="'"$1"'"]/package[1]' -v ./apkname tmp/index.xml)"
	while ! wget --connect-timeout=10 $repobromite/$apk -O bin/$apk;do sleep 1;done
	addCopy $apk $1 "$2"
}
#FDroid
downloadFromFdroid org.fdroid.fdroid
#YouTube viewer
downloadFromFdroid org.schabi.newpipe
#QKSMS
downloadFromFdroid com.moez.QKSMS "messaging" 
#Navigation
downloadFromFdroid net.osmand.plus
#Calendar
downloadFromFdroid ws.xsoh.etar "Calendar"
#DAV sync
downloadFromFdroid at.bitfire.davdroid
#Keyboard/IME
#downloadFromFdroid com.menny.android.anysoftkeyboard "LatinIME OpenWnn"
#Play Store download
downloadFromFdroid com.aurora.store
#Phonograph
downloadFromFdroid com.kabouzeid.gramophone "Eleven"
#Alarmio
downloadFromFdroid me.jfenn.alarmio "GoogleClock DeskClock"
#Simple Gallery
downloadFromFdroid com.simplemobiletools.gallery.pro "Gallery2"
#Simple Calculator
downloadFromFdroid com.simplemobiletools.calculator "ExactCalculator"
#Mozilla Nlp
downloadFromFdroid org.microg.nlp.backend.ichnaea
#Nominatim Nlp
downloadFromFdroid org.microg.nlp.backend.nominatim

rm -rf tmp/index.xml
rm -rf tmp/index.jar

#MPV
downloadFromNanodroid is.xyz.mpv
rm -rf tmp/index.xml
rm -rf tmp/index.jar
#MicroG service core
downloadFrommicrog com.google.android.gms
#MicroG droidguard helper
downloadFrommicrog org.microg.gms.droidguard
#MicroG services framework proxy
downloadFrommicrog com.google.android.gsf
#Fakestore
downloadFrommicrog  com.android.vending

rm -rf tmp/index.xml
rm -rf tmp/index.jar
#Web browser
# downloadFromBromite org.bromite.bromite "Browser2 QuickSearchBox Jelly"


#TODO: Some social network?
#Facebook? Twitter? Reddit? Mastodon?
echo >> apps.mk

rm -Rf tmp


