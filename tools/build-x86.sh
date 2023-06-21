. build/envsetup.sh && make clean && \
export RELEASE_OS_TITLE="BlissBass" && \
export USE_SMARTDOCK=false && \
export USE_KERNEL_SU_PLUS=false && \
export USE_FOSSAPPS=false && \
export BLISS_BUILD_VARIANT=vanilla && \
export IS_GO_VERSION=false && \
export BLISS_SUPER_VANILLA=true && \
export USE_GO_RES_ICONS=false && \
export BLISS_SPECIAL_VARIANT=-test-1 && \
lunch bliss_x86_64-userdebug && make iso_img -j$(expr $(nproc) / 2)