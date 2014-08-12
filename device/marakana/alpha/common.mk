# a global (variable to point to the alpha directory
MY_PATH := $(LOCAL_PATH)/../alpha

# include all the mk files in the subdirectories with one level deep
include $(call all-subdir-makefiles)
LOCAL_KERNEL:= $(MY_PATH)/kernel

# add the kernel
PRODUCT_COPY_FILES += $(LOCAL_KERNEL):kernel
PRODUCT_COPY_FILES += 
    $(MY_PATH)/init.goldfish.rc:root/init.goldfish.rc
PRODUCT_COPY_FILES += 
    $(MY_PATH)/ueventd.goldfish.rc:root/ueventd.goldfish.rc
PRODUCT_COPY_FILES += 
    $(MY_PATH)/fstab.goldfish:root/fstab.goldfish
    
# hardware specific features taken from core hardware
PRODUCT_COPY_FILES += \
                frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml
DEVICE_PACKAGE_OVERLAYS := $(MY_PATH)/overlay

