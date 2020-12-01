# Set LMODroid specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit mini common LMODroid stuff
$(call inherit-product, vendor/lmodroid/config/common_mini_phone.mk)
