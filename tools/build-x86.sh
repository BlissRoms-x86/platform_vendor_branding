#!/bin/bash

. build/envsetup.sh && make clean && \
export RELEASE_OS_TITLE="EIDU-BlissOS" && \
export USE_SMARTDOCK=false && \
export USE_KERNEL_SU_PLUS=false && \
export USE_FOSSAPPS=true && \
export BLISS_BUILD_VARIANT=foss && \
export IS_GO_VERSION=true && \
export BLISS_SUPER_VANILLA=true && \
export USE_GO_RES_ICONS=true && \
export BLISS_SPECIAL_VARIANT=-Taifa-ElimuTab-preview && \
export USE_BLISS_SETUPWIZARD=true && \
lunch bliss_x86_64-userdebug && make iso_img -j$(expr $(nproc) / 2)

# Look in out/target/product/x86_64/ for the .iso, .sha256 and Changelog* files,
# and copy them to a new /iso directory. using the filename of the .iso for the directory name and the .iso file name.
mkdir -p iso
iso_exists=$(find out/target/product/x86_64/ -maxdepth 1 -mindepth 1 -type f -name "*.iso")
if [[  "$iso_exists" != "" ]]; then iso_name=$(basename "$iso_exists"); cp "$iso_exists" iso/"$iso_name"; fi
sha256_exists=$(find out/target/product/x86_64/ -maxdepth 1 -mindepth 1 -type f -name "*.sha256")
if [[  "$sha256_exists" != "" ]]; then sha256_name=$(basename "$sha256_exists"); cp "$sha256_exists" iso/"$iso_name.sha256"; fi
changelog_exists=$(find out/target/product/x86_64/ -maxdepth 1 -mindepth 1 -type f -name "Changelog*")
if [[  "$changelog_exists" != "" ]]; then changelog_name=$(basename "$changelog_exists"); cp "$changelog_exists" iso/"$iso_name.changelog"; fi
