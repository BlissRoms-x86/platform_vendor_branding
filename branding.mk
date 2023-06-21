-include vendor/branding/apps.mk

# Common Overlays
DEVICE_PACKAGE_OVERLAYS += vendor/branding/overlay/common

# Allow overlays to be excluded from enforcing RRO
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/branding/overlay/common

# Bootanimation
TARGET_SCREEN_WIDTH ?= 800		
TARGET_SCREEN_HEIGHT ?= 800
PRODUCT_PACKAGES += \
    bootanimation.zip

# Copy any Permissions files, overriding anything if needed
$(foreach f,$(wildcard $(LOCAL_PATH)/permissions/*.xml),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/$(notdir $f)))
