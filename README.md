# vendor_foss
A set of FOSS applications to include in an AOSP

*with added options and features*

## Features:

 - Supports F-Droid Mirrors - So if main repo fails, it will try the 
   rest of the mirrors from the F-Droid mirror list
 - Supports both arm64-v8a, x86 & x86_64 ABIs through the use of Options
 - Generates foss-permissions.xml for including into AOSP based builds
 
##### Options Usage:
	 
	**If no option is passed, it will prompt you to make a choice**
	 
	 $ bash update.sh X
	 
	- 1 = x86_64 ABI **default options**
	- 2 = arm64-v8a ABI
	- 3 = x86 ABI

##### AOSP Build Instructions:

To include the FOSS apps into your device specific builds. Please clone 
this repo into vendor/foss:

	$ git clone https://github.com/BlissRoms-x86/vendor_foss vendor/foss
	
Then add this inherit to your device tree:

	# foss apps
	$(call inherit-product-if-exists, vendor/foss/foss.mk)

## Included Apps:

#### From F-Droid Repo:

- Calendar - ws.xsoh.etar
- Aurora App Store - com.aurora.store
- Aurora Fdroid - com.aurora.adroid
- Calendar/Contacts sync - com.etesync.syncadapter
- Fake assistant that uses duckduckgo - co.pxhouse.sas
- Gallery App - com.simplemobiletools.gallery.pro
- fdroid extension - org.fdroid.fdroid.privileged
- Alarmio - me.jfenn.alarmio
- Mozilla Nlp - org.microg.nlp.backend.ichnaea
- Nominatim Nlp - org.microg.nlp.backend.nominatim
- NewPipe - org.schabi.newpipe
- Midori Browser - org.midorinext.android

#### From MicroG Repo:

- MicroG GMS - com.google.android.gms
- MicroG GSF - com.google.android.gsf
- MicroG FakeStore - com.android.vending
- MicroG DroidGuard - org.microg.gms.droidguard 
 
#### From NanoLX Repo:
 
- MVP Video Player - is.xyz.mpv

### Notes

- For microG, this [commit](https://github.com/microg/android_packages_apps_GmsCore/pull/957) is needed
