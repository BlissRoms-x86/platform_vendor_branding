-include vendor/foss/apps.mk

PRODUCT_PACKAGES += \
	FDroidPrivilegedExtension \
	Provision

# Copy any Permissions files, overriding anything if needed
$(foreach f,$(wildcard $(LOCAL_PATH)/permissions/*.xml),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/$(notdir $f)))
