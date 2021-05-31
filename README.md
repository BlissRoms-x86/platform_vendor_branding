# vendor_foss
A set of FOSS applications to include in an AOSP

*with added options and features*

## Features:

 - Supports F-Droid Mirrors - So if main repo fails, it will try the 
   rest of the mirrors from the F-Droid mirror list
 - Supports both arm64-v8a & x86_64 ABI through the use of Options
 
	##### Options Usage:
	 
	**If no option is passed, it will prompt you to make a choice**
	 
	 $ bash update.sh X
	 
	- 1 = x86_64 ABI **default options**
	- 2 = arm64-v8a ABI
	- 3 = x86 ABI

## Included Apps:

#### From F-Droid Repo:

- Terminal Emulator - com.termoneplus
- Navigation - net.osmand.plus
- Calendar - ws.xsoh.etar
- Pdf viewer - com.artifex.mupdf.viewer.app
- Aurora App Store - com.aurora.store
- Aurora Fdroid - com.aurora.adroid
- K9 Mail client - com.fsck.k9
- Calendar/Contacts sync - com.etesync.syncadapter
- Todo lists - org.tasks
- Fake assistant that uses duckduckgo - co.pxhouse.sas
- Gallery App - com.simplemobiletools.gallery.pro
- fdroid extension - org.fdroid.fdroid.privileged
- Phonograph - com.kabouzeid.gramophone
- Alarmio - me.jfenn.alarmio
- Mozilla Nlp - org.microg.nlp.backend.ichnaea
- Nominatim Nlp - org.microg.nlp.backend.nominatim
- EtchDroid USB Writer - eu.depau.etchdroid
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
