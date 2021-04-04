#!/bin/bash
#~ set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LT_BLUE='\033[0;34m'

NC='\033[0m' # No Color

repo="https://f-droid.org/repo/"

# Device type selection	
PS3='Which device type do you plan on building?: '
echo -e ${CL_CYN}"(default is 'ABI:x86_64 & ABI2:x86')"
TMOUT=10
options=("ABI:x86_64 & ABI2:x86"
		 "ABI:arm64-v8a & ABI2:armeabi-v7a")
echo "Timeout in $TMOUT sec."${CL_RST}
select opt in "${options[@]}"
do
	case $opt in
		"ABI:x86_64 & ABI2:x86")
			echo "you chose choice $REPLY which is $opt"
			MAIN_ARCH="x86_64"
			SUB_ARCH="x86"	
			break
			;;
		"ABI:arm64-v8a & ABI2:armeabi-v7a")
			echo "you chose choice $REPLY which is $opt"
			MAIN_ARCH="arm64-v8a"
			SUB_ARCH="armeabi-v7a"
			break
			;;
		*) echo "invalid option $REPLY";;
	esac
done
if [ "$opt" == "" ]; then
	MAIN_ARCH="x86_64"
	SUB_ARCH="x86"	
fi

addCopy() {
	addition=""
	if [ "$native" != "" ]
	then
		unzip bin/$1 "lib/*"
		if [ "$native" == "$MAIN_ARCH" ];then
			addition="
LOCAL_PREBUILT_JNI_LIBS := \\
$(unzip -lv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/'"$MAIN_ARCH"'/.*);\t\1 \\;p')
			"
		fi
		if [ "$native" == "$SUB_ARCH" ];then
			addition="
LOCAL_MULTILIB := 32
LOCAL_PREBUILT_JNI_LIBS := \\
$(unzip -lv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/'"$SUB_ARCH"'/.*);\t\1 \\;p')
			"
		fi
	fi
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

echo -e "${LT_BLUE}# Setting Up${NC}"
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
	
	index=1
	apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./apkname tmp/index.xml)"
	native="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./nativecode tmp/index.xml)"
	if [ "$native" != "" ]
	then
		index=1
		while true
		do
			apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./apkname tmp/index.xml)"
			native="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./nativecode tmp/index.xml)"
			if [ "$native" != "" ] && [ "$(echo $native | grep $MAIN_ARCH)" != "" ]
			then
				native=$MAIN_ARCH
				echo -e "${YELLOW}# native is $native ${NC}"
				break
			fi
			if [ "$native" == "" ]
			then
				echo -e "${YELLOW}# native is blank or $native ${NC}"
				break
			fi
			index=$((index + 1))
		done
		if [ "$native" != "$MAIN_ARCH" ]
		then
			index=1
			while true
			do
				apk="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./apkname tmp/index.xml)"
				native="$(xmlstarlet sel -t -m '//application[id="'"$1"'"]/package['$index']' -v ./nativecode tmp/index.xml)"
				if [ "$native" != "" ] && [ "$(echo $native | grep $SUB_ARCH)" != "" ]
				then
					native=$SUB_ARCH
					echo -e "${YELLOW}# native is $native ${NC}"
					break
				fi
				index=$((index + 1))
			done
			if [ "$native" != "$SUB_ARCH" ]
			then
				echo -e "${RED} $1 is not available in $MAIN_ARCH nor $SUB_ARCH ${NC}"
				exit 1
			fi
		fi
	fi
    if [ ! -f bin/$apk ];then
        while ! wget --connect-timeout=10 $repo/$apk -O bin/$apk;do sleep 1;done
    else
		echo -e "${GREEN}# Already grabbed $apk ${NC}"
    fi
	addCopy $apk $1 "$2"
}

echo -e "${YELLOW}# grabbing F-Droid Apps${NC}"
# Terminal Emulator
downloadFromFdroid com.termoneplus
#Navigation
downloadFromFdroid net.osmand.plus
#Calendar
downloadFromFdroid ws.xsoh.etar "Calendar"
#Pdf viewer
downloadFromFdroid com.artifex.mupdf.viewer.app
# Aurora App Store
downloadFromFdroid com.aurora.store
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
# F-Droid App Store
#~ downloadFromFdroid org.fdroid.fdroid
#fdroid extension
#~ downloadFromFdroid org.fdroid.fdroid.privileged
#Phonograph
downloadFromFdroid com.kabouzeid.gramophone "Eleven"
#Alarmio
downloadFromFdroid me.jfenn.alarmio "GoogleClock DeskClock"
#Mozilla Nlp
downloadFromFdroid org.microg.nlp.backend.ichnaea
#Nominatim Nlp
downloadFromFdroid org.microg.nlp.backend.nominatim
# Midori Browser
downloadFromFdroid org.midorinext.android "Browser2 QuickSearchBox"
# EtchDroid USB Writer
downloadFromFdroid eu.depau.etchdroid
# NewPipe
downloadFromFdroid org.schabi.newpipe

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

echo -e "${YELLOW}# grabbing MicroG Apps${NC}"
repo=https://microg.org/fdroid/repo/
downloadFromFdroid com.google.android.gms
downloadFromFdroid com.google.android.gsf
downloadFromFdroid com.android.vending
downloadFromFdroid org.microg.gms.droidguard

echo -e "${YELLOW}# grabbing NanoLX Apps${NC}"
repo=https://nanolx.org/fdroid/repo/
downloadFromFdroid is.xyz.mpv

echo -e "${LT_BLUE}# finishing up apps.mk${NC}"
echo >> apps.mk

echo -e "${YELLOW}# Cleaning up${NC}"
rm -Rf tmp

echo -e "${GREEN}# DONE${NC}"
