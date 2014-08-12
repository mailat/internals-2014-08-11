# a global (variable to point to the alpha directory
MY_PATH := $(LOCAL_PATH)/../alpha

# include all the mk files in the subdirectories with one level deep
include $(call all-subdir-makefiles)

# hardware specific features taken from core hardware
PRODUCT_COPY_FILES += \
                frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml
DEVICE_PACKAGE_OVERLAYS := $(MY_PATH)/overlay

