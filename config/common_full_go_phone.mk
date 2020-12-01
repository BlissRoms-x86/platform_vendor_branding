# Set LMODroid specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit full common LMODroid stuff
$(call inherit-product, vendor/lmodroid/config/common_full_phone.mk)
