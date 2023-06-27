# Bliss-Bass branding profile
#
# This is part of the Bliss-Bass vendor template and
# is used to set the branding profile for your project
#
# Based on the original work from Intel's ProjectCeladon
# with a few modifications. 
#
# Copyright (C) 2019 Intel Corporation. All rights reserved.
# Author: sgnanase <sundar.gnanasekaran@intel.com>
# Author: Sun, Yi J <yi.j.sun@intel.com>
#
# SPDX-License-Identifier: BSD-3-Clause

# set -e

# save the official lunch command to aosp_lunch() and source it
tmp_lunch=`mktemp`

# !!! Update this to your own path !!!
vendor_name="branding"

#setup colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
purple=`tput setaf 5`
teal=`tput setaf 6`
light=`tput setaf 7`
dark=`tput setaf 8`
ltred=`tput setaf 9`
ltgreen=`tput setaf 10`
ltyellow=`tput setaf 11`
ltblue=`tput setaf 12`
ltpurple=`tput setaf 13`
CL_CYN=`tput setaf 12`
CL_RST=`tput sgr0`
reset=`tput sgr0`


SCRIPT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo "SCRIPT_PATH: $SCRIPT_PATH"
export PATH="$SCRIPT_PATH/includes/core-menu/includes/:$PATH"
source $SCRIPT_PATH/includes/core-menu/includes/easybashgui
source $SCRIPT_PATH/includes/core-menu/includes/common.sh
export supertitle="Bliss-Bass Vendor Customization"

# source the official lunch command
sed '/ lunch()/,/^}/!d'  build/envsetup.sh | sed 's/function lunch/function aosp_lunch/' > ${tmp_lunch}
source ${tmp_lunch}
rm -f ${tmp_lunch}

# Override lunch function to filter lunch targets
function lunch
{
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "[lunch] Couldn't locate the top of the tree.  Try setting TOP." >&2
        return
    fi

    menu_redirect
    copy_wallpaper
    copy_grub_background
    aosp_lunch $*

}

# Redirect menu function
function menu_redirect()
{
    
    echo -e ""
    echo -e "${ltblue}
██████  ██      ██ ███████ ███████ 
██   ██ ██      ██ ██      ██      
██████  ██      ██ ███████ ███████ 
██   ██ ██      ██      ██      ██ 
██████  ███████ ██ ███████ ███████ 
                                   
                                   
██████   █████  ███████ ███████    
██   ██ ██   ██ ██      ██         
██████  ███████ ███████ ███████    
██   ██ ██   ██      ██      ██    
██████  ██   ██ ███████ ███████   
    ${CL_RST}"

    # wait 5 seconds for user to press 'm'. If input is 'm', then launch menu function, else continue
    echo -e "${ltgreen}\nPress 'm' followed by return within 5 seconds to launch Bliss-Bass Vendor Customization Menu...${CL_RST}"
    # use read command with timeout of 5 seconds
    read -t 5 -p "Prompt " LAUNCH_MENU
    if [[ $? -gt 128 ]] ; then
        echo -e "\nTimeout"
    else if [[ "$LAUNCH_MENU" == "m" ]]; then
        echo "Response = \"$LAUNCH_MENU\"" 
        launch_menu
        fi
    fi
}

function launch_menu() 
{
    bash vendor/$vendor_name/includes/core-menu/core-menu.sh --config vendor/$vendor_name/includes/menus/branding-menu/branding-menu.json
}

# function to browser for new wallpaper
function vcl-wallpaper()
{
    # Select wallpaper
    message "Please select your .png wallpaper: "
    fselect 
    wallpaper_path=$(0<"${dir_tmp}/${file_tmp}")
    echo "wallpaper_path = $wallpaper_path"
    if [ -f $wallpaper_path ]; then
        # copy wallpaper to temp folder
        mkdir -p $SCRIPT_PATH/tmp
        cp -r -f $wallpaper_path $SCRIPT_PATH/branding/wallpaper/default_wallpaper.png
        message "New Wallpaper copied."
    else
        message "Wallpaper not found."
    fi
}

# Copy wallpaper
# copy and replace any image found in vendor/$vendor_name/branding/wallpaper to 
# vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-*
function copy_wallpaper()
{
    if [ -f vendor/$vendor_name/branding/wallpaper/* ]; then
        echo -e "Wallpaper branding found. Updating that now..."
        echo ""
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-hdpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-mdpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-nodpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-xhdpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-xxhdpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-xxxhdpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-sw600dp-nodpi/
        cp -r vendor/$vendor_name/branding/wallpaper/* vendor/$vendor_name/overlay/common/frameworks/base/core/res/res/drawable-sw720dp-nodpi/
        echo -e "Wallpaper branding updated"
    fi
}

function copy_grub_background()
{
    if [ -f vendor/$vendor_name/branding/grub/* ]; then
        echo -e "Grub branding found. Updating that now..."
        echo ""
        cp -r vendor/$vendor_name/branding/grub/* vendor/$vendor_name/overlay/common/bootable/newinstaller/boot/isolinux/android-x86.png
        echo -e "Grub branding updated"
    fi
}

function check_patchsets() 
{
    patchset_type=$1
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "[lunch] Couldn't locate the top of the tree.  Try setting TOP." >&2
        return
    fi
    # Find the first folder in vendor/$vendor_name/patches/patchsets
    are_patchsets=`ls vendor/$vendor_name/patches/patchsets`
    if [ ! "$are_patchsets" ]; then
        echo "[lunch] No patchsets found"
        return
    else
        echo "[lunch] Patchsets found"
        if [ "$patchset_type" != "" ]; then
            if [ -d vendor/$vendor_name/patches/patchsets-$patchset_type ]; then
                bash vendor/$vendor_name/patches/autopatch.sh vendor/$vendor_name/patches/patchsets-$patchset_type
            else
                echo "No patchsets found for $patchset_type"
            fi
        else
            bash vendor/$vendor_name/patches/autopatch.sh vendor/$vendor_name/patches/patchsets
        fi
    fi
}

# Get the exact value of a build variable.
function get_build_var()
{
    if [ "$1" = "COMMON_LUNCH_CHOICES" ]; then
        valid_targets=`mixinup -t`
        save=`build/soong/soong_ui.bash --dumpvar-mode $1`
        unset LUNCH_MENU_CHOICES
        for t in ${save[@]}; do
            array=(${t/-/ })
            target=${array[0]}
            if [[ "${valid_targets}" =~ "$target" ]]; then
                   LUNCH_MENU_CHOICES+=($t)
            fi
        done
        echo ${LUNCH_MENU_CHOICES[@]}
        return
    else
        if [ "$BUILD_VAR_CACHE_READY" = "true" ]; then
            eval "echo \"\${var_cache_$1}\""
            return
        fi

        local T=$(gettop)
        if [ ! "$T" ]; then
            echo "Couldn't locate the top of the tree.  Try setting TOP." >&2
            return
        fi
        (\cd $T; build/soong/soong_ui.bash --dumpvar-mode $1)
    fi
}

function build-x86()
{
	bash vendor/$vendor_name/tools/build-x86.sh
}
