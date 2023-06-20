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

# save the official lunch command to aosp_lunch() and source it
tmp_lunch=`mktemp`
sed '/ lunch()/,/^}/!d'  build/envsetup.sh | sed 's/function lunch/function aosp_lunch/' > ${tmp_lunch}
source ${tmp_lunch}
rm -f ${tmp_lunch}

function  apply_patch
{

local patch_folder=$1
echo "patch folder: $patch_folder"

}

# Override lunch function to filter lunch targets
function lunch
{
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "[lunch] Couldn't locate the top of the tree.  Try setting TOP." >&2
        return
    fi

    aosp_lunch $*

    copy_wallpaper

}

# Copy wallpaper
# copy and replace any image found in vendor/branding/branding/wallpaper to 
# vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-*
function copy_wallpaper()
{
    if [ -f vendor/branding/branding/wallpaper/* ]; then
        echo -e "Wallpaper branding found. Updating that now..."
        echo ""
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-hdpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-mdpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-nodpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-xhdpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-xxhdpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-xxxhdpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-sw600dp-nodpi/
        cp -r vendor/branding/branding/wallpaper/* vendor/branding/overlay/common/frameworks/base/core/res/res/drawable-sw720dp-nodpi/
        echo -e "Wallpaper branding updated"
    fi
}

# Get the exact value of a build variable.
function get_build_var()
{
    if [ "$1" = "COMMON_LUNCH_CHOICES" ]
    then
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
        if [ "$BUILD_VAR_CACHE_READY" = "true" ]
        then
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
	bash vendor/branding/tools/build-x86.sh
}