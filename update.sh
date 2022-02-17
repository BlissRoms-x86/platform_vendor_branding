#!/bin/bash
# set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LT_BLUE='\033[0;34m'

NC='\033[0m' # No Color

repo="https://f-droid.org/repo/"
repo2="https://bubu1.eu/fdroid/repo/"
repo3="https://fdroid.tetaneutral.net/fdroid/repo/"
repo4="https://mirror.cyberbits.eu/fdroid/repo/"
repo5="https://ftp.fau.de/fdroid/repo/"
repo6="https://ftp.osuosl.org/pub/fdroid/repo/"
repo7="https://mirror.scd31.com/fdroid/repo/"
repo8="https://plug-mirror.rcac.purdue.edu/fdroid/repo/"
repo9="https://mirrors.tuna.tsinghua.edu.cn/fdroid/repo/"
repo10="https://mirrors.nju.edu.cn/fdroid/repo/"
repo11="https://mirror.kumi.systems/fdroid/repo/"
repo12="https://ftp.lysator.liu.se/pub/fdroid/repo/"
repo13="https://mirror.librelabucm.org/fdroid/repo/"

microg="https://microg.org/fdroid/repo"
microg_dir="tmp/microg"

unofficial_mozilla="https://rfc2822.gitlab.io/fdroid-firefox/fdroid/repo"
unofficial_mozilla_dir="tmp/unofficial_mozilla"

bromite="https://fdroid.bromite.org/fdroid/repo"
bromite_dir="tmp/bromite"

nanolx="https://nanolx.org/fdroid/repo"
nanolx_dir="tmp/nanolx"

newpipe="https://archive.newpipe.net/fdroid/repo/"
newpipe_dir="tmp/newpipe"

# Device type selection	
if [ "$1" == "" ]; then
PS3='Which device type do you plan on building?: '
echo -e ${YELLOW}"(default is 'ABI:x86_64 & ABI2:x86')"
TMOUT=10
options=("ABI:x86_64 & ABI2:x86"
		 "ABI:arm64-v8a & ABI2:armeabi-v7a"
		 "ABI:x86")
echo -e "Timeout in $TMOUT sec."${NC}
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
		"ABI:x86")
			echo "you chose choice $REPLY which is $opt"
			MAIN_ARCH="x86"
			break
			;;
		"ABI:armeabi-v7a")
			echo "you chose choice $REPLY which is $opt"
			MAIN_ARCH="armeabi-v7a"
			break
			;;
		*) echo "invalid option $REPLY";;
	esac
done
if [ "$opt" == "" ]; then
	MAIN_ARCH="x86_64"
	SUB_ARCH="x86"	
fi
fi

if [ "$1" == "1" ]; then
	echo "ABI:x86_64 & ABI2:x86 was preselected"
	MAIN_ARCH="x86_64"
	SUB_ARCH="x86"	
fi
if [ "$1" == "2" ]; then
	echo "ABI:arm64-v8a & ABI2:armeabi-v7a was preselected"
	MAIN_ARCH="arm64-v8a"
	SUB_ARCH="armeabi-v7a"
fi
if [ "$1" == "3" ]; then
	echo "ABI:x86 & ABI2:x86 was preselected"
	MAIN_ARCH="x86"
fi
if [ "$1" == "4" ]; then
	echo "ABI:armeabi-v7a was preselected"
	MAIN_ARCH="armeabi-v7a"
fi

addCopy() {
	addition=""
	if [ "$native" != "" ]
	then
		unzip bin/$1 "lib/*"
		if [ "$native" == "$MAIN_ARCH" ];then
			addition="
LOCAL_PREBUILT_JNI_LIBS := \\
$(unzip -olv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/'"$MAIN_ARCH"'/.*);\t\1 \\;p')
			"
		fi
		if [ "$native" == "$SUB_ARCH" ];then
			addition="
LOCAL_MULTILIB := 32
LOCAL_PREBUILT_JNI_LIBS := \\
$(unzip -olv bin/$1 |grep -v Stored |sed -nE 's;.*(lib/'"$SUB_ARCH"'/.*);\t\1 \\;p')
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
rm -Rf apps.mk lib bin 
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
		failed_count=0
		array=( $repo $repo2 $repo3 $repo4 $repo5 $repo6 $repo7 $repo8 $repo9 $repo10 $repo11 $repo12 $repo13 )
		for url in $repo $repo2 $repo3 $repo4 $repo5 $repo6 $repo7 $repo8 $repo9 $repo10 $repo11 $repo12 $repo13 ; do
			echo -e "${GREEN}# Trying: $url ${NC}"
			if wget --connect-timeout=10 --tries=2 ${url}index.jar -O tmp/index.jar; then
				unzip -p tmp/index.jar index.xml > tmp/index.xml
				echo -e "${GREEN}# Downloaded from $url ${NC}"
				failed=
				repo=${url}
				passed=true
				break
			elif [ "$failed" ]; then
				echo -e "${YELLOW}# $url broken ${NC}"
				failed=true
				failed_count=$((failed_count+1))
			else
				echo -e "${YELLOW}# $url failed ${NC}"
				failed=true
				failed_count=$((failed_count+1))
			fi
			
		done
		echo -e "${Yellow}# Total mirrors: ${#array[@]} ${NC}"
		if [ "$failed_count" >= 1 ]; then
			echo -e "${RED}# Failed $failed_count mirrors ${NC}"
		fi
		if [ "$failed_count" == "${#array[@]}" ]; then
			echo -e "${RED}# Failed too many mirrors: $failed_count ${NC}"
			exit
			
		fi
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

downloadStuff() {
	    what="$1"
		where="$2"
		
		while ! wget --connect-timeout=10 --tries=2 "$what" -O "$where";do sleep 1;done
}

#downloadFromRepo repo repo_dir packageName overrides
downloadFromRepo() {
		repo="$1"
		repo_dir="$2"
		package="$3"
		overrides="$4"
				
		mkdir -p "$repo_dir"
	if [ ! -f "$repo_dir"/index.xml ];then
		downloadStuff "$repo"/index.jar "$repo_dir"/index.jar
		unzip -po "$repo_dir"/index.jar index.xml > "$repo_dir"/index.xml
	fi
	
		#~ marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$package"'"]' -v ./marketvercode "$repo_dir"/index.xml || true)"
		marketvercode="$(xmlstarlet sel -t -m '//application[id="'"$package"'"]' -v ./nativecode "$repo_dir"/index.xml || true)"
		apk="$(xmlstarlet sel -t -m '//application[id="'"$package"'"]/package[versioncode="'"$marketvercode"'"]' -v ./apkname "$repo_dir"/index.xml || xmlstarlet sel -t -m '//application[id="'"$package"'"]/package[1]' -v ./apkname "$repo_dir"/index.xml)"
		downloadStuff "$repo"/"$apk" bin/"$apk"

		addCopy "$apk" "$package" "$overrides"
}


echo -e "${YELLOW}# grabbing Arora and F-Droid Apps${NC}"

#Web browser
#~ downloadFromFdroid org.mozilla.fennec_fdroid "Browser2 QuickSearchBox Jelly"

if [ $2 == "bromite" ]; then
downloadFromRepo "$bromite" "$bromite_dir" org.bromite.bromite "Browser2 QuickSearchBox Jelly"
downloadFromRepo "$bromite" "$bromite_dir" com.android.webview "WebView"
fi

#~ downloadFromRepo "$unofficial_mozilla" "$unofficial_mozilla_dir" org.mozilla.firefox "Browser2 QuickSearchBox Jelly"
#icecat 
#~ downloadFromFdroid org.gnu.icecat "Browser2 QuickSearchBox"
#Public transportation

# Terminal Emulator
#~ downloadFromFdroid com.termoneplus
#Navigation
#~ downloadFromFdroid net.osmand.plus
#Pdf viewer
#~ downloadFromFdroid com.artifex.mupdf.viewer.app
# Aurora App Store
downloadFromFdroid com.aurora.store
#Mail client
#~ downloadFromFdroid com.fsck.k9 "Email"
#Calendar/Contacts sync
downloadFromFdroid com.etesync.syncadapter
# Todo lists
#~ downloadFromFdroid org.tasks
# Aurora Fdroid
downloadFromFdroid com.aurora.adroid
# F-Droid App Store
#~ downloadFromFdroid org.fdroid.fdroid
#fdroid extension
downloadFromFdroid org.fdroid.fdroid.privileged
#Phonograph
#~ downloadFromFdroid com.kabouzeid.gramophone "Eleven"
#Mozilla Nlp
downloadFromFdroid org.microg.nlp.backend.ichnaea
#Nominatim Nlp
downloadFromFdroid org.microg.nlp.backend.nominatim
# EtchDroid USB Writer
#~ downloadFromFdroid eu.depau.etchdroid

if [ $2 == "extras" ]; then
#Calendar
downloadFromFdroid ws.xsoh.etar "Calendar"
#Fake assistant that research on duckduckgo
downloadFromFdroid co.pxhouse.sas
# Gallery App
downloadFromFdroid com.simplemobiletools.gallery.pro "Photos Gallery Gallery2"
#Alarmio
 downloadFromFdroid me.jfenn.alarmio "GoogleClock DeskClock"
# NewPipe (outdated)
downloadFromFdroid org.schabi.newpipe

echo -e "${YELLOW}# grabbing NanoLX Apps${NC}"
downloadFromRepo "$nanolx" "$nanolx_dir" is.xyz.mpv
fi

if [ $2 == "astian" ]; then
#  Astian Apps
# Midori Browser
downloadFromFdroid org.midorinext.android "Browser2 QuickSearchBox Jelly"
# Astian Spika
# downloadFromFdroid org.astianspika.android
# Astian Cloud
# downloadFromFdroid org.astiancloud.android
# Astian VPN
# downloadFromFdroid org.astianvpn.android
fi

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
downloadFromRepo "$microg" "$microg_dir" com.google.android.gms
downloadFromRepo "$microg" "$microg_dir" com.google.android.gsf
downloadFromRepo "$microg" "$microg_dir" com.android.vending "Google Play Store"
downloadFromRepo "$microg" "$microg_dir" org.microg.gms.droidguard

#~ echo -e "${YELLOW}# grabbing NewPipe ${NC}"
#~ downloadFromRepo "$newpipe" "$newpipe_dir" org.schabi.newpip

echo -e "${LT_BLUE}# finishing up apps.mk${NC}"
echo >> apps.mk

echo -e "${YELLOW}# Cleaning up${NC}"
rm -Rf tmp

bash generate_perms.sh 

echo -e "${GREEN}# DONE${NC}"
