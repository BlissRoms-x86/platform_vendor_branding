# vendor branding profile
This repo includes the vendor customization layer for Bliss-Bass.
This is used to help with rebranding and app changes for Bliss OS based builds, targeting kiosks and single application use cases

Some preparation is needed to include apps into the builds. 

## Features:

 - Supports adding user apps or private apps to be included in the build
 - Supports arm64-v8a, x86 & x86_64 ABIs through the use of Options
 - Generates a permissions.xml for including into AOSP based builds
 - Generates default wallpaper overlays
 - Generates branded bootanimation based on a single loop of frames
 - Supports applying separate patchsets on-top of Bliss OS or Bliss OS Go source updates
 - More to come (let us know what you would like to see)
 
##### Options Usage:
	 
	**If no option is passed, it will prompt you to make a choice**
	 
	 $ bash update.sh X
	 
	- 1 = x86_64 ABI **default options**
	- 2 = arm64-v8a ABI
	- 3 = x86 ABI

## AOSP Build Instructions:

To include the branding changes into your device specific builds. Please clone 
this repo into vendor/branding:

	$ git clone https://github.com/BlissRoms-x86/platform_vendor_branding vendor/branding

#### Step 1:
	
Add this inherit to your device tree:

	# vendor/branding
	$(call inherit-product-if-exists, vendor/branding/branding.mk)

#### Step 2:

Place target prebuilt apk files in the following folders:

 - prebuilts/priv-apps/ - Any apps found in here will be added as a privelaged app
 - prebuilts/apps - Any apps found in here will be added as a normal user app

#### Step 3:

Run the `update.sh` script from inside this project folder to start generate the 
makefiles and permissions.xml automatically

Example:

	$ bash update.sh 1

#### Step 4:

From here we can cd back to our project directory and run:

	$ . build/envsetup.sh

#### Step 5:

To apply the changes for Bliss Bass, we need to update the base with our changes for the project. To do that, we first 
need to know if we are using Bliss-Bass or Bliss-Bass Go. 

*ATTN VENDORS:* To add your changes to this patching system, you will first need to know your base OS, and then run off your changes as .patch files:

	$ cd bootable/newinstaller
 	$ git format-patch -1

Then copy that .patch file to patches/patchsets(-go)/bootable/newinstaller/, and then cd back to your project folder and continue below

*Bliss Bass:*

	$ check_patchsets
	
*Bliss Bass Go:*

	$  check_patchsets go
	
This will apply all the required changes for the project variant
(On new base updates, there is a chance of patchsets not applying cleanly. Some work will be 
needed to resolve patch conflicts before continuing to the next step)

**NOTE** New patchsets can also be created and saved to patches/patchsets-<your_patchset_name>, then applied using:

	$ check_patchsets <your_patchset_name>  


#### Step 6: 

Prepare your branding changes:

 - default wallpaper: Place default_wallpaper.png in branding/wallpaper/ replacing the file there already
 - bootanimation: Place a bootanimation.tar of your bootanimation frames in branding/bootanimation/

When lunch is triggered, it will copy your branding files over to the proper overlays or package them in the build phase.

#### Step 7:

After patches apply successfully, you can use the following command to start a clean build:

	$ build-x86

When compile is complete, you can then find your .iso file in the iso/ folder 

## Overlays included:

We include a few of the overlays specific to branding in this project. 

 - Wallpapers
 - Bootanimation
 - Advanced power-menu overrides
 - virtual keyboard overrides
 - etc.
