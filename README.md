# vendor branding profile
This repo includes the branding and app changes for vendor customization

Some preparation is needed to include apps into the builds. 

## Features:

 - Supports adding user apps or private apps to be included in the build
 - Supports both arm64-v8a, x86 & x86_64 ABIs through the use of Options
 - Generates a permissions.xml for including into AOSP based builds
 
##### Options Usage:
	 
	**If no option is passed, it will prompt you to make a choice**
	 
	 $ bash update.sh X
	 
	- 1 = x86_64 ABI **default options**
	- 2 = arm64-v8a ABI
	- 3 = x86 ABI

## AOSP Build Instructions:

To include the branding changes into your device specific builds. Please clone 
this repo into vendor/branding:

	$ git clone https://github.com/vendsy/vendor_branding vendor/branding

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

Then we need to update the base with our changes for the project. To do that, we first 
need to know if we are using Bliss-Bass or Bliss-Bass Go. 

*Bliss Bass:*

	$ check_patchsets
	
*Bliss Bass Go:*

	$  check_patchsets go
	
This will apply all the required changes for the project variant
(On new base updates, there is a chance of patchsets not applying cleanly. Some work will be 
needed to resolve patch conflicts before continuing to the next step)

#### Step 6: 

After patches apply successfully, you can use the following command to start a clean build:

	$ build-x86

When compile is complete, you can then find your .iso file in the iso/ folder 

## Overlays included:

We include a few of the overlays specific to branding in this project. 

 - Wallpapers
 - Bootanimation [WIP]
 - Advanced power-menu overrides
 - virtual keyboard overrides
 - etc.