# Inherit common LMODroid stuff
$(call inherit-product, vendor/lmodroid/config/common.mk)

# Inherit LMODroid atv device tree
$(call inherit-product, device/lmodroid/atv/lmodroid_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

# Lineage packages
PRODUCT_PACKAGES += \
    LineageCustomizer

DEVICE_PACKAGE_OVERLAYS += vendor/lmodroid/overlay/tv
