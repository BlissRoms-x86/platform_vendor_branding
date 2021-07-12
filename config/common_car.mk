# Inherit common LMODroid stuff
$(call inherit-product, vendor/lmodroid/config/common.mk)

# Inherit LMODroid car device tree
$(call inherit-product, device/lmodroid/car/lmodroid_car.mk)

# Inherit the main AOSP car makefile that turns this into an Automotive build
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
