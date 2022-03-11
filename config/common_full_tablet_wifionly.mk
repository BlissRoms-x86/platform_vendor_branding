# Inherit full common LMODroid stuff
$(call inherit-product, vendor/lmodroid/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    androidx.window.extensions \
    LatinIME
